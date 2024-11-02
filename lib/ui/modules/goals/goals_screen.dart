import 'package:flutter/cupertino.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/ui/components/app_bar.dart';
import 'package:reentry/ui/components/container/box_container.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/modules/appointment/component/appointment_component.dart';
import 'package:reentry/ui/modules/goals/components/goal_item_component.dart';
import 'package:reentry/ui/modules/goals/create_goal_screen.dart';

import '../../components/buttons/app_button.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: const CustomAppbar(
        title: 'Goals',
      ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        label("Current goals"),
        5.height,
        BoxContainer(
          horizontalPadding: 10,
          radius: 10,

            child:
        ListView(shrinkWrap:true,
          children: [

            GoalItemComponent(title: "Excercise",progress: 70,),
            GoalItemComponent(title: "Read bible daily",progress: 20,),
            GoalItemComponent(title: "Eat well for 3 straight monthss and two days",progress: 70,),

          ],
        )),
        10.height,
        Align(
          alignment: Alignment.centerRight,
          child: AppOutlineButton(
              title: 'Create new',
              onPress: () {
                context.push(CreateGoalScreen());
              }),
        ),
        10.height,
        label("History"),
        20.height,
        ListView(shrinkWrap:true,
          children: [

            GoalItemComponent(title: "Excercise",progress: 70,),
            GoalItemComponent(title: "Read bible daily",progress: 20,),
            GoalItemComponent(title: "Eat well for 3 straight monthss and two days",progress: 70,),

          ],
        )
      ],
    ));
  }
}
