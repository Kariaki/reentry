import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reentry/data/model/activity_dto.dart';
import 'package:reentry/ui/components/app_bar.dart';
import 'package:reentry/ui/components/buttons/primary_button.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/modules/activities/bloc/activity_bloc.dart';
import 'package:reentry/ui/modules/activities/bloc/activity_state.dart';
import 'package:reentry/ui/modules/appointment/component/appointment_component.dart';
import 'package:reentry/ui/modules/shared/success_screen.dart';
import '../../../core/extensions.dart';
import '../../components/app_check_box.dart';
import '../../components/input/input_field.dart';
import 'bloc/activity_event.dart';

class CreateActivityScreen extends HookWidget {
  const
  CreateActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final date = useState<DateTime?>(null);
    final formKey = GlobalKey<FormState>();
    final daily = useState(false);
    return BlocConsumer<ActivityBloc, ActivityState>(
        builder: (context, state) {
      return BaseScaffold(
          appBar: const CustomAppbar(),
          child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Create a new daily activity',
                      style: context.textTheme.bodyLarge),
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
                  label('Frequency'),
                  Row(
                    children: [
                      appCheckBox(!daily.value, (val) {
                        daily.value = !(val ?? false);
                      }, title: "Daily"),
                      20.width,
                      appCheckBox(daily.value, (val) {
                        daily.value = val ?? false;
                      }, title: "Weekly"),
                    ],
                  ),
                  30.height,
                  PrimaryButton(
                    text: 'Create activity',
                    loading: state is ActivityLoading,
                    onPress: () {
                      if (formKey.currentState!.validate()) {
                        if (date.value == null) {
                          return;
                        }
                        final result =   CreateActivityEvent(
                            title: controller.text,
                            startDate: 0,
                            endDate: 0,
                            frequency: daily.value
                                ? Frequency.weekly
                                : Frequency.daily);
                        context.read<ActivityBloc>().add(result);
                      }
                    },
                  )
                ],
              )));
    }, listener: (_, state) {
      if (state is ActivityError) {
        context.showSnackbarError(state.message);
      }
      if (state is CreateActivitySuccess) {
        //change to custom goal success screen
        context
            .pushReplace(SuccessScreen(callback: () {}, title: "New goal set"));
      }
    });
  }
}
