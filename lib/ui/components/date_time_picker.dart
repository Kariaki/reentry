import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reentry/core/extensions.dart';

import '../../core/theme/colors.dart';

class DateTimePicker extends HookWidget {
  final String? title;
  final IconData? icon;
  final Function() onTap;

  const DateTimePicker({super.key, this.title, this.icon,required this.onTap });

  @override
  Widget build(BuildContext context) {
    final selectedDate = useState<DateTime?>(null);
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: AppColors.white))),
        child: Row(
          children: [
            Icon(
              icon ?? Icons.date_range,
              color: AppColors.white.withOpacity(.85),
            ),
            10.width,
            Text(title ?? 'Select Date')
          ],
        ),
      ),
    );
  }
}
