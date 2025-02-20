import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/data/model/activity_dto.dart';
import 'package:reentry/ui/components/app_bar.dart';
import 'package:reentry/ui/components/buttons/primary_button.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/modules/activities/bloc/activity_bloc.dart';
import 'package:reentry/ui/modules/activities/bloc/activity_state.dart';
import '../../../components/input/input_field.dart';
import '../bloc/activity_event.dart';

class CreateActivityDialog extends HookWidget {
  final Function? successCallback;

  const CreateActivityDialog({super.key, this.successCallback});

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final key = GlobalKey<FormState>();
    final daily = useState(false);
    return BlocConsumer<ActivityBloc, ActivityState>(builder: (context, state) {
      return Container(
          padding: const EdgeInsets.all(20),
          child: Form(
              key: key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text('New daily activity',
                        style: context.textTheme.bodyLarge?.copyWith()),
                  ),
                  20.height,
                  Text(
                    "Build a new habit by creating\na daily activity",
                    style: context.textTheme.bodyMedium
                        ?.copyWith(color: AppColors.gray2),
                  ),
                  20.height,
                  Text(
                    'Describe your activity',
                    style: context.textTheme.bodyLarge?.copyWith(fontSize: 14),
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
                  50.height,
                  PrimaryButton(
                    text: 'Create activity',
                    loading: state is ActivityLoading,
                    onPress: () {
                      if (key.currentState!.validate()) {
                        final result = CreateActivityEvent(
                            title: controller.text,
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
              )));
    }, listener: (_, state) {
      if (state is CreateActivityError) {
        context.showSnackbarError(state.message);
      }
      if (state is CreateActivitySuccess) {
        successCallback?.call();
        context.showSnackbarSuccess("Activity created");
        context.popRoute();
      }
    });
  }
}
