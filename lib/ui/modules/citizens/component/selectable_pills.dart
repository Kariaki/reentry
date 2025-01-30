import 'package:flutter/material.dart';
import 'package:reentry/core/extensions.dart';

class SelectablePills extends StatefulWidget {
  const SelectablePills({super.key});

  @override
  _SelectablePillsState createState() => _SelectablePillsState();
}

class _SelectablePillsState extends State<SelectablePills> {
  List<String> options = [
    "Personal growth",
    "Health",
    "Financial",
    "Relationship",
    "Career/Business",
    "Family",
    "Spiritual"
  ];

  String selectedOption = "Personal growth";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: options.map((option) {
          bool isSelected = selectedOption == option;
          return ChoiceChip(
            label: Text(
              option,
              style: context.textTheme.bodySmall?.copyWith(
                  color: isSelected ? const Color(0xFF1C1C1C) : Colors.white,
                  fontSize: 14),
            ),
            selected: isSelected,
            onSelected: (selected) {
              setState(() {
                selectedOption = option;
              });
            },
            backgroundColor: const Color(0xFF1C1C1C),
            selectedColor: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.white, width: 1),
              borderRadius: BorderRadius.circular(6),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          );
        }).toList(),
      ),
    );
  }
}
