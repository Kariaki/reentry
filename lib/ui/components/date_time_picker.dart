import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reentry/core/extensions.dart';

import '../../core/theme/colors.dart';

class DateTimePicker extends HookWidget {
  final String? title;
  final IconData? icon;

  const DateTimePicker({super.key, this.title,this.icon});

  @override
  Widget build(BuildContext context) {
    final selectedDate = useState<DateTime?>(null);
    return InkWell(
      onTap: () {
        showTimePicker(context: context, initialTime: TimeOfDay(hour: 00, minute: 00),
        initialEntryMode: TimePickerEntryMode.input);
        return;
        showDatePicker(
          context: context,
          firstDate: DateTime(2000),
          lastDate: DateTime(2050),
          builder: (BuildContext context, Widget? widget) {
            final state = WidgetStateProperty.resolveWith((e) {
              //  if(e.first == WidgetState.selected) return AppColors.black;
              return AppColors.white;
            });
            return Theme(
              data: ThemeData(
                colorScheme:
                    const ColorScheme.light(primary: AppColors.primary),
                datePickerTheme: DatePickerThemeData(
                  backgroundColor: AppColors.black,
                  todayForegroundColor: state,
                  dayForegroundColor: state,
                  dividerColor: AppColors.primary,
                ),
              ),
              child: widget!,
            );
          },
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: AppColors.white))),
        child: Row(
          children: [
            Icon(
             icon?? Icons.date_range,
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
