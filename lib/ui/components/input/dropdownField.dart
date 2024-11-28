// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:reentry/core/theme/colors.dart';

class DropdownField<T> extends StatelessWidget {
  final String? label;
  final String hint;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final Widget? prefixIcon;
  final String? error;
  final double? radius;
  final Color? fillColor;
  final Color? textColor;
  final Color? borderColor;
  final bool enabled;

  const DropdownField({
    super.key,
    this.label,
    required this.hint,
    required this.items,
    required this.onChanged,
    this.value,
    this.prefixIcon,
    this.error,
    this.radius,
    this.fillColor,
    this.textColor,
    this.borderColor,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: TextStyle(
              color: AppColors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
        ],
        InputDecorator(
          decoration: InputDecoration(
            filled: true,
            fillColor: fillColor ?? AppColors.greyDark,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 3,
              horizontal: 10,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius ?? 10),
              borderSide: BorderSide(
                color: borderColor ?? AppColors.inputBorderColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius ?? 10),
              borderSide: BorderSide(
                color: borderColor ?? AppColors.inputBorderColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius ?? 10),
              borderSide: BorderSide(
                color: AppColors.primary,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius ?? 10),
              borderSide: BorderSide(
                color: AppColors.inputBorderColor.withOpacity(0.5),
              ),
            ),
            hintStyle: TextStyle(
              color: AppColors.hintColor,
              fontSize: 14,
            ),
            prefixIcon: prefixIcon != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: prefixIcon,
                  )
                : null,
          ),
          isEmpty: value == null,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              items: items,
              onChanged: enabled ? onChanged : null,
              isExpanded: true,
              dropdownColor: AppColors.greyDark,
              hint: Text(
                hint,
                style: TextStyle(
                  color: AppColors.hintColor,
                  fontSize: 14,
                ),
              ),
              style: TextStyle(
                color: textColor ?? AppColors.white,
                fontSize: 14,
              ),
            ),
          ),
        ),
        if (error != null) ...[
          const SizedBox(height: 8),
          Text(
            error!,
            style: TextStyle(
              color: AppColors.red,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }
}
