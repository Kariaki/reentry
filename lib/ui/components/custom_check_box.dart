// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:reentry/core/theme/colors.dart';
class CustomCheckbox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;

  const CustomCheckbox({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onChanged?.call(!widget.value);

      },
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          border: !widget.value?Border.all(color: AppColors.primary): Border.all(color: AppColors.inputBorderColor),
          borderRadius: BorderRadius.circular(4),
          color: widget.value ?
              AppColors.primary: Colors.transparent,
        ),
        child: widget.value
            ? Icon(
          Icons.check,
          color: Colors.white,
          size: 18,
        )
            : null,
      ),
    );
  }
}
