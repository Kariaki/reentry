import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/core/theme/style/text_style.dart';

class InputField extends StatelessWidget {
  final String? label;
  final String hint;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? preffixIcon;
  final String? error;
  final bool enable;
  final int lines;
  final int? maxLines;
  final int? maxLength;
  final String? Function(String?)? validator;
  final String? initialValue;
  final double? radius;
  final Function(String)? onChange;
  final Color? fillColor;
  final Color? color;
  final Color? textColor;
  final bool phone;
  final void Function(String?)? onSubmit;
  final TextEditingController? controller;

  const InputField(
      {super.key,
      this.validator,
      this.label,
      this.lines = 1,
      this.maxLength,
      this.maxLines,
      this.onSubmit,
      this.phone = false,
      this.radius,
      this.fillColor,
      required this.hint,
      this.controller,
      this.onChange,
      this.enable = true,
      this.initialValue,
      this.obscureText = false,
      this.suffixIcon,
      this.preffixIcon,
      this.color,
      this.textColor,
      this.error});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: AppTextStyle.heading
                .copyWith( color: color ?? AppColors.white, fontSize: 14),
          ),
          8.height
        ],
        TextFormField(
          obscuringCharacter: '*',
          initialValue: initialValue,
          onFieldSubmitted: onSubmit,
          validator: (s) => validator?.call(s),
          controller: controller,
          enabled: enable,
          style: AppTextStyle.regular.copyWith(color: textColor ?? AppColors.white,fontSize: 14),
          onChanged: onChange,

          keyboardType: phone?TextInputType.phone:TextInputType.text,
          obscureText: obscureText,

          maxLength: maxLength,
          cursorColor: AppColors.primary,
          inputFormatters: [
            if (phone) FilteringTextInputFormatter.digitsOnly,
            if(phone)  LengthLimitingTextInputFormatter(10), // Ensures the limit is enforced
          ],
          minLines: lines,
          maxLines: (maxLines ?? 1) < lines ? lines + 1 : (maxLines ?? 1),
          decoration: InputDecoration(
              fillColor: fillColor ?? AppColors.greyDark,
              filled: true,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(radius ?? 100),
                  borderSide:
                      const BorderSide(color: AppColors.inputBorderColor)),
              disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(radius ?? 100),
                  borderSide: BorderSide(
                      color: AppColors.inputBorderColor.withOpacity(.5))),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(radius ?? 100),
                  borderSide:
                      const BorderSide(color: AppColors.inputBorderColor)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(radius ?? 100),
                  borderSide:
                      const BorderSide(color: AppColors.inputBorderColor)),
              hintStyle: const TextStyle(color: AppColors.hintColor),
              hintText: hint,
              suffixIcon: suffixIcon,
              prefixIcon:preffixIcon!=null? Padding(
                padding: const EdgeInsets.symmetric(horizontal:8.0),
                child: preffixIcon,
              ):null),
        )
      ],
    );
  }
}
