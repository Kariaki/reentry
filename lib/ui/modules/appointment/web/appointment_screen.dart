// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/data/model/appointment_dto.dart';
import 'package:reentry/generated/assets.dart';
import 'package:reentry/ui/components/error_component.dart';
import 'package:reentry/ui/components/input/input_field.dart';
import 'package:reentry/ui/components/loading_component.dart';
import 'package:reentry/ui/modules/appointment/bloc/appointment_cubit.dart';
import 'package:reentry/ui/modules/appointment/bloc/appointment_state.dart';
import 'package:reentry/ui/modules/appointment/component/appointment_card.dart';
import 'package:reentry/ui/modules/appointment/component/appointment_component.dart';
import 'package:reentry/ui/modules/appointment/component/table.dart';
import 'package:reentry/ui/modules/appointment/create_appointment_screen.dart';
import 'package:reentry/ui/modules/authentication/bloc/account_cubit.dart';
import 'package:reentry/ui/modules/citizens/component/icon_button.dart';
import 'package:reentry/ui/modules/citizens/component/profile_card.dart';
import 'package:reentry/ui/modules/goals/goal_progress_screen.dart';
import 'package:reentry/ui/modules/shared/cubit_state.dart';

class AppointmentPage extends HookWidget {
  const AppointmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _searchController = TextEditingController();

    String _searchQuery = '';

    String? formatTimestamp(int? timestamp) {
      if (timestamp == null) return null;
      final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      return DateFormat('dd/MM/yyyy, hh:mm a').format(dateTime);
    }

    String formatDate(DateTime date) {
      return DateFormat('dd MMM yyyy').format(date);
    }

    final accountCubit = context.watch<AccountCubit>().state;
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
      body: BlocBuilder<AppointmentCubit, AppointmentCubitState>(
        builder: (context, state) {
          if (state.state is CubitStateLoading) {
            return const LoadingComponent();
          }
          if (state.state is CubitStateError) {
            return ErrorComponent(
              showButton: true,
              onActionButtonClick: () {
                context
                    .read<AppointmentCubit>()
                    .fetchAppointments(accountCubit?.userId ?? '');
              },
            );
          }
          if (state.state is CubitStateSuccess) {
            final result = state.data;
            final forToday = state.appointmentForToday;
            final history = result;

            return SingleChildScrollView(
              child: Padding(
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
                      Column(
                        children: [
                          if (forToday.isEmpty)
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.2,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.calendar_today_outlined,
                                        size: 40, color: AppColors.hintColor),
                                    16.height,
                                    Text(
                                      "No appointments for today!",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: AppColors.hintColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: ListView.builder(
                                itemCount: forToday.length,
                                itemBuilder: (context, index) {
                                  final appointment = forToday[index];
                                  return AppointmentProfileSection(
                                    name: appointment.participantName ?? 'Me',
                                    email: appointment?.location??'',
                                    imageUrl: appointment.participantAvatar ??

                                        appointment.creatorAvatar,
                                    createdByMe: appointment.createdByMe,
                                    appointmentDate:
                                        formatDate(appointment.date),
                                    appointmentTime:
                                        formatTimestamp(appointment.timestamp)
                                            ?.split(', ')[1],
                                    note: appointment.description,
                                    onReschedule:!appointment.createdByMe?null: () {
                                      // _showRescheduleModal(context, appointment);
                                    },
                                    onCancel:!appointment.createdByMe?null: () {
                                      // _showCancelModal(context);
                                    },
                                    onAccept:appointment.createdByMe?null: () {
                                      // print("Accepted appointment with ${appointment.name}");
                                    },
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 60),
                      AppointmentComponent(invitation: true),
                      20.height,
                      Text(
                        "Appointment history",
                        style: context.textTheme.bodyLarge?.copyWith(
                          color: AppColors.greyWhite,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      30.height,
                      AppointmentHistoryTable(history: history),
                    ],
                  ),
                ),
              ),
            );
          }
          return const ErrorComponent(
            showButton: false,
            title: "There is nothing here",
            description: "You don't have an appointment to view",
          );
        },
      ),
    );
  }

  void _showCreateAppointmentModal(BuildContext context) {
    context.displayDialog(CreateAppointmentScreen());
  }

// void _showRescheduleModal(BuildContext context) {
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     backgroundColor: Colors.transparent,
//     builder: (context) {
//       return DraggableScrollableSheet(
//         initialChildSize: 0.8,
//         maxChildSize: 0.9,
//         builder: (_, scrollController) {
//           return Container(
//             padding: const EdgeInsets.all(20),
//             decoration: const BoxDecoration(
//               color: AppColors.greyDark,
//               borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//             ),
//             child: SingleChildScrollView(
//               controller: scrollController,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Reschedule Appointment",
//                     style: context.textTheme.bodyLarge?.copyWith(
//                       color: AppColors.greyWhite,
//                       fontWeight: FontWeight.w700,
//                       fontSize: 16,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   const AppointmentProfileSection(
//                     name: "Sam",
//                     email: "sam@gmail.com",
//                     imageUrl: Assets.citiImg,
//                     appointmentDate: "21/10/2024",
//                     appointmentTime: "9:30am",
//                     note: "I will be coming with my pet cat, Rex",
//                   ),
//                   const SizedBox(height: 20),
//                   _buildRescheduleForm(),
//                   const SizedBox(height: 20),
//                 ],
//               ),
//             ),
//           );
//         },
//       );
//     },
//   );
// }

// void _showDeleteModal(BuildContext context) {
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     backgroundColor: Colors.transparent,
//     builder: (context) {
//       return DraggableScrollableSheet(
//         initialChildSize: 0.8,
//         maxChildSize: 0.9,
//         builder: (_, scrollController) {
//           return Container(
//             padding: const EdgeInsets.all(20),
//             decoration: const BoxDecoration(
//               color: AppColors.greyDark,
//               borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//             ),
//             child: ListView(
//               controller: scrollController,
//               children: [
//                 const SizedBox(height: 10),
//                 Row(
//                   children: [
//                     SizedBox(
//                       width: 168,
//                       child: ProfileCard(
//                         name: "Sam",
//                         email: "sam@gmail.com",
//                         imageUrl: Assets.citiImg,
//                         showActions: false,
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Delete Eduard Marco?",
//                             style: context.textTheme.bodyLarge?.copyWith(
//                               color: AppColors.greyWhite,
//                               fontWeight: FontWeight.w700,
//                               fontSize: 32,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             "This action cannot be undone",
//                             style: context.textTheme.bodyLarge?.copyWith(
//                               color: AppColors.greyWhite,
//                               fontWeight: FontWeight.w500,
//                               fontSize: 16,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//               ],
//             ),
//           );
//         },
//       );
//     },
//   );
// }

// Widget _buildRescheduleForm() {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Text(
//         "Select date and time",
//         style: context.textTheme.bodyLarge?.copyWith(
//           color: AppColors.greyWhite,
//           fontWeight: FontWeight.w700,
//           fontSize: 16,
//         ),
//       ),
//       SizedBox(height: 10),
//       const InputField(
//         hint: "6 October 2024 9:30AM",
//         radius: 5.0,
//         suffixIcon: Icon(Icons.calendar_today_outlined),
//       ),
//       SizedBox(height: 20),
//       Text(
//         "Note",
//         style: context.textTheme.bodyLarge?.copyWith(
//           color: AppColors.greyWhite,
//           fontWeight: FontWeight.w700,
//           fontSize: 16,
//         ),
//       ),
//       SizedBox(height: 10),
//       InputField(
//         hint: "Enter your message",
//         radius: 5.0,
//         maxLines: 10,
//         lines: 6,
//         suffixIcon: Icon(Icons.calendar_today_outlined),
//       ),
//       SizedBox(height: 20),
//       Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           CustomIconButton(
//               backgroundColor: AppColors.white,
//               textColor: AppColors.black,
//               label: "Save",
//               onPressed: () {}),
//           SizedBox(height: 20),
//           CustomIconButton(
//               backgroundColor: AppColors.greyDark,
//               textColor: AppColors.white,
//               label: "Cancel",
//               borderColor: AppColors.white,
//               onPressed: () {
//                 Navigator.pop(context);
//               })
//         ],
//       ),
//     ],
//   );
// }
}

class AppointmentHistoryTable extends StatelessWidget {
  const AppointmentHistoryTable({super.key, required this.history});

  final List<NewAppointmentDto> history;

  @override
  Widget build(BuildContext context) {
    final columns = [
      const DataColumn(label: TableHeader("Title")),
      const DataColumn(label: TableHeader("Location")),
      const DataColumn(label: TableHeader("Created By")),
      const DataColumn(label: TableHeader("Date")),
    ];

    if (history.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: const ErrorComponent(
          showButton: false,
          title: "There is nothing here",
          description: "You don't have an appointment to view",
        ),
      );
    }

    final rows = _buildRows();

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

  String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  List<DataRow> _buildRows() {
    return history.map((item) {
      return DataRow(
        cells: [
          DataCell(Text(item.title)),
          DataCell(Text(item.location!)),
          DataCell(Text(item.creatorName)),
          DataCell(Text(formatDate(item.date))),
        ],
      );
    }).toList();
  }
}
