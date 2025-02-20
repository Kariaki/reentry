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
                    50.height,
                    PrimaryButton(
                      text: 'Completed',
                      onPress: () {
                        context
                            .read<ActivityBloc>()
                            .add(UpdateActivityEvent(activity.copyWith(
                              progress: 100,
                            )));
                      },
                    ),
                    15.height,
                    PrimaryButton.dark(
                        text: 'Close',
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
        if (kIsWeb) {
          context.showSnackbarSuccess('Activity updated');
          context.popRoute();
          return;
        }
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
