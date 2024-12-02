import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reentry/data/model/activity_dto.dart';
import 'package:reentry/ui/components/app_bar.dart';
import 'package:reentry/ui/components/buttons/primary_button.dart';
import 'package:reentry/ui/components/date_dialog.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/modules/activities/bloc/activity_bloc.dart';
import 'package:reentry/ui/modules/activities/bloc/activity_state.dart';
import 'package:reentry/ui/modules/appointment/component/appointment_component.dart';
import 'package:reentry/ui/modules/goals/components/dynamic_modal.dart';
import 'package:reentry/ui/modules/shared/success_screen.dart';
import '../../../core/extensions.dart';
import '../../components/app_check_box.dart';
import '../../components/container/box_container.dart';
import '../../components/date_time_picker.dart';
import '../../components/input/input_field.dart';
import 'bloc/activity_event.dart';

class CreateActivityScreen extends HookWidget {
  final Function? successCallback;
  const CreateActivityScreen({super.key, this.successCallback});

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final date = useState<DateTime?>(null);
    final key = GlobalKey<FormState>();
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
                    const Text("Character limit: 200"),
                    10.height,
                    BoxContainer(
                        radius: 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DateTimePicker(
                              hint: 'End date',
                              onTap: () async {
                                context.displayDialog(
                                    DateTimeDialog(onSelect: (result) {
                                  date.value = result;
                                }));
                              },
                              title: date.value?.formatDate(),
                            ),
                          ],
                        )),
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
                        if (key.currentState!.validate()) {
                          if (date.value == null) {
                            return;
                          }
                          final result = CreateActivityEvent(
                              title: controller.text,
                              startDate: DateTime.now().millisecondsSinceEpoch,
                              endDate: date.value!.millisecondsSinceEpoch,
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
              SuccessScreen(callback: () {}, title: "New goal set"));
        }
      }
    });
  }
}
