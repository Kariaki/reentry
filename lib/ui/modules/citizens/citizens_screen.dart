// ignore_for_file: library_private_types_in_public_api
import 'package:beamer/beamer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:reentry/core/const/app_constants.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/generated/assets.dart';
import 'package:reentry/ui/components/buttons/primary_button.dart';
import 'package:reentry/ui/components/input/input_field.dart';
import 'package:reentry/ui/components/pagination.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/modules/activities/chart/chart_component.dart';
import 'package:reentry/ui/modules/activities/chart/graph_component.dart';
import 'package:reentry/ui/modules/appointment/component/table.dart';
import 'package:reentry/ui/modules/authentication/bloc/account_cubit.dart';
import 'package:reentry/ui/modules/citizens/component/icon_button.dart';
import 'package:reentry/ui/modules/citizens/component/profile_card.dart';
import 'package:reentry/ui/modules/shared/cubit/admin_cubit.dart';
import 'package:reentry/ui/modules/shared/cubit_state.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routes/routes.dart';
import '../../../data/model/user_dto.dart';
import '../../components/error_component.dart';
import '../profile/bloc/profile_cubit.dart';
import '../profile/bloc/profile_state.dart';

class CitizensScreen extends StatefulWidget {
  const CitizensScreen({super.key});

  @override
  _CitizensScreenState createState() => _CitizensScreenState();
}

class _CitizensScreenState extends State<CitizensScreen>
    with WidgetsBindingObserver {
  final int itemsPerPage = 10;
  int currentPage = 1;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        print("widget state -> App is in the foreground (on resume)");
        break;
      case AppLifecycleState.inactive:
        print("widget state -> App is inactive (e.g., phone call)");
        break;
      case AppLifecycleState.paused:
        print("widget state -> App is in the background (on pause)");
        break;
      case AppLifecycleState.detached:
        print("widget state -> App is detached (e.g., being terminated)");
        break;
      case AppLifecycleState.hidden:
        print('widget state -> widget hidden');
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<UserDto> getPaginatedItems(List<UserDto> citizensList) {
    int startIndex = (currentPage - 1) * itemsPerPage;
    int endIndex = startIndex + itemsPerPage;
    return citizensList.sublist(
      startIndex,
      endIndex > citizensList.length ? citizensList.length : endIndex,
    );
  }

  // void printDobAndCreatedAt(List<dynamic> citizensList) {
  //   for (var citizen in citizensList) {
  //     final dob = citizen.dob;
  //     final createdAt = citizen.createdAt;

  //     print("DOB: $dob, Created At: $createdAt");
  //   }
  // }

  List<UserDto> filterCitizens(List<UserDto> citizensList) {
    if (_searchQuery.isEmpty) {
      return citizensList;
    }
    return citizensList
        .where((citizen) =>
            citizen.name.toLowerCase().contains(_searchQuery) ||
            (citizen.email?.toLowerCase().contains(_searchQuery) ?? false))
        .toList();
  }

  void setPage(int pageNumber) {
    setState(() {
      currentPage = pageNumber;
    });
  }

  String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = 5;
    if (screenWidth < 1200) {
      crossAxisCount = 4;
    }
    if (screenWidth < 900) {
      crossAxisCount = 3;
    }
    if (screenWidth < 600) {
      crossAxisCount = 2;
    }
    final account = context.read<AccountCubit>().state;

    return BlocProvider(
      create: (context) => AdminUserCubitNew()..fetchCitizens(account: account),
      child: BlocBuilder<AdminUserCubitNew, MentorDataState>(
          builder: (_context, _state) {
        final state = _state.state;
        return BlocListener<ProfileCubit, ProfileState>(
          listener: (_, state1) {
            if (state1 is DeleteAccountSuccess) {
              _context
                  .read<AdminUserCubitNew>()
                  .fetchCitizens(account: account);
            }
          },
          child: BaseScaffold(
            isLoading: state is CubitStateLoading,
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
                        style: context.textTheme.bodyLarge?.copyWith(
                          color: AppColors.greyWhite,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      InputField(
                        controller: _searchController,
                        hint: 'Enter name or email to search',
                        radius: 10.0,
                        preffixIcon: const Icon(
                          CupertinoIcons.search,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Builder(builder: (
                  context,
                ) {
                  if (state is CubitStateLoading) {
                    return const SizedBox();
                  }
                  if (state is CubitStateError) {
                    return Center(
                      child: Text(
                        "Error: ${state.message}",
                        style: context.textTheme.bodyLarge?.copyWith(
                          color: AppColors.red,
                        ),
                      ),
                    );
                  }

                  final data = _state.data;
                  // if (data.isEmpty) {
                  //   return Expanded(
                  //       child: ErrorComponent(
                  //     showButton: false,
                  //     title: 'No citizens available',
                  //     description: 'You do not have any citizens assigned to you yet.',
                  //     onActionButtonClick: () {
                  //       // context.read<AppointmentCubit>().fetchAppointments(
                  //       //     userId: accountCubit?.userId ?? '');
                  //     },
                  //   ));
                  // }

                  final citizensList = filterCitizens(data);
                  // printDobAndCreatedAt(citizensList);
                  if (citizensList.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.people_outline,
                            size: 100,
                            color: AppColors.greyWhite,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "No citizens available",
                            style: context.textTheme.bodyLarge?.copyWith(
                              color: AppColors.greyWhite,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Try searching for a term or check back later.",
                            textAlign: TextAlign.center,
                            style: context.textTheme.bodySmall?.copyWith(
                              color: AppColors.gray2,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final totalPages =
                      (citizensList.length / itemsPerPage).ceil();
                  final paginatedItems = getPaginatedItems(citizensList);
                  final columns = [
                    const DataColumn(label: TableHeader("Name")),
                    const DataColumn(label: TableHeader("Email")),
                    const DataColumn(label: TableHeader("DOB")),
                    const DataColumn(label: TableHeader("Date Joined")),
                  ];
                  List<DataRow> buildRows(context) {
                    return paginatedItems.map((item) {
                      return DataRow(
                        onSelectChanged: (isSelected) {
                          // context.read<AdminUserCubitNew>().selectCurrentUser(item);
                          if (isSelected == true) {
                            _navigate(item);
                          }
                        },
                        cells: [
                          DataCell(Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      item.avatar ?? AppConstants.avatar),
                                ),
                              ),
                              10.width,
                              Text(item.name)
                            ],
                          )),
                          DataCell(Text(item.email ?? '')),
                          DataCell(Text(
                              DateTime.tryParse(item.dob ?? '')?.formatDate() ??
                                  '')),
                          DataCell(Text(item.createdAt?.formatDate() ?? '')),
                        ],
                      );
                    }).toList();
                  }

                  final rows = buildRows(context);

                  return Column(
                    children: [
                      Container(
                        color: Colors.black,
                        child: ReusableTable(
                          columns: columns,
                          rows: rows,
                          headingRowColor: AppColors.white,
                          dataRowColor: AppColors.greyDark,
                          columnSpacing: 20.0,
                          dataRowHeight: 56.0,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Pagination(
                        totalPages: totalPages,
                        currentPage: currentPage,
                        onPageSelected: setPage,
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        );
      }),
    );
  }

  _navigate(UserDto profile) async {
    context.read<AdminUserCubitNew>().selectCurrentUser(profile);
    context.goNamed(AppRoutes.citizenProfile.name,
        queryParameters: {'id': profile.userId});
  }

// class ProfileCard extends StatelessWidget {
//   const ProfileCard({super.key, required});

//   @override
//   Widget build(BuildContext context) {
//     final columns = [
//       const DataColumn(label: TableHeader("Name")),
//       const DataColumn(label: TableHeader("Email")),
//       const DataColumn(label: TableHeader("DOB")),
//       const DataColumn(label: TableHeader("Date Joined")),
//     ];

//     final rows = _buildRows(context);

//     return Container(
//       color: Colors.black,
//       child: ReusableTable(
//         columns: columns,
//         rows: rows,
//         headingRowColor: AppColors.white,
//         dataRowColor: AppColors.greyDark,
//         columnSpacing: 20.0,
//         dataRowHeight: 56.0,
//       ),
//     );
//   }

//   String formatDate(DateTime date) {
//     return DateFormat('dd MMM yyyy').format(date);
//   }

//   List<DataRow> _buildRows(context) {
//     return map((item) {
//       return DataRow(
//         onSelectChanged: (isSelected) {

//         },
//         cells: [
//           DataCell(Text(item.name)),
//           DataCell(Text(item.email!)),
//          DataCell(Text(formatDate(item.dob))),
//           DataCell(Text(formatDate(item.date))),
//         ],
//       );
//     }).toList();
//   }
// }

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
              child: Column(
                children: [
                  Row(
                    children: [
                      const SizedBox(
                        width: 168,
                        height: 200,
                        child: ProfileCard(
                          name: "client.name",
                          email: "client.email",
                          imageUrl: Assets.imagesCitiImg,
                          showActions: false,
                        ),
                      ),
                      20.width,
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Unmatch citizen?",
                            style: context.textTheme.bodyLarge?.copyWith(
                              color: AppColors.greyWhite,
                              fontWeight: FontWeight.w600,
                              fontSize: 30,
                            ),
                          ),
                          1.height,
                          Text(
                            "This action cannot be undone",
                            style: context.textTheme.bodyLarge?.copyWith(
                              color: AppColors.hintColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          10.height,
                          const Divider(
                            color: AppColors.white,
                            thickness: 1,
                            height: 30,
                          ),
                        ],
                      )
                    ],
                  ),
                  20.height,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Enter reason for unmatching",
                        style: context.textTheme.bodyLarge?.copyWith(
                          color: AppColors.greyWhite,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      10.height,
                      const InputField(
                        hint: "Enter your message",
                        radius: 5.0,
                        maxLines: 10,
                        lines: 6,
                        suffixIcon: Icon(Icons.calendar_today_outlined),
                      ),
                      20.height,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          CustomIconButton(
                              backgroundColor: AppColors.white,
                              textColor: AppColors.black,
                              label: "Unmatch",
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
                ],
              ),
            );
          },
        );
      },
    );
  }
}
