import 'package:flutter/material.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/data/model/goal_dto.dart';
import 'package:reentry/ui/components/app_radio_button.dart';

class GoalSlider extends StatefulWidget {
  final Function(int, String?) callback;
  final double initial;
  final Function(double) onChange;
  final String? duration;

  const GoalSlider(
      {super.key,
      this.initial = 0,
      required this.onChange,
      required this.callback,
      this.duration});

  @override
  State<GoalSlider> createState() => _GoalSliderState();
}

class _GoalSliderState extends State<GoalSlider> {
  double value = 0;

  String? selectedDuration;

  @override
  void initState() {
    value = widget.initial;
    selectedDuration = widget.duration;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.white,
              trackHeight: 10,
              showValueIndicator: ShowValueIndicator.always,
              valueIndicatorColor: AppColors.white,
              valueIndicatorTextStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
              valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
              inactiveTrackColor: AppColors.gray1,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 30.0),
            ),
            child: Slider(
                value: value,
                max: 100,
                thumbColor: Colors.white,
                label: '${value.toInt()}%',
                min: 0,
                onChanged: (v) {
                  widget.onChange(v);
                  setState(() {
                    value = v;
                  });
                })),
        20.height,
        Text(
          'Change duration',
          style: context.textTheme.bodyLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        10.height,
        GridView(
          padding: EdgeInsets.all(0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisExtent: 40),
          shrinkWrap: true,
          children: GoalDto.durations.map((e) {
            return AppRadioButton(
              selected: selectedDuration == e,
              text: e,
              onClick: () {
                setState(() {
                  selectedDuration = e;
                });
              },
            );
          }).toList(),
        ),
        50.height,
        // PrimaryButton(
        //   text: 'Save changes',
        //   onPress: () {
        //     widget.callback(value.toInt(), selectedDuration);
        //   },
        // ),
      ],
    );
  }
}
