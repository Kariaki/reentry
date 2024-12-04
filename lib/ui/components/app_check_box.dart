import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reentry/core/extensions.dart';

import '../../core/theme/colors.dart';

Widget appCheckBox(
  bool value,
  Function(bool?) onChange, {
  String? title,
  Color? textColor, 
}) {
  return Builder(builder: (context) {
    final style = context.textTheme.bodyMedium?.copyWith(
      color: textColor, 
    );
    return InkWell(
      onTap: () {
        onChange.call(!value);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: value,
            onChanged: onChange,
            fillColor: WidgetStateColor.resolveWith((c) {
              return AppColors.gray1;
            }),
            checkColor: AppColors.white,
            focusColor: AppColors.gray1,
          ),
          if (title != null) ...[
            5.width,
            Text(
              title,
              style: style,
            )
          ]
        ],
      ),
    );
  });
}
