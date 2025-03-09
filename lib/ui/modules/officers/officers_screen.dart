import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/routes/routes.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/data/enum/account_type.dart';
import 'package:reentry/data/model/user_dto.dart';
import 'package:reentry/ui/components/input/input_field.dart';
import 'package:reentry/ui/components/pagination.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/modules/appointment/component/table.dart';
import 'package:reentry/ui/modules/careTeam/bloc/care_team_profile_cubit.dart';
import 'package:reentry/ui/modules/citizens/bloc/citizen_profile_cubit.dart';
import 'package:reentry/ui/modules/citizens/bloc/citizen_profile_state.dart';
import 'package:reentry/ui/modules/shared/cubit/admin_cubit.dart';
import 'package:reentry/ui/modules/shared/cubit_state.dart';

import '../../../core/const/app_constants.dart';
import '../profile/bloc/profile_cubit.dart';
import '../profile/bloc/profile_state.dart';

class CareTeamScreen extends StatefulWidget {
  final AccountType accountType;

  const CareTeamScreen({super.key, required this.accountType});

  @override
  _CareTeamScreenState createState() => _CareTeamScreenState();
}

class _CareTeamScreenState extends State<CareTeamScreen> {
  final int itemsPerPage = 10;
  int currentPage = 1;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<UserDto> getPaginatedItems(List<UserDto> mentorList) {
    int startIndex = (currentPage - 1) * itemsPerPage;
    int endIndex = startIndex + itemsPerPage;
    return mentorList.sublist(
      startIndex,
      endIndex > mentorList.length ? mentorList.length : endIndex,
    );
  }

  List<UserDto> filterMentors(List<UserDto> mentorList) {
    if (_searchQuery.isEmpty) {
      return mentorList;
    }

    return mentorList
        .where((mentor) =>
            mentor.name.toLowerCase().contains(_searchQuery) ||
            mentor.email!.toLowerCase().contains(_searchQuery))
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

    return BlocProvider(
      create: (context) =>
          AdminUserCubitNew()..fetchUserCareTeam1(widget.accountType),
      child: BlocBuilder<AdminUserCubitNew, MentorDataState>(
          builder: (_context, _state) {
        final state = _state.state;
        return BlocListener<CitizenProfileCubit, CitizenProfileCubitState>(
          listener: (_, state) {
            if (state.state is AdminDeleteUserSuccess ||
                state is UpdateCitizenProfileSuccess
    || state.state is RemovedCareTeamFromOrganizationSuccess) {
              _context
                  .read<AdminUserCubitNew>()
                  .fetchUserCareTeam1(widget.accountType);
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
                        hint: 'Enter name or email to search',
                        radius: 10.0,
                        onChange: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
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
            child: Scrollbar(
              thumbVisibility: true,
                child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Builder(
                  builder: (
                      context,
                      ) {
                    if (state is CubitStateLoading) {
                      return SizedBox();
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
                    if (data.isEmpty) {
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
                              "No mentors available",
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
                    final mentorList = filterMentors(data);
                    final totalPages =
                    (mentorList.length / itemsPerPage).ceil();

                    final paginatedItems = getPaginatedItems(mentorList);
                    final columns = [
                      const DataColumn(label: TableHeader("Name")),
                      const DataColumn(label: TableHeader("Email")),
                      const DataColumn(label: TableHeader("Role")),
                      const DataColumn(label: TableHeader("DOB")),
                      const DataColumn(label: TableHeader("Date Joined")),
                    ];
                    List<DataRow> _buildRows(context) {
                      return paginatedItems.map((item) {
                        return DataRow(
                          onSelectChanged: (isSelected) {
                            _navigate(item);
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
                            DataCell(Text(item.accountType.name
                                .toString()
                                .replaceAll('_', ' ')
                                .capitalizeFirst() ??
                                '')),
                            DataCell(Text(DateTime.tryParse(item.dob ?? '')
                                ?.formatDate() ??
                                '')),
                            DataCell(
                                Text(item.createdAt?.toIso8601String() ?? '')),
                          ],
                        );
                      }).toList();
                    }

                    final rows = _buildRows(context);

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
                  },
                ),
              ),
            )),
          ),
        );
      }),
    );
  }

  _navigate(UserDto profile) async {
    context.read<CareTeamProfileCubit>()..selectCurrentUser(profile)
    ..init();
    await Future.delayed(Duration(seconds: 1));
    context.goNamed(
        widget.accountType == AccountType.mentor
            ? AppRoutes.mentorProfile.name
            : AppRoutes.officersProfile.name,
        extra: profile.userId,
        queryParameters: {'id': profile.userId});
  }
}
