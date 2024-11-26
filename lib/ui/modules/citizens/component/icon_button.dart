import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:reentry/core/extensions.dart';

class CustomIconButton extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;
  final String? icon;
  final String label;
  final VoidCallback onPressed;
  final Color? borderColor; 
  const CustomIconButton({
    super.key,
    required this.backgroundColor,
    required this.textColor,
    this.icon,
    required this.label,
    required this.onPressed,
    this.borderColor, 
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
          side: borderColor != null
              ? BorderSide(color: borderColor!) 
              : BorderSide.none, 
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
      child: icon != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(icon!),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            )
          : Text(
              label,
              style: context.textTheme.bodyMedium?.copyWith(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
    );
  }
}
