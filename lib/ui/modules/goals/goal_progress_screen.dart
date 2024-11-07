import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/data/model/goal_dto.dart';
import 'package:reentry/ui/components/app_bar.dart';
import 'package:reentry/ui/components/buttons/primary_button.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/modules/appointment/component/appointment_component.dart';
import 'package:reentry/ui/modules/goals/bloc/goals_bloc.dart';
import 'package:reentry/ui/modules/goals/bloc/goals_event.dart';
import 'package:reentry/ui/modules/goals/bloc/goals_state.dart';
import 'package:reentry/ui/modules/shared/success_screen.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/style/text_style.dart';
import '../../../generated/assets.dart';
import '../../components/input/input_field.dart';

class GoalProgressScreen extends HookWidget {
  final GoalDto goal;

  const GoalProgressScreen({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final controller = useTextEditingController(text: goal.title);
    final progress = useState(goal.progress);
    final key = GlobalKey<FormState>();
    return BlocConsumer<GoalsBloc, GoalState>(builder: (context, state) {
      return BaseScaffold(
          isLoading: state is GoalsLoading,
          child:SingleChildScrollView(
            child:  Form(
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
                              goal.title,
                              style: textTheme.bodyLarge,
                            )
                          ],
                        ),
                        IconButton(
                            onPressed: () {
                              _deleteGoalOnPress(context);
                            },
                            icon: SvgPicture.asset(Assets.svgDeleteRound))
                      ],
                    ),
                    5.height,
                    Text(
                      '${progress.value}%',
                      style: textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Completed',
                      style:
                      textTheme.bodyMedium?.copyWith(color: AppColors.gray2),
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
                          label('Duration'),
                          10.height,
                          Text(
                              '${goal.createdAt.formatDate()} - ${goal.endDate.formatDate()}'),
                          20.height,
                          label('Progress'),
                          Slider(
                              value: progress.value.toDouble(),
                              max: 100,
                              thumbColor: Colors.transparent,
                              min: 0,
                              onChanged: (value) {
                                progress.value = value.toInt();
                              })
                        ],
                      ),
                    ),
                    50.height,
                    PrimaryButton(
                      text: 'Save changes',
                      onPress: () {
                        if (key.currentState!.validate()) {
                          context.read<GoalsBloc>().add(UpdateGoalEvent(
                              goal.copyWith(
                                  title: controller.text,
                                  progress: progress.value)));
                        }
                      },
                    ),
                    10.height,
                    PrimaryButton.dark(
                        text: 'Go back',
                        onPress: () {
                          context.pop();
                        })
                  ],
                )),
          ));
    }, listener: (_, state) {
      if (state is GoalError) {
        context.showSnackbarError(state.message);
      }
      if(state is DeleteGoalSuccess){
        context.pushReplace(SuccessScreen(
          callback: () {},
          title: 'Goal deleted!',
          description: "Your goal has been deleted.",
        ));
      }
      if (state is GoalUpdateSuccess) {
        context.pushReplace(SuccessScreen(
          callback: () {},
          title: 'Goal updated!',
          description: "Your progress has been saved",
        ));
      }
    });
  }

  void _deleteGoalOnPress(BuildContext context) {
     showPlatformDialog(
      context: context,
      builder: (context) => BasicDialogAlert(
        title: const Text("Delete goal"),
        content: const Text("Are you sure you want to delete this goal?"),
        actions: <Widget>[
          BasicDialogAction(
            title: const Text("Delete"),
            onPressed: () {
              context.pop(); //
              context.read<GoalsBloc>().add(DeleteGoalEvent(goal.id));
            },
          ),
          BasicDialogAction(
            title: const Text("Continue"),
            onPressed: () {
              context.pop();
            },
          ),
        ],
      ),
    );
  }
}
