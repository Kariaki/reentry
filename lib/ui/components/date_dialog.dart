import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/ui/components/buttons/primary_button.dart';
import 'package:reentry/ui/components/container/box_container.dart';

class DateTimeDialog extends StatefulWidget {
  final Function(DateTime?) onSelect;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateTime? initialDate;
  final bool dob;

  const DateTimeDialog(
      {super.key,
      required this.onSelect,
      this.dob = false,
        this.initialDate,
      this.firstDate,
      this.lastDate});

  @override
  State<DateTimeDialog> createState() => _DateTimeDialogState();
}

class _DateTimeDialogState extends State<DateTimeDialog> {
  DateTime? currentDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: kIsWeb?400:double.infinity
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 200,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
            child: CupertinoTheme(
                data: const CupertinoThemeData(
                  brightness: Brightness.dark,
                  barBackgroundColor: AppColors.gray1,
                  textTheme: CupertinoTextThemeData(
                    dateTimePickerTextStyle: TextStyle(
                      color: AppColors.white, // Customize text color
                      fontSize: 18,
                    ),
                  ),
                ),
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                 initialDateTime: widget.initialDate,
                  maximumYear: widget.lastDate?.year ?? 2050,
                  minimumDate: !widget.dob ? DateTime(DateTime.now().year) : widget.firstDate,
                  use24hFormat: true,
                  // This is called when the user changes the date.
                  onDateTimeChanged: (DateTime newDate) {
                    setState(() {
                      currentDate = newDate;
                    });
                  },
                )),
          ),
          5.height,
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: PrimaryButton(
                text: 'Done',
                onPress: () {
                  widget.onSelect(currentDate);
                  context.popBack();
                }),
          ),
        ],
      ),
    );
  }
}

class AppTimePicker extends StatelessWidget {
  final bool dob;

  const AppTimePicker({super.key, this.dob = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 500),
      child: const TimePickerTheme(
          data: TimePickerThemeData(
              backgroundColor: AppColors.gray1, padding: EdgeInsets.all(10)),
          child: TimePickerDialog(
            initialTime: TimeOfDay(hour: 0, minute: 0),
          )),
    );
  }
}
