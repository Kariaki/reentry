import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/ui/components/input/input_field.dart';
import 'package:reentry/ui/modules/appointment/component/table.dart';
import 'package:reentry/ui/modules/citizens/component/icon_button.dart';
import 'package:reentry/ui/modules/goals/goal_progress_screen.dart';

class WebGoalsPage extends StatefulWidget {
  const WebGoalsPage({super.key});

  @override
  _WebGoalsPageState createState() => _WebGoalsPageState();
}

class _WebGoalsPageState extends State<WebGoalsPage> {
  @override
  Widget build(BuildContext context) {
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
              const GoalsTable(),
              30.height,
              SizedBox(
                width: double.infinity,
                child: CustomIconButton(
                    backgroundColor: AppColors.greyDark,
                    textColor: AppColors.white,
                    label: "Create a new goal",
                    borderColor: AppColors.white,
                    onPressed: () {
                      Beamer.of(context).beamToNamed('/goals/create');
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class GoalsTable extends StatelessWidget {
  const GoalsTable({super.key});

  @override
  Widget build(BuildContext context) {
    final columns = [
      const DataColumn(label: TableHeader("Goal")),
      const DataColumn(label: TableHeader("Date created")),
      const DataColumn(label: TableHeader("Progress")),
      const DataColumn(label: TableHeader("Start date")),
      const DataColumn(label: TableHeader("End date")),
      const DataColumn(label: Text("")),
    ];

    final rows = _buildRows(context);

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

  List<DataRow> _buildRows(BuildContext context) {
    final data = [
      {
        'goal': 'Read a book',
        'dateCreated': '22 Jan 2022',
        'progress': 60,
        'startDate': '22 Jan 2022',
        'endDate': '22 Jan 2022',
      },
      {
        'goal': 'Lose 10 pounds',
        'dateCreated': '20 Jan 2022',
        'progress': 72,
        'startDate': '20 Jan 2022',
        'endDate': '20 Jan 2022',
      },
      {
        'goal': 'Run a marathon',
        'dateCreated': '28 Jan 2022',
        'progress': 66,
        'startDate': '28 Jan 2022',
        'endDate': '28 Jan 2022',
      },
    ];

    return data.map((item) {
      return DataRow(cells: [
        DataCell(Text(item['goal'] as String,
            style: const TextStyle(color: Colors.white))),
        DataCell(Text(item['dateCreated'] as String,
            style: const TextStyle(color: Colors.white))),
        DataCell(_buildProgressCell(item['progress'] as int, context)),
        DataCell(Text(item['startDate'] as String,
            style: const TextStyle(color: Colors.white))),
        DataCell(Text(item['endDate'] as String,
            style: const TextStyle(color: Colors.white))),
        DataCell(
          Row(
            children: [
              IconButton(
                icon:
                    const Icon(Icons.edit_outlined, color: AppColors.hintColor),
                onPressed: () {
                  _showEditGoalModal(context);
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () {},
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

  void _showEditGoalModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          maxChildSize: 0.9,
          builder: (_, scrollController) {
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppColors.greyDark,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Edit goal",
                      style: context.textTheme.bodyLarge?.copyWith(
                        color: AppColors.greyWhite,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Goal title",
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: AppColors.greyWhite,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        10.height,
                        const InputField(
                          hint: "Grow a beard",
                          radius: 5.0,
                        ),
                        10.height,
                        Text(
                          "Duration",
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: AppColors.greyWhite,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        10.height,
                        const InputField(
                          hint: "6 October 2024 - 24 December 2024",
                          radius: 5.0,
                          suffixIcon: Icon(Icons.calendar_today_outlined),
                        ),
                        20.height,
                        Text(
                          "Progress",
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: AppColors.greyWhite,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        10.height,
                        GoalSlider(
                          initial: 30.25,
                          callback: (value, duration) {},
                          onChange: (value) {},
                        ),
                        20.height,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            CustomIconButton(
                                backgroundColor: AppColors.white,
                                textColor: AppColors.black,
                                label: "Save",
                                onPressed: () {}),
                            20.height,
                            CustomIconButton(
                                backgroundColor: AppColors.greyDark,
                                textColor: AppColors.white,
                                label: "Cancel",
                                borderColor: AppColors.white,
                                onPressed: () {
                                  Navigator.pop(context);
                                })
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
