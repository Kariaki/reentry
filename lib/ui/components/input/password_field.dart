import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/ui/components/input/input_field.dart';

class PasswordField extends HookWidget {
  final String label;

  final String? error;
  final bool enable;
  final String? initialValue;
  final Function(String)? onChange;
  final TextEditingController? controller;

  const PasswordField(
      {super.key,
      required this.label,
      this.error,
      this.initialValue,
      this.onChange,
      this.enable = true,
      this.controller});

  @override
  Widget build(BuildContext context) {
    final obscureText = useState(true);
    return InputField(
      hint: '*******************',
      label: label,
      enable: enable,
      initialValue: initialValue,
      onChange: onChange,
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
