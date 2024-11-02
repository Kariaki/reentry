import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get_common/get_reset.dart';
import 'package:intl/intl.dart';
import 'package:reentry/core/enum/days.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/main.dart';
import 'package:reentry/ui/components/app_bar.dart';
import 'package:reentry/ui/components/buttons/primary_button.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import '../../../core/extensions.dart';

class CalenderScreen extends HookWidget {
  const CalenderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedTime = useState<Set<String>>({});
    final currentDate = useState<String>(DateTime.now().toIso8601String().split('T')[0]);
    final selectedDays = useState<Set<Days>>({});
    final textTheme = context.textTheme;
    return BaseScaffold(
        appBar: const CustomAppbar(
          title: "Calender",
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select your available days",
                style:
                    textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              20.height,
              Text("Today ${DateTime.now().formatDate()}"),
              20.height,

              Wrap(
                runSpacing: 5,
                spacing: 10,
                children: getCurrentWeekDays().map((e)=>dateComponent(e,
                    selected: e.split('T')[0]==currentDate.value,
                    onClick: (result){})).toList(),
              ),
              15.height,
              const Divider(
                color: AppColors.gray1,
              ),
              15.height,
              Text(
                "Select day",
                style: textTheme.bodyLarge,
              ),
              15.height,
              Wrap(
                runSpacing: 5,
                spacing: 8,
                children: Days.values
                    .map((e) => dayComponent(e,
                            selected: selectedDays.value.contains(e),
                            onClick: (result) {
                          if (selectedDays.value.contains(result)) {
                            selectedDays.value = selectedDays.value
                                .where((element) => element != result)
                                .toSet();
                            return;
                          }
                          selectedDays.value = {...selectedDays.value, result};
                        }))
                    .toList(),
              ),
              25.height,
              Text(
                "Select time",
                style: textTheme.bodyLarge,
              ),
              15.height,
              Wrap(
                runSpacing: 10,
                spacing: 15,
                children: computeTime().map((index) {
                  final split = index.split(':');
                  int hour = int.parse(split[0]);
                  int mins = int.parse(split[1]);
                  return _timeComponent(
                      hour: hour,
                      mins: mins,
                      selected: selectedTime.value,
                      onClick: (result) {
                        final contains = selectedTime.value.contains(result);
                        if (contains) {
                          selectedTime.value = selectedTime.value
                              .where((e) => e != result)
                              .toSet();
                        } else {
                          final newValue = {...selectedTime.value, result};
                          selectedTime.value = newValue;
                        }
                      });
                }).toList(),
              ),
              20.height,
              PrimaryButton(
                text: 'Save',
                onPress: () {
                  //update user profile with schedule
                },
              ),
              10.height,
              PrimaryButton.dark(text: "Go back", onPress: () {})
            ],
          ),
        ));
  }

  List<String> computeTime() {
    List<String> result = [];
    for (int i = 9; i <= 16; i++) {
      for (int mins = 0; mins <= 1; mins++) {
        String min = mins == 0 ? '00' : '30';
        result.add('$i:$min');
      }
    }
    return result;
  }

  Widget dayComponent(Days day,
      {bool selected = false, required Function(Days) onClick}) {
    return Builder(builder: (context) {
      final textTheme = context.textTheme;
      return InkWell(
        onTap: () {
          onClick(day);
        },
        child: Container(
          decoration: !selected
              ? null
              : const ShapeDecoration(
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: AppColors.white))),
          child: Stack(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                child: Text(
                  day.name.capitalize,
                  style: textTheme.bodySmall,
                ),
              ),
              const Positioned(
                  right: 0,
                  top: 0,
                  child: const Icon(
                    Icons.check,
                    color: AppColors.white,
                    size: 10,
                  ))
            ],
          ),
        ),
      );
    });
  }
  Widget dateComponent(String value,
      {bool selected = false, required Function(String) onClick}) {
    final date = DateTime.parse(value);
    final year = date.year.toString().substring(2);
    final month = date.formatDate().split(" ")[0];
    final day = date.day;
    return Builder(builder: (context) {
      final textTheme = context.textTheme;
      return InkWell(
        onTap: () {
          //onClick(day);
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8,vertical: 5),
          decoration: !selected
              ? null
              :  ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                      side: const BorderSide(color: AppColors.white))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric( horizontal: 8),
                    child: Text(
                      '${day<10?'0$day':day}',
                      style: textTheme.bodySmall,
                    ),
                  ),
                   const Positioned(
                      right: 1,
                      top: 0,
                      child: Padding(padding: EdgeInsets.only(left: 5),child: const Icon(
                        Icons.check,
                        color: AppColors.white,
                        size: 10,
                      ),))
                ],
              ),
              3.height,
              Text('$month $year',style: textTheme.bodySmall?.copyWith(fontSize: 8),)
            ],
          ),
        ),
      );
    });
  }

  List<String> getCurrentWeekDays() {
    DateTime now = DateTime.now();

    // Find the start of the week (assuming Sunday is the first day of the week)
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday % 7));

    // Get each day of the week
    List<String> weekDays = List.generate(7, (index) {
      DateTime weekDay = startOfWeek.add(Duration(days: index));
      return weekDay.toIso8601String();
     // return DateFormat('EEEE, MMM d').format(weekDay); // Format: "Monday, Jan 1"
    });

    return weekDays;
  }

  Widget _timeComponent(
      {required int hour,
      required int mins,
      required Set<String> selected,
      required Function(String) onClick}) {
    return Builder(builder: (context) {
      String time =
          '${hour < 10 ? '0$hour' : hour}:${mins < 10 ? '0$mins' : mins}';
      time = '$time ${hour >= 12 ? 'PM' : 'AM'}';
      final textTheme = context.textTheme;
      return InkWell(
        onTap: () {
          onClick(time);
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: !selected.contains(time)
              ? null
              : const ShapeDecoration(
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: AppColors.white))),
          child: Text(
            time,
            style: textTheme.bodySmall,
          ),
        ),
      );
    });
  }
}
