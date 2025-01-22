import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/data/model/activity_dto.dart';
import 'package:reentry/generated/assets.dart';
import 'package:reentry/ui/components/error_component.dart';
import 'package:reentry/ui/components/loading_component.dart';
import 'package:reentry/ui/dialog/alert_dialog.dart';
import 'package:reentry/ui/modules/activities/bloc/activity_cubit.dart';
import 'package:reentry/ui/modules/activities/bloc/activity_state.dart';
import 'package:reentry/ui/modules/activities/create_activity_screen.dart';
import 'package:reentry/ui/modules/activities/update_activity_screen.dart';
import 'package:reentry/ui/modules/appointment/component/table.dart';
import 'package:reentry/ui/modules/citizens/component/icon_button.dart';

class WebActivityScreen extends StatefulWidget {
  const WebActivityScreen({super.key});

  @override
  _WebActivityScreenState createState() => _WebActivityScreenState();
}

class _WebActivityScreenState extends State<WebActivityScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: AppColors.greyDark,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: AppBar(
            backgroundColor: AppColors.greyDark,
            flexibleSpace: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Activities",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.greyWhite,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ActivitiesTable(),
                30.height,
                Align(
                  alignment: Alignment.centerRight,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: width / 3),
                    child: CustomIconButton(
                        backgroundColor: AppColors.greyDark,
                        textColor: AppColors.white,
                        label: "Create a new activity",
                        borderColor: AppColors.white,
                        onPressed: () {
                          // Beamer.of(context).beamToNamed('/goals/create');
                          context.displayDialog(
                              CreateActivityScreen(successCallback: () {
                            Navigator.pop(context);
                          }));
                        }),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class ActivitiesTable extends StatelessWidget {
  const ActivitiesTable({super.key, this.userId});
  final String? userId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ActivityCubit()..fetchActivities(userId: userId),
      child: BlocBuilder<ActivityCubit, ActivityCubitState>(
        builder: (context, state) {
          if (state.state is ActivityLoading) {
            return const LoadingComponent();
          }
          if (state.state is ActivitySuccess) {
            List<ActivityDto> activity = state.activity;
            if (activity.isEmpty) {
              return ErrorComponent(
                showButton: userId == null,
                title: "Oops",
                description: "You do not have any saved activities yet",
                actionButtonText: 'Create new activity',
                onActionButtonClick: () {
                  context.read<ActivityCubit>().fetchActivities(userId: userId);
                },
              );
            }

            return _buildTable(context, activity);
          }
          return ErrorComponent(
            showButton: true,
            title: "Something went wrong",
            description: "Please try again!",
            onActionButtonClick: () {
              context.read<ActivityCubit>().fetchActivities(userId: userId);
            },
          );
        },
      ),
    );
  }

  Widget _buildTable(BuildContext context, List<ActivityDto> activity) {
    final columns = [
      const DataColumn(label: TableHeader("Activity")),
      const DataColumn(label: TableHeader("Date created")),
      const DataColumn(label: TableHeader("Streak")),
      if(userId==null)
      const DataColumn(label: Text("")),
    ];

    final rows = _buildRows(context, activity);

    return Container(
      color: AppColors.greyDark,
      child: ReusableTable(
        columns: columns,
        rows: rows,
        headingRowColor: AppColors.white,
        dataRowColor: Colors.grey[900],
        columnSpacing: 20.0,
        dataRowHeight: 56.0,
      ),
    );
  }

  String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  List<DataRow> _buildRows(BuildContext context, List<ActivityDto> activity) {
    return activity.map((item) {
      DateTime startDate = DateTime.fromMillisecondsSinceEpoch(item.startDate);
      return DataRow(cells: [
        DataCell(Text(item.title, style: const TextStyle(color: Colors.white))),
        DataCell(Text(formatDate(startDate),
            style: const TextStyle(color: Colors.white))),
        DataCell(Row(
          children: [
            Text(item.dayStreak.toString(),
                style: const TextStyle(color: Colors.white)),
            SvgPicture.asset(Assets.webStreak),
          ],
        )),
        if(userId==null)
        DataCell(
          Row(
            children: [
              IconButton(
                icon:
                    const Icon(Icons.edit_outlined, color: AppColors.hintColor),
                onPressed: () {
                  _showEditActivityModal(context, item);
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () {
                  _deleteActivityOnPress(context, item.id);
                },
              ),
            ],
          ),
        ),
      ]);
    }).toList();
  }

  void _deleteActivityOnPress(BuildContext context, String id) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return BlocConsumer<ActivityCubit, ActivityCubitState>(
          listener: (context, state) {
            if (state.state is ActivitySuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Activity Deleted Successfully."),
                  backgroundColor: AppColors.green,
                ),
              );
              Navigator.pop(dialogContext);
            }
            if (state.state is ActivityError) {
              final errorMessage = (state.state as ActivityError).message;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(errorMessage),
                  backgroundColor: AppColors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            final textStyle = context.textTheme;
            final isLoading = state.state is ActivityLoading;
            return AlertDialog(
              title: Text("Delete activity?",
                  style: textStyle.bodyLarge?.copyWith(
                      color: AppColors.black, fontWeight: FontWeight.bold)),
              content: isLoading
                  ? const SizedBox(
                      height: 50,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Text(
                      "Are you sure you want to delete this activity?",
                      style: textStyle.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600, color: AppColors.black),
                    ),
              actions: [
                if (!isLoading)
                  TextButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                    },
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: AppColors.black),
                    ),
                  ),
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          context.read<ActivityCubit>().deleteActivity(id);
                        },
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text("Delete",
                          style: TextStyle(color: AppColors.black)),
                )
              ],
            );
          },
        );
      },
    );
  }

  void _showEditActivityModal(BuildContext context, ActivityDto item) {
    context.displayDialog(ActivityProgressScreen(activity: item));
  }
}
