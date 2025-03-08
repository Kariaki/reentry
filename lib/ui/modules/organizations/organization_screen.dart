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
import 'package:reentry/data/repository/user/user_repository.dart';
import 'package:reentry/ui/components/input/input_field.dart';
import 'package:reentry/ui/components/pagination.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/modules/appointment/component/table.dart';
import 'package:reentry/ui/modules/authentication/bloc/account_cubit.dart';
import 'package:reentry/ui/modules/authentication/bloc/account_cubit.dart';
import 'package:reentry/ui/modules/organizations/cubit/organization_cubit.dart';
import 'package:reentry/ui/modules/organizations/cubit/organization_cubit_state.dart';
import 'package:reentry/ui/modules/organizations/modal/organization_info_dialog.dart';
import 'package:reentry/ui/modules/shared/cubit/admin_cubit.dart';
import 'package:reentry/ui/modules/shared/cubit_state.dart';

import '../../../core/const/app_constants.dart';
import '../profile/bloc/profile_cubit.dart';
import '../profile/bloc/profile_state.dart';

class OrganizationScreen extends StatefulWidget {
  const OrganizationScreen({super.key});

  @override
  _OrganizationScreenState createState() => _OrganizationScreenState();
}

class _OrganizationScreenState extends State<OrganizationScreen> {
  final int itemsPerPage = 10;
  int currentPage = 1;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    context.read<OrganizationCubit>().fetchOrganizations();
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
    return BlocBuilder<AccountCubit, UserDto?>(
      builder: (context, accountState) {
        return BlocConsumer<OrganizationCubit, OrganizationCubitState>(
            listener: (_context, state) {
          final cubitState = state.state;
          if (cubitState is CubitStateError) {
            context.showSnackbarError(cubitState.message);
            return;
          }
          if (state.state is CubitStateSuccess) {
            if (state.foundOrganization != null) {
              context.displayDialog(OrganizationInfoDialog(
                data: state.foundOrganization!,
                callback: () {},
              ));
            }
          }
        }, builder: (_context, _state) {
          final state = _state.state;
          return BlocListener<ProfileCubit, ProfileState>(
            listener: (_, state) {
              _context.read<OrganizationCubit>().fetchOrganizations();
            },
            child: BaseScaffold(
              isLoading: _state.state is CubitStateLoading,
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
                          hint: accountState?.accountType == AccountType.admin
                              ? "Search by code or name"
                              : 'Search by code',
                          onSubmit: (value) {
                            if (accountState?.accountType ==
                                AccountType.admin) {
                              return;
                            }
                            if (value == null) {
                              return;
                            }
                            print(value);
                            _context
                                .read<OrganizationCubit>()
                                .findOrganizationByCode(value);
                          },
                          radius: 10.0,
                          onChange: (value) {
                            context
                                .read<OrganizationCubit>()
                                .search(value.toLowerCase());
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
              child:Scrollbar(
                thumbVisibility: true,
                  trackVisibility: true,
                  child:  SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Builder(
                    builder: (
                        context,
                        ) {
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
                                "No organizations.",
                                style: context.textTheme.bodyLarge?.copyWith(
                                  color: AppColors.greyWhite,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "You have not joined any organization yet.",
                                textAlign: TextAlign.center,
                                style: context.textTheme.bodySmall?.copyWith(
                                  color: AppColors.gray2,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      final mentorList = _state.data;
                      final columns = [
                        const DataColumn(
                            label: TableHeader("Name or organization")),
                        const DataColumn(label: TableHeader("Team leader")),
                        const DataColumn(label: TableHeader("Email address")),
                      ];
                      List<DataRow> _buildRows(context) {
                        return mentorList.map((item) {
                          return DataRow(
                            onSelectChanged: (isSelected) {
                              _context
                                  .read<OrganizationCubit>()
                                  .selectOrganization(item);
                              _context.goNamed(AppRoutes.organizationProfile.name);
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
                                  Text(item.organization ?? "")
                                ],
                              )),
                              DataCell(Text(item.supervisorsName ?? "")),
                              DataCell(Text(item.email ?? "")),
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
                        ],
                      );
                    },
                  ),
                ),
              )),
            ),
          );
        });
      },
    );
  }
}
