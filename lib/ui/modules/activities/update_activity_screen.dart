import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/util/graph_data.dart';
import 'package:reentry/core/util/util.dart';
import 'package:reentry/data/model/activity_dto.dart';
import 'package:reentry/ui/components/buttons/primary_button.dart';
import 'package:reentry/ui/components/container/box_container.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/dialog/alert_dialog.dart';
import 'package:reentry/ui/modules/activities/bloc/activity_bloc.dart';
import 'package:reentry/ui/modules/activities/bloc/activity_event.dart';
import 'package:reentry/ui/modules/activities/chart/graph_component.dart';
import 'package:reentry/ui/modules/appointment/component/appointment_component.dart';
import 'package:reentry/ui/modules/shared/success_screen.dart';
import '../../../core/theme/colors.dart';
import '../../../generated/assets.dart';
import '../calender/calender_screen.dart';
import 'bloc/activity_state.dart';

class ActivityProgressScreen extends HookWidget {
  final ActivityDto activity;

  const ActivityProgressScreen({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    final currentDate =
        useState<String>(DateTime.now().toIso8601String().split('T')[0]);
    final textTheme = context.textTheme;
    final key = GlobalKey<FormState>();
    final days = activity.timeLine
        .map((e) => DateTime.fromMillisecondsSinceEpoch(e))
        .toList();
    final formattedDays = activity.timeLine
        .map((e) => DateTime.fromMillisecondsSinceEpoch(e).formatDate())
        .toList();
    final monthly = useState<bool>(false);
    return BlocConsumer<ActivityBloc, ActivityState>(builder: (context, state) {
      final monthlyGraphData = GraphData().monthlyYAxis(activity.timeLine);
      return BaseScaffold(
          isLoading: state is ActivityLoading,
          child: SingleChildScrollView(
            child: Form(
                key: key,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    55.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              Assets.svgGoal,
                              width: 24,
                              height: 24,
                            ),
                            5.width,
                            Text(
                              activity.title,
                              style: textTheme.bodyLarge,
                            ),
                          ],
                        ),
                        if (!kIsWeb)
                          IconButton(
                            onPressed: () {
                              _deleteGoalOnPress(context);
                            },
                            icon: SvgPicture.asset(Assets.svgDeleteRound),
                          )
                        else
                          const SizedBox(width: 48),
                      ],
                    ),
                    5.height,
                    Text(
                      '${activity.dayStreak}',
                      style: textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'day streak',
                      style: textTheme.bodyMedium
                          ?.copyWith(color: AppColors.gray2),
                    ),
                    20.height,
                    const Text(
                      'Streak helps you to be consistent in efforts towards your goals',
                      textAlign: TextAlign.center,
                    ),
                    20.height,
                    Align(
                      alignment: Alignment.centerLeft,
                      child: label(
                          '${activity.frequency == Frequency.weekly ? 'Weekly' : 'Daily'} Progress'),
                    ),
                    15.height,
                    Wrap(
                      runSpacing: 5,
                      spacing: 10,
                      children: getCurrentWeekDays() //in days or in weeks
                          .map((e) => dateComponent(e,
                              selected: e.split('T')[0] == currentDate.value,
                              highlighted: formattedDays
                                  .contains(DateTime.parse(e).formatDate()),
                              onClick: (result) {}))
                          .toList(),
                    ),
                    20.height,
                    Align(
                      alignment: Alignment.centerLeft,
                      child: label('Progress'),
                    ),
                    15.height,
                    BoxContainer(
                        radius: 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Monthly Performance',
                              style: context.textTheme.bodySmall,
                            ),
                            10.height,
                            GraphComponent(timeLines: monthlyGraphData),
                            20.height,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 20,
                                  color: AppColors.primary,
                                  height: 5,
                                ),
                                5.width,
                                Text(
                                  'Activity',
                                  style: context.textTheme.bodySmall,
                                ),
                              ],
                            )
                          ],
                        )),
                    50.height,
                    PrimaryButton(
                      text: 'Save changes',
                      onPress: () {
                        int streakCount = activity.dayStreak;
                        final lastDay = days.lastOrNull?.formatDate();
                        final date = DateTime.now();
                        final streak = lastDay ==
                            date.subtract(const Duration(days: 1)).formatDate();
                        if (streak) {
                          streakCount += streakCount;
                        }
                        final record = DateTime.now()
                            .copyWith(
                                second: 0,
                                millisecond: 0,
                                microsecond: 0,
                                minute: 0,
                                hour: 0)
                            .millisecondsSinceEpoch;
                        List<int> newTimeLine = [
                          ...activity.timeLine,
                          if (!activity.timeLine.contains(record)) record
                        ];
                        final daysYouIntendToBeActive = Utility.getDateRange(
                                DateTime.fromMillisecondsSinceEpoch(
                                    activity.startDate),
                                DateTime.fromMillisecondsSinceEpoch(
                                    activity.endDate),
                                activity.frequency)
                            .length;
                        final daysYouWereActive = newTimeLine.length;
                        final computeProgress =
                            (daysYouWereActive * 100) / daysYouIntendToBeActive;
                        context
                            .read<ActivityBloc>()
                            .add(UpdateActivityEvent(activity.copyWith(
                              dayStreak: streakCount,
                              progress: computeProgress.toInt(),
                              timeLine: newTimeLine,
                            )));
                      },
                    ),
                    10.height,
                    PrimaryButton.dark(
                        text: 'Go back',
                        onPress: () {
                          context.popRoute();
                        })
                  ],
                )),
          ));
    }, listener: (_, state) {
      if (state is ActivityError) {
        context.showSnackbarError(state.message);
      }
      if (state is DeleteActivitySuccess) {
        context.pushReplace(SuccessScreen(
          callback: () {},
          title: 'Activity deleted!',
          description: "Your activity has been deleted.",
        ));
      }
      if (state is ActivityUpdateSuccess) {
        context.pushReplace(SuccessScreen(
          callback: () {},
          title: 'Activity updated!',
          description: "Your progress has been saved",
        ));
      }
    });
  }

  void _deleteGoalOnPress(BuildContext context) {
    AppAlertDialog.show(context,
        title: "Delete activity?",
        description: "are you sure you want to delete this activity?",
        action: 'Delete', onClickAction: () {
      context.popRoute(); //
      context.read<ActivityBloc>().add(DeleteActivityEvent(activity.id));
    });
  }
}
