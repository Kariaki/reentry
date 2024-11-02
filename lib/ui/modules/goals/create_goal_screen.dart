import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reentry/ui/components/app_bar.dart';
import 'package:reentry/ui/components/buttons/primary_button.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/modules/appointment/component/appointment_component.dart';
import '../../../core/extensions.dart';
import '../../../core/theme/colors.dart';
import '../../components/container/box_container.dart';
import '../../components/date_time_picker.dart';
import '../../components/input/input_field.dart';

class CreateGoalScreen extends HookWidget {
  const CreateGoalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final date = useState<DateTime?>(null);
    return BaseScaffold(
        appBar: CustomAppbar(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Create a new goal', style: context.textTheme.bodyLarge),
            10.height,
            Text("Achieve new heights by setting goals to reach"),
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
              fillColor: Colors.transparent,
            ),
            Text("Character limit: 200"),
            20.height,
            Text(
              'Set duration',
              style: context.textTheme.bodyLarge,
            ),
            10.height,
            BoxContainer(
                radius: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DateTimePicker(
                      onTap: () async {
                        final result = await showDatePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2050),
                        );
                        date.value = result;
                      },
                      title: date.value?.formatDate(),
                    ),
                  ],
                )),
            30.height,
            PrimaryButton(text: 'Create goal')
          ],
        ));
  }
}
