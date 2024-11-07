import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reentry/ui/components/app_bar.dart';
import 'package:reentry/ui/components/buttons/primary_button.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/modules/appointment/component/appointment_component.dart';
import 'package:reentry/ui/modules/goals/bloc/goals_bloc.dart';
import 'package:reentry/ui/modules/goals/bloc/goals_event.dart';
import 'package:reentry/ui/modules/goals/bloc/goals_state.dart';
import 'package:reentry/ui/modules/shared/success_screen.dart';
import '../../../core/extensions.dart';
import '../../components/container/box_container.dart';
import '../../components/date_time_picker.dart';
import '../../components/input/input_field.dart';

class CreateActivityScreen extends HookWidget {
  const CreateActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final date = useState<DateTime?>(null);
    final formKey = GlobalKey<FormState>();
    return BlocConsumer<GoalsBloc, GoalState>(builder: (context, state) {
      return BaseScaffold(
          appBar: const CustomAppbar(),
          child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Create a new daily activity', style: context.textTheme.bodyLarge),
                  10.height,
                  const Text("Build a new habit by creating a daily activity"),
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
                    radius: 10,
                    fillColor: Colors.transparent,
                  ),
                  const Text("Character limit: 200"),
                  20.height,
               label('Select tracking'),

                  30.height,
                  PrimaryButton(
                    text: 'Create activity',
                    loading: state is GoalsLoading,
                    onPress: () {
                      if (formKey.currentState!.validate()) {
                        if (date.value == null) {
                          return;
                        }

                        // context.read<GoalsBloc>().add(CreateGoalEvent(
                        //     controller.text,
                        //     date.value!.millisecondsSinceEpoch,
                        //     date.value!
                        //         .add(const Duration(days: 7))
                        //         .millisecondsSinceEpoch));
                        //
                      }
                    },
                  )
                ],
              )));
    }, listener: (_, state) {
      if (state is GoalError) {
        context.showSnackbarError(state.message);
      }
      if (state is CreateGoalSuccess) {
        //change to custom goal success screen
        context
            .pushReplace(SuccessScreen(callback: () {}, title: "New goal set"));
      }
    });
  }
}
