// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/generated/assets.dart';
import 'package:reentry/ui/components/input/input_field.dart';
import 'package:reentry/ui/modules/appointment/component/appointment_card.dart';
import 'package:reentry/ui/modules/appointment/component/appointment_component.dart';
import 'package:reentry/ui/modules/appointment/component/table.dart';
import 'package:reentry/ui/modules/appointment/create_appointment_screen.dart';
import 'package:reentry/ui/modules/citizens/component/icon_button.dart';
import 'package:reentry/ui/modules/citizens/component/profile_card.dart';
import 'package:reentry/ui/modules/goals/goal_progress_screen.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyDark,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: AppBar(
          backgroundColor: AppColors.greyDark,
          flexibleSpace: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Search",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.greyWhite,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 10),
                CustomIconButton(
                    backgroundColor: AppColors.greyDark,
                    textColor: AppColors.white,
                    label: "Create new",
                    icon: Assets.editIc,
                    borderColor: AppColors.white,
                    onPressed: () {
                      _showCreateAppointmentModal(context);
                    })
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
              Text(
                "Appointment for today",
                style: context.textTheme.bodyLarge?.copyWith(
                  color: AppColors.greyWhite,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              AppointmentProfileSection(
                name: "Sam",
                email: "sam@gmail.com",
                imageUrl: Assets.citiImg,
                appointmentDate: "21/10/2024",
                appointmentTime: "9:30am",
                note: "I will be coming with my pet cat, Rex",
                onReschedule: () {
                  _showRescheduleModal(context);
                },
                onCancel: () {
                  _showDeleteModal(context);
                },
                onAccept: () {
                  print("Accept tapped");
                },
              ),
              const SizedBox(height: 60),
              Text(
                "Appointment history",
                style: context.textTheme.bodyLarge?.copyWith(
                  color: AppColors.greyWhite,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              30.height,
              AppointmentComponent(invitation: true),
              20.height,
              AppointmentComponent(
                showCreate: false,
              ),
              const SizedBox(height: 10),
              const AppointmentHistoryTable(),
              const SizedBox(height: 10),
              const ProgressTable()
            ],
          ),
        ),
      ),
    );
  }

  void _showCreateAppointmentModal(BuildContext context) {
  context.displayDialog( CreateAppointmentScreen());
  }

  void _showRescheduleModal(BuildContext context) {
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
                      "Reschedule Appointment",
                      style: context.textTheme.bodyLarge?.copyWith(
                        color: AppColors.greyWhite,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const AppointmentProfileSection(
                      name: "Sam",
                      email: "sam@gmail.com",
                      imageUrl: Assets.citiImg,
                      appointmentDate: "21/10/2024",
                      appointmentTime: "9:30am",
                      note: "I will be coming with my pet cat, Rex",
                    ),
                    const SizedBox(height: 20),
                    _buildRescheduleForm(),
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

  void _showDeleteModal(BuildContext context) {
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
              child: ListView(
                controller: scrollController,
                children: [
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      SizedBox(
                        width: 168,
                        child: ProfileCard(
                          name: "Sam",
                          email: "sam@gmail.com",
                          imageUrl: Assets.citiImg,
                          showActions: false,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Delete Eduard Marco?",
                              style: context.textTheme.bodyLarge?.copyWith(
                                color: AppColors.greyWhite,
                                fontWeight: FontWeight.w700,
                                fontSize: 32,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "This action cannot be undone",
                              style: context.textTheme.bodyLarge?.copyWith(
                                color: AppColors.greyWhite,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildRescheduleForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select date and time",
          style: context.textTheme.bodyLarge?.copyWith(
            color: AppColors.greyWhite,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 10),
        const InputField(
          hint: "6 October 2024 9:30AM",
          radius: 5.0,
          suffixIcon: Icon(Icons.calendar_today_outlined),
        ),
        SizedBox(height: 20),
        Text(
          "Note",
          style: context.textTheme.bodyLarge?.copyWith(
            color: AppColors.greyWhite,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 10),
        InputField(
          hint: "Enter your message",
          radius: 5.0,
          maxLines: 10,
          lines: 6,
          suffixIcon: Icon(Icons.calendar_today_outlined),
        ),
        SizedBox(height: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomIconButton(
                backgroundColor: AppColors.white,
                textColor: AppColors.black,
                label: "Save",
                onPressed: () {}),
            SizedBox(height: 20),
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
    );
  }
}

class AppointmentHistoryTable extends StatelessWidget {
  const AppointmentHistoryTable({super.key});

  @override
  Widget build(BuildContext context) {
    final columns = [
      const DataColumn(label: TableHeader("Name")),
      const DataColumn(label: TableHeader("Email")),
      const DataColumn(label: TableHeader("Date")),
      const DataColumn(label: TableHeader("Visit Time")),
      const DataColumn(label: TableHeader("Care Team")),
      const DataColumn(label: Text("Actions")),
    ];

    final rows = _buildRows(context);

    return Container(
      color: Colors.black,
      child: ReusableTable(
        columns: columns,
        rows: rows,
        headingRowColor: AppColors.white,
        dataRowColor: AppColors.greyDark,
        columnSpacing: 20.0,
        dataRowHeight: 56.0,
      ),
    );
  }

  List<DataRow> _buildRows(BuildContext context) {
    final data = [
      {
        'name': 'Leslie Alexander',
        'email': 'leslie.alexander@example.com',
        'date': '10/10/2020',
        'visitTime': '09:15–09:45am',
        'careTeam': 'Jacob Jones',
      },
      {
        'name': 'Ronald Richards',
        'email': 'ronald.richards@example.com',
        'date': '10/12/2020',
        'visitTime': '12:00–12:45pm',
        'careTeam': 'Theresa Webb',
      },
    ];

    return data.map((item) {
      return DataRow(cells: [
        DataCell(Text(item['name'] ?? '')),
        DataCell(Text(item['email'] ?? '')),
        DataCell(Text(item['date'] ?? '')),
        DataCell(Text(item['visitTime'] ?? '')),
        DataCell(Text(item['careTeam'] ?? '')),
        DataCell(
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {},
          ),
        ),
      ]);
    }).toList();
  }
}

class ProgressTable extends StatelessWidget {
  const ProgressTable({super.key});

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
                        SizedBox(height: 10),
                        const InputField(
                          hint: "Grow a beard",
                          radius: 5.0,
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Duration",
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: AppColors.greyWhite,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 10),
                        InputField(
                          hint: "6 October 2024 - 24 December 2024",
                          radius: 5.0,
                          suffixIcon: Icon(Icons.calendar_today_outlined),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Progress",
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: AppColors.greyWhite,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 10),
                        GoalSlider(
                          initial: 30.25,
                          callback: (value, duration) {},
                          onChange: (value) {},
                        ),
                        SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            CustomIconButton(
                                backgroundColor: AppColors.white,
                                textColor: AppColors.black,
                                label: "Save",
                                onPressed: () {}),
                            SizedBox(height: 20),
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
