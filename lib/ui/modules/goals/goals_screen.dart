import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/ui/components/app_bar.dart';
import 'package:reentry/ui/components/container/box_container.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/modules/goals/bloc/goals_cubit.dart';
import 'package:reentry/ui/modules/goals/bloc/goals_state.dart';
import 'package:reentry/ui/modules/goals/components/goal_item_component.dart';
import 'package:reentry/ui/modules/goals/create_goal_screen.dart';
import 'package:reentry/ui/modules/root/navigations/home_navigation_screen.dart';

import '../../components/buttons/app_button.dart';
import '../../components/error_component.dart';
import '../../components/loading_component.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        appBar: const CustomAppbar(
          title: 'Goals',
        ),
        child: BlocBuilder<GoalCubit, GoalState>(builder: (context, state) {
          if (state is GoalsLoading) {
            return const LoadingComponent();
          }
          if (state is GoalDataSuccess) {
            if (state.goals.isEmpty) {
              return ErrorComponent(
                  showButton: false,
                  title: "Oops",
                  description: "You do not have any saved goals yet",
                  actionButtonText: 'Create new goal',
                  onActionButtonClick: () {
                    context.push(const CreateGoalScreen());
                  });
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                label("Current goals"),
                5.height,
                BoxContainer(
                    horizontalPadding: 10,
                    radius: 10,
                    child: ListView(
                      shrinkWrap: true,
                      children: state.goals.map((goal) {
                        return GoalItemComponent(goal: goal);
                      }).toList(),
                    )),
                10.height,
                Align(
                  alignment: Alignment.centerRight,
                  child: AppOutlineButton(
                      title: 'Create new',
                      onPress: () {
                        context.push(const CreateGoalScreen());
                      }),
                ),
                10.height,
                label("History"),
                20.height,
                // ListView(
                //   shrinkWrap: true,
                //   children: [
                //     GoalItemComponent(
                //       title: "Excercise",
                //       progress: 70,
                //     ),
                //     GoalItemComponent(
                //       title: "Read bible daily",
                //       progress: 20,
                //     ),
                //     GoalItemComponent(
                //       title: "Eat well for 3 straight monthss and two days",
                //       progress: 70,
                //     ),
                //   ],
                // )
              ],
            );
          }
          return ErrorComponent(
              showButton: false,
              title: "Something went wrong",
              description: "Please try again!",
              onActionButtonClick: () {
                context.read<GoalCubit>().fetchGoals();
              });
        }));
  }
}
