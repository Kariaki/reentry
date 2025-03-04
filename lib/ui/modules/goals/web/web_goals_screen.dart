import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/data/model/goal_dto.dart';
import 'package:reentry/ui/components/error_component.dart';
import 'package:reentry/ui/components/loading_component.dart';
import 'package:reentry/ui/modules/appointment/component/table.dart';
import 'package:reentry/ui/modules/citizens/component/icon_button.dart';
import 'package:reentry/ui/modules/goals/bloc/goals_cubit.dart';
import 'package:reentry/ui/modules/goals/bloc/goals_state.dart';
import 'package:reentry/ui/modules/goals/create_goal_screen.dart';
import 'package:reentry/ui/modules/goals/goal_progress_screen.dart';

import '../../../components/date_time_picker.dart';

class WebGoalsPage extends HookWidget {
  const WebGoalsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      context.read<GoalCubit>().fetchGoals();
    }, []);
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
                    "Goals",
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

                GoalsTable(),
                30.height,
               BlocBuilder<GoalCubit, GoalCubitState>(builder: (context,state){
                 if(state.all.isEmpty){
                   return SizedBox();
                 }
                 return  Align(
                   alignment: Alignment.centerRight,
                   child: ConstrainedBox(
                     constraints: BoxConstraints(maxWidth: width / 3),
                     child: CustomIconButton(
                         backgroundColor: AppColors.greyDark,
                         textColor: AppColors.white,
                         label: "Create a new goal",
                         borderColor: AppColors.white,
                         onPressed: () {
                           // Beamer.of(context).beamToNamed('/goals/create');
                           context.displayDialog(
                               CreateGoalScreen(successCallback: () {
                                 Navigator.pop(context);
                               }));
                         }),
                   ),
                 );
               })
              ],
            ),
          ),
        ));
  }
}

class GoalsTable extends StatelessWidget {
  const GoalsTable({super.key, this.userId});
  final String? userId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GoalCubit, GoalCubitState>(
      builder: (context, state) {
        if (state.state is GoalsLoading) {
          return const LoadingComponent();
        }
        if (state.state is GoalSuccess) {
          List<GoalDto> goals = state.goals;

          if(goals.isEmpty){
            return ErrorComponent(
              title: 'You have no goals yet',
              description: 'Click the button to create a new goal.',
              actionButtonText: 'Create goal',
              onActionButtonClick: (){
                context.displayDialog(
                    CreateGoalScreen(successCallback: () {
                      Navigator.pop(context);
                    }));
              },
            );
          }
          return _buildTable(context, goals);
        }
        return ErrorComponent(
          showButton: true,
          title: "Something went wrong",
          description: "Please try again!",
          onActionButtonClick: () {
            context.read<GoalCubit>().fetchGoals(userId: userId);
          },
        );
      },
    );
  }

  Widget _buildTable(BuildContext context, List<GoalDto> goals) {
    final columns = [
      const DataColumn(label: TableHeader("Goal")),
      const DataColumn(label: TableHeader("Date created")),
      const DataColumn(label: TableHeader("Progress")),
      const DataColumn(label: TableHeader("Start date")),
      const DataColumn(label: TableHeader("Category")),
      if(userId==null)
      const DataColumn(label: Text("")),
    ];

    final rows = _buildRows(context, goals);

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

  List<DataRow> _buildRows(BuildContext context, List<GoalDto> goals) {
    return goals.map((item) {
      return DataRow(cells: [
        DataCell(Text(item.title, style: const TextStyle(color: Colors.white))),
        DataCell(Text(formatDate(item.createdAt),
            style: const TextStyle(color: Colors.white))),
        DataCell(_buildProgressCell(item.progress, context)),
        DataCell(Text(formatDate(item.createdAt),
            style: const TextStyle(color: Colors.white))),
        DataCell(Text(item.duration??'Daily',
            style: const TextStyle(color: Colors.white))),
        if(userId==null)
        DataCell(
          Row(
            children: [
              IconButton(
                icon:
                    const Icon(Icons.edit_outlined, color: AppColors.hintColor),
                onPressed: () {
                  _showEditGoalModal(context, item);
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () {
                  _deleteGoalOnPress(context, item.id);
                },
              ),
            ],
          ),
        ),
      ]);
    }).toList();
  }

  Widget _buildProgressCell(int progress, BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress / 100,
              backgroundColor: AppColors.hintColor,
              color: AppColors.white,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          '$progress%',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.greyWhite,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
        ),
      ],
    );
  }

  void _deleteGoalOnPress(BuildContext context, String id) {
    // AppAlertDialog.show(context,
    //     title: 'Delete goal?',
    //     description: 'Are you sure you want to delete this goal?',
    //     action: 'Delete', onClickAction: () {
    //       context.pop(); //
    //       context.read<GoalsBloc>().add(DeleteGoalEvent(widget.goal.id));
    //     });
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return BlocConsumer<GoalCubit, GoalCubitState>(
          listener: (context, state) {
            if (state.state is GoalSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Goal Deleted Successfully."),
                  backgroundColor: AppColors.green,
                ),
              );
              Navigator.pop(dialogContext);
            }
            if (state.state is GoalError) {
              final errorMessage = (state.state as GoalError).message;
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
            final isLoading = state.state is GoalsLoading;
            return AlertDialog(
              title: Text("Delete goal?",
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
                      "Are you sure you want to delete this goal?",
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
                          context.read<GoalCubit>().deleteGoal(id);
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

  void _showEditGoalModal(BuildContext context, GoalDto goal) {
    final titleController = TextEditingController(text: goal.title);
    final progressController = ValueNotifier<double>(goal.progress.toDouble());

    context.displayDialog(GoalProgressScreen(goal: goal));
  }
}
