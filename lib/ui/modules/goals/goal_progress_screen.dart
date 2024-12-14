import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/data/model/goal_dto.dart';
import 'package:reentry/ui/components/buttons/primary_button.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/dialog/alert_dialog.dart';
import 'package:reentry/ui/modules/appointment/component/appointment_component.dart';
import 'package:reentry/ui/modules/goals/bloc/goals_bloc.dart';
import 'package:reentry/ui/modules/goals/bloc/goals_event.dart';
import 'package:reentry/ui/modules/goals/bloc/goals_state.dart';
import 'package:reentry/ui/modules/shared/success_screen.dart';
import '../../../core/theme/colors.dart';
import '../../../generated/assets.dart';
import '../../components/app_radio_button.dart';
import '../../components/input/input_field.dart';

class GoalProgressScreen extends StatefulWidget {
  const GoalProgressScreen({super.key, required this.goal});

  final GoalDto goal;

  @override
  State<GoalProgressScreen> createState() => _GoalProgressScreenState();
}

class _GoalProgressScreenState extends State<GoalProgressScreen> {
  int progress = 0;
  late TextEditingController controller;

  @override
  void initState() {
    progress = widget.goal.progress;
    controller = TextEditingController(text: widget.goal.title);
    super.initState();
  }

  String? selectedDuration;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final key = GlobalKey<FormState>();
    return BlocConsumer<GoalsBloc, GoalAndActivityState>(
        builder: (context, state) {
      return BaseScaffold(
          isLoading: state is GoalsLoading,
          child: SingleChildScrollView(
            child: Form(
                key: key,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    55.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              Assets.svgGoal,
                              width: 24,
                              height: 24,
                            ),
                            5.width,
                            Text(
                              widget.goal.title,
                              style: textTheme.bodyLarge,
                            )
                          ],
                        ),
                        if (!kIsWeb)
                          IconButton(
                              onPressed: () {
                                _deleteGoalOnPress(context);
                              },
                              icon: SvgPicture.asset(Assets.svgDeleteRound))
                      ],
                    ),
                    5.height,
                    Text(
                      '${progress}%',
                      style: textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Completed',
                      style: textTheme.bodyMedium
                          ?.copyWith(color: AppColors.gray2),
                    ),
                    20.height,
                    const Text(
                        'Streak helps you to be consistent in efforts towards your goals'),
                    20.height,
                    InputField(
                      hint: 'Lose 10 pounds',
                      enable: true,
                      validator: (input) => (input?.isNotEmpty ?? true)
                          ? null
                          : 'Please enter a valid input',
                      controller: controller,
                      label: 'Goal title',
                    ),
                    30.height,
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          10.height,
                          label('Progress'),
                          GoalSlider(
                            initial: progress.toDouble(),
                            duration: widget.goal.duration,
                            callback: (value, duration) {
                              if (key.currentState!.validate()) {
                                setState(() {
                                  progress = value;
                                });
                                context.read<GoalsBloc>().add(UpdateGoalEvent(
                                    widget.goal.copyWith(
                                        title: controller.text,
                                        duration: duration,
                                        progress: progress)));
                              }
                            },
                            onChange: (value) {
                              //    progress.value = value.toInt();
                            },
                          ),
                        ],
                      ),
                    ),
                    10.height,
                    PrimaryButton.dark(
                        text: 'Go back',
                        onPress: () {
                          context.popRoute();
                        })
                  ],
                )),
          ));
    }, listener: (_, state) {
      if (state is GoalError) {
        context.showSnackbarError(state.message);
      }
      if (state is DeleteGoalSuccess) {
        if (kIsWeb) {
          context.showSnackbarSuccess('Goal deleted');
          context.popBack();
          return;
        }
        context.pushReplace(SuccessScreen(
          callback: () {},
          title: 'Goal deleted!',
          description: "Your goal has been deleted.",
        ));
      }
      if (state is GoalUpdateSuccess) {
        if (kIsWeb) {
          context.showSnackbarSuccess('Goal updated!');
          context.popBack();
          return;
        }
        context.pushReplace(SuccessScreen(
          callback: () {},
          title: 'Goal updated!',
          description: "Your progress has been saved",
        ));
      }
    });
  }

  void _deleteGoalOnPress(BuildContext context) {
    AppAlertDialog.show(context,
        title: 'Delete goal?',
        description: 'Are you sure you want to delete this goal?',
        action: 'Delete', onClickAction: () {
      context.popRoute(); //
      context.read<GoalsBloc>().add(DeleteGoalEvent(widget.goal.id));
    });
  }
}

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
        PrimaryButton(
          text: 'Save changes',
          onPress: () {
            widget.callback(value.toInt(), selectedDuration);
          },
        ),
      ],
    );
  }
}
