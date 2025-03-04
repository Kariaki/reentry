import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reentry/core/util/input_validators.dart';
import 'package:reentry/data/model/goal_dto.dart';
import 'package:reentry/ui/components/app_bar.dart';
import 'package:reentry/ui/components/app_radio_button.dart';
import 'package:reentry/ui/components/buttons/primary_button.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/modules/goals/bloc/goals_bloc.dart';
import 'package:reentry/ui/modules/goals/bloc/goals_event.dart';
import 'package:reentry/ui/modules/goals/bloc/goals_state.dart';
import 'package:reentry/ui/modules/goals/components/dynamic_modal.dart';
import 'package:reentry/ui/modules/shared/success_screen.dart';
import '../../../core/extensions.dart';
import '../../components/input/input_field.dart';

class CreateGoalScreen extends HookWidget {
  final Function? successCallback;
  const CreateGoalScreen({super.key, this.successCallback});

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final date = useState<DateTime?>(null);
    final selectedDuration = useState<String?>(null);
    final formKey = GlobalKey<FormState>();
    return BlocConsumer<GoalsBloc, GoalAndActivityState>(
        builder: (context, state) {
      return BaseScaffold(
          appBar: const CustomAppbar(),
          child: SingleChildScrollView(
            child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Create a new goal', style: context.textTheme.bodyLarge),
                    10.height,
                    const Text("Achieve new heights by setting goals to reach"),
                    20.height,
                    Text(
                      'Describe your goal',
                      style: context.textTheme.bodyLarge,
                    ),
                    15.height,
                    InputField(
                      hint: 'Example, Lose 10 pounds',
                      controller: controller,
                      lines: 3,
                      radius: 10,
                      validator: InputValidators.stringValidation,
                      fillColor: Colors.transparent,
                    ),
                    const Text("Character limit: 200"),
                    20.height,
                    Text(
                      'Select duration',
                      style: context.textTheme.bodyLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    10.height,
                    GridView(
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, mainAxisExtent: 40),
                      shrinkWrap: true,
                      children: GoalDto.durations.map((e) {
                        return AppRadioButton(
                          selected: selectedDuration.value == e,
                          text: e,
                          onClick: () {
                            selectedDuration.value = e;
                          },
                        );
                      }).toList(),
                    ),
                    30.height,
                    PrimaryButton(
                      text: 'Create goal',
                      loading: state is GoalsLoading,
                      onPress: () {
                        if (formKey.currentState!.validate()) {
                          if (selectedDuration.value == null) {
                            return;
                          }
                          context.read<GoalsBloc>().add(CreateGoalEvent(
                              controller.text,
                              DateTime.now().millisecondsSinceEpoch,
                              0,
                              selectedDuration.value!));
                        }
                      },
                    )
                  ],
                )),
          ));
    }, listener: (_, state) {
      if (state is GoalError) {
        context.showSnackbarError(state.message);
      }
      if (state is CreateGoalSuccess) {
        if (kIsWeb) {
          Navigator.pop(context);
          Future.delayed(const Duration(milliseconds: 100), () {
            showDialog(
              context: context,
              builder: (context) {
                return const DynamicModal(
                  isSuccess: true,
                  title: "Goal created successfully",
                  icon: Icons.thumb_up,
                );
              },
            );
          });
        } else {
          successCallback?.call();
          context.pushReplace(
              SuccessScreen(callback: () {}, title: "New goal set"));
        }
      }
    });
  }
}
