import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/ui/components/app_bar.dart';
import 'package:reentry/ui/components/container/box_container.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/modules/activities/bloc/activity_cubit.dart';
import 'package:reentry/ui/modules/activities/bloc/activity_state.dart';
import 'package:reentry/ui/modules/activities/chart/graph_component.dart';
import 'package:reentry/ui/modules/activities/components/activity_component.dart';
import 'package:reentry/ui/modules/activities/create_activity_screen.dart';
import 'package:reentry/ui/modules/calender/calender_screen.dart';
import 'package:reentry/ui/modules/root/navigations/home_navigation_screen.dart';
import '../../components/buttons/app_button.dart';
import 'package:reentry/ui/components/error_component.dart';
import 'package:reentry/ui/components/loading_component.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        appBar: const CustomAppbar(
          title: 'Reentry',
        ),
        child: BlocBuilder<ActivityCubit, ActivityCubitState>(
            builder: (context, state) {
          if (state is ActivityLoading) {
            return const LoadingComponent();
          }
          if (state.state is ActivitySuccess) {
            if (state.activity.isEmpty) {
              return ErrorComponent(
                  showButton: true,
                  title: "Oops!",
                  description: "You do not have any saved activities yet",
                  actionButtonText: 'Create new activities',
                  onActionButtonClick: () {
                    context.pushRoute(const CreateActivityScreen());
                  });
            }
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Daily progress",style: TextStyle(fontSize: 18,color: AppColors.white,fontWeight: FontWeight.bold)),
                  10.height,
                  const Text("View your daily progress towards your goals",style: TextStyle(fontSize: 14,),),
                  20.height,
                  weekCalender(),
                  20.height,
                  label("Activities"),
                  5.height,
                  BoxContainer(
                      horizontalPadding: 10,
                      radius: 10,
                      filled: false,
                      child: ListView(
                        shrinkWrap: true,
                        children: state.activity.map((activity) {
                          return ActivityComponent(activity: activity);
                        }).toList(),
                      )),
                  10.height,
                  Align(
                    alignment: Alignment.centerRight,
                    child: AppOutlineButton(
                        title: 'Create new',
                        onPress: () {
                          context.pushRoute(const CreateActivityScreen());
                        }),
                  ),
                  10.height,
                  label("History"),
                  20.height,
                  if (state.history.isNotEmpty)
                    ListView(
                      shrinkWrap: true,
                      children: state.history.map((activity) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: ActivityComponent(activity: activity),
                        );
                      }).toList(),
                    )
                  else
                    const Center(
                        child: Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text('No history recorded',
                          style: TextStyle(color: AppColors.gray2)),
                    ))
                ],
              ),
            );
          }
          return ErrorComponent(
              showButton: false,
              title: "Something went wrong",
              description: "Please try again!",
              onActionButtonClick: () {
                context.read<ActivityCubit>().fetchActivities();
              });
        }));
  }

  Widget weekCalender() {
    final week = getCurrentWeekDays();
    final data = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
    return BoxContainer(
        verticalPadding: 15,
        radius: 10,
        horizontalPadding: 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(week.length, (index) {
            final date = DateTime.parse(week[index]);
            final formatedDate = date.formatDate();
            final currentFormatedDate = DateTime.now().formatDate();
            final isSelected = formatedDate == currentFormatedDate;
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(data[index],style: const TextStyle(color: AppColors.gray2,fontSize: 12),),
                5.height,
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration:isSelected? const ShapeDecoration(
                      shape: CircleBorder(), color: AppColors.primary):null,
                  child:  Text(
                    '${date.day}',
                    style: const TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                )
              ],
            );
          }),
        ));
  }
}
