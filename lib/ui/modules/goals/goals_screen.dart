import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/ui/components/app_bar.dart';
import 'package:reentry/ui/components/container/box_container.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/modules/goals/bloc/goals_cubit.dart';
import 'package:reentry/ui/modules/goals/bloc/goals_state.dart';
import 'package:reentry/ui/modules/goals/components/goal_item_component.dart';
import 'package:reentry/ui/modules/goals/create_goal_screen.dart';
import 'package:reentry/ui/modules/root/navigations/home_navigation_screen.dart';
import '../../components/buttons/app_button.dart';
import 'package:reentry/ui/components/error_component.dart';
import 'package:reentry/ui/components/loading_component.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        appBar: const CustomAppbar(
          title: 'Goals',
        ),
        child: BlocBuilder<GoalCubit, GoalCubitState>(builder: (context, state) {
          if (state is GoalsLoading) {
            return const LoadingComponent();
          }
          if (state.state is GoalSuccess) {
            if (state.goals.isEmpty) {
              return ErrorComponent(
                  showButton: true,
                  title: "Oops",
                  description: "You do not have any saved goals yet",
                  actionButtonText: 'Create new goal',
                  onActionButtonClick: () {
                    context.pushRoute(const CreateGoalScreen());
                  });
            }
            return SingleChildScrollView(
              child: Column(
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
                          context.pushRoute(const CreateGoalScreen());
                        }),
                  ),
                  10.height,
                  label("History"),
                  20.height,
                  if(state.history.isNotEmpty)
                    ListView(
                      shrinkWrap: true,
                      children: state.history.map((goal) {
                        return Padding(padding: const EdgeInsets.symmetric(vertical: 10),
                        child: GoalItemComponent(goal: goal),);
                      }).toList(),
                    )
                  else
                    const Center(child: Padding(padding: EdgeInsets.only(top: 20),
                      child: Text('No goal history recorded',style: TextStyle(color: AppColors.gray2)),))
                ],
              ),
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
