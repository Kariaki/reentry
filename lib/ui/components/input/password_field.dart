import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/core/util/input_validators.dart';
import 'package:reentry/ui/components/input/input_field.dart';

class PasswordField extends HookWidget {
  final String label;

  final String? error;
  final bool enable;
  final String? initialValue;
  final Function(String)? onChange;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Color? labelColor;
  final Color? textColor;
  final Color? fillColor;

  const PasswordField(
      {super.key,
      required this.label,
      this.error,
      this.validator,
      this.initialValue,
      this.onChange,
      this.textColor,
      this.enable = true,
      this.labelColor,
      this.fillColor,
      this.controller});

  @override
  Widget build(BuildContext context) {
    final obscureText = useState(true);
    return InputField(
      hint: '*******************',
      label: label,
      color: labelColor,
      textColor: textColor,
      fillColor: fillColor,
      enable: enable,
      initialValue: initialValue,
      onChange: onChange,
      validator: validator ?? InputValidators.passwordValidation,
      error: error,
      controller: controller,
      obscureText: obscureText.value,
      suffixIcon: InkWell(
        onTap: () => obscureText.value = !obscureText.value,
        child: Icon(
          !obscureText.value
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          color: AppColors.gray2,
        ),
      ),
    );
  }
}
