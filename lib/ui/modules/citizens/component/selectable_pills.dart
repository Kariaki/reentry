import 'package:flutter/material.dart';

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

  String selectedOption = "Personal growth"; // Default selected option

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Colors.black, // Background color matching the image
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: options.map((option) {
          bool isSelected = selectedOption == option;
          return ChoiceChip(
            label: Text(
              option,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            selected: isSelected,
            onSelected: (selected) {
              setState(() {
                selectedOption = option;
              });
            },
            backgroundColor: Colors.black,
            selectedColor: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.white, width: 1),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          );
        }).toList(),
      ),
    );
  }
}
