import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:reentry/data/model/activity_dto.dart';
import 'package:reentry/data/model/goal_dto.dart';
import 'package:reentry/ui/components/app_bar.dart';
import 'package:reentry/ui/components/buttons/primary_button.dart';
import 'package:reentry/ui/components/input/dropdownField.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/modules/activities/bloc/activity_bloc.dart';
import 'package:reentry/ui/modules/activities/bloc/activity_state.dart';
import 'package:reentry/ui/modules/goals/bloc/goals_cubit.dart';
import 'package:reentry/ui/modules/goals/bloc/goals_state.dart';
import 'package:reentry/ui/modules/goals/components/dynamic_modal.dart';
import 'package:reentry/ui/modules/shared/success_screen.dart';
import '../../../core/extensions.dart';
import '../../../core/theme/colors.dart';
import '../../../generated/assets.dart';
import '../../components/input/input_field.dart';
import '../citizens/component/icon_button.dart';
import '../goals/create_goal_screen.dart';
import 'bloc/activity_event.dart';

class CreateActivityScreen extends HookWidget {
  final Function? successCallback;

  const CreateActivityScreen({super.key, this.successCallback});

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final date = useState<DateTime?>(null);
    final key = GlobalKey<FormState>();
    final goal = useState<GoalDto?>(null);
    final daily = useState(false);
    return BlocConsumer<ActivityBloc, ActivityState>(builder: (context, state) {
      return BaseScaffold(
          appBar: const CustomAppbar(),
          child: Form(
              key: key,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Create a new daily activity',
                        style: context.textTheme.bodyLarge),
                    10.height,
                    const Text(
                        "Build a new habit by creating a daily activity"),
                    20.height,
                    Text(
                      'Describe your activity',
                      style: context.textTheme.bodyLarge,
                    ),
                    15.height,
                    InputField(
                      hint: 'Example, Lose 10 pounds',
                      controller: controller,
                      lines: 3,
                      validator: (input) => (input?.isNotEmpty ?? true)
                          ? null
                          : 'Please enter a valid input',
                      radius: 10,
                      fillColor: Colors.transparent,
                    ),
                    15.height,
                    GoalSelectionComponent(goal),
                    30.height,
                    PrimaryButton(
                      text: 'Create activity',
                      loading: state is ActivityLoading,
                      onPress: () {
                        if (key.currentState!.validate()) {
                          if (goal.value == null) {
                            context.showSnackbarError('Please select a goal');
                            return;
                          }
                          final result = CreateActivityEvent(
                              title: controller.text,
                              goalId: goal.value?.id ?? '',
                              startDate: DateTime.now().millisecondsSinceEpoch,
                              endDate: DateTime.now()
                                  .add(Duration(days: 1))
                                  .millisecondsSinceEpoch,
                              frequency: daily.value
                                  ? Frequency.weekly
                                  : Frequency.daily);
                          context.read<ActivityBloc>().add(result);
                        }
                      },
                    )
                  ],
                ),
              )));
    }, listener: (_, state) {
      if (state is CreateActivityError) {
        context.showSnackbarError(state.message);
      }
      if (state is CreateActivitySuccess) {
        if (kIsWeb) {
          Navigator.pop(context);
          Future.delayed(const Duration(milliseconds: 100), () {
            showDialog(
              context: context,
              builder: (context) {
                return const DynamicModal(
                  isSuccess: true,
                  title: "Activities created successfully",
                  icon: Icons.thumb_up,
                );
              },
            );
          });
        } else {
          successCallback?.call();
          context.pushReplace(
              SuccessScreen(callback: () {}, title: "New activity created"));
        }
      }
    });
  }
}

BlocBuilder<GoalCubit, GoalCubitState> GoalSelectionComponent(
    ValueNotifier<GoalDto?> goal) {
  return BlocBuilder<GoalCubit, GoalCubitState>(builder: (context, state) {
    if (state.goals.isEmpty) {
      return InkWell(
        onTap: (){
          if(kIsWeb){
            context.displayDialog(
                CreateGoalScreen(successCallback: () {
                  Navigator.pop(context);
                }));
            return;
          }

          context.pushRoute(const CreateGoalScreen());
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          width: double.infinity,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
                side:BorderSide(color: AppColors.white)

            ),),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(Assets.svgAddButton),
              const SizedBox(width: 8),
              Text(
                'Create a goal',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: AppColors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return DropdownField<GoalDto>(
        hint: 'Select a goal',
        value: goal.value,
        items: state.goals
            .map((e) =>
                DropdownMenuItem<GoalDto>(value: e, child: Text(e.title)))
            .toList(),
        onChanged: (value) {
          goal.value = value;
        });
  });
}
