import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';

class AppRadioButton extends StatelessWidget {
  final bool selected;
  final double? height;
  final double? width;
  final String? text;
  final Function()onClick;

  const AppRadioButton(
      {super.key, required this.selected, this.height, this.width, this.text,required this.onClick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: height ?? 16,
            width: width ?? 16,
            decoration: ShapeDecoration(
                shape: const CircleBorder(),
                color: selected ? AppColors.primary : AppColors.white),
          ),
          if (text != null) ...[
            5.width,
            Text(
              text ?? '',
              style: context.textTheme.bodyMedium,
            )
          ]
        ],
      ),
    );
  }
}
