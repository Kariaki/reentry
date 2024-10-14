import 'package:flutter/material.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/core/theme/style/text_style.dart';

class InputField extends StatelessWidget {
  final String? label;
  final String hint;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? error;
  final bool enable;
  final int lines;
  final int? maxLines;
  final String? initialValue;
  final double? radius;
  final Function(String)? onChange;
  final Color? fillColor;
  final TextEditingController? controller;

  const InputField(
      {super.key, this.label,this.lines=1,this.maxLines,this.radius,this.fillColor, required this.hint,this.controller,this.onChange,this.enable=true,this.initialValue, this.obscureText = false,this.suffixIcon,this.error});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: AppTextStyle.heading.copyWith(color: AppColors.white,fontSize: 14),
          ),
          8.height
        ],
        TextFormField(
          obscuringCharacter: '*',
          initialValue: initialValue,
          controller: controller,
          enabled: enable,
          style: AppTextStyle.regular.copyWith(color: AppColors.white),
          onChanged: onChange,
          obscureText: obscureText,
          cursorColor: AppColors.primary,
          minLines: lines,
          maxLines: (maxLines??1)<lines?lines+1: (maxLines??1),
          decoration: InputDecoration(

            fillColor:fillColor?? AppColors.gray1,
            filled: fillColor!=null,

            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(radius??100),
                borderSide: const BorderSide(color: AppColors.inputBorderColor)),
            disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(radius??100),
                borderSide: const BorderSide(color: AppColors.inputBorderColor)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(radius??100),
                borderSide: const BorderSide(color: AppColors.inputBorderColor)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(radius??100),
                borderSide: const BorderSide(color: AppColors.inputBorderColor)),
            hintStyle: const TextStyle(color: AppColors.hintColor),
            hintText: hint,
            suffixIcon: suffixIcon
          ),
        )
      ],
    );
  }
}
