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
import 'package:reentry/ui/modules/organizations/cubit/organization_cubit.dart';
import 'package:reentry/ui/modules/organizations/cubit/organization_cubit_state.dart';
import 'package:reentry/ui/modules/organizations/modal/organization_info_dialog.dart';
import 'package:reentry/ui/modules/shared/cubit/admin_cubit.dart';
import 'package:reentry/ui/modules/shared/cubit_state.dart';

import '../../../core/const/app_constants.dart';
import '../profile/bloc/profile_cubit.dart';
import '../profile/bloc/profile_state.dart';

class OrganizationScreenMobile extends StatefulWidget {
  const OrganizationScreenMobile({super.key});

  @override
  _OrganizationScreenMobileState createState() =>
      _OrganizationScreenMobileState();
}

class _OrganizationScreenMobileState extends State<OrganizationScreenMobile> {
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

  @override
  Widget build(BuildContext context) {
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
          child: SingleChildScrollView(
            child: Builder(
              builder: (
                context,
              ) {
                final data = _state.data;
                final mentorList = _state.data;
                return Column(
                  children: [
                    2.height,
                    InputField(
                      hint: 'Search by code',
                      onSubmit: (value) {
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
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      preffixIcon: const Icon(
                        CupertinoIcons.search,
                        color: AppColors.white,
                      ),
                    ),
                    20.height,
                    if (data.isEmpty)
                      Center(
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
                      ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final item = mentorList[index];
                        return ListTile(
                          contentPadding: const EdgeInsets.all(0),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                item.avatar ?? AppConstants.avatar),
                          ),
                          title: Text(
                            item.name.isEmpty
                                ? item.organization ?? ''
                                : item.name,
                            style: const TextStyle(
                                color: AppColors.white, fontSize: 18),
                          ),
                          subtitle: Text(item.email ?? '',
                              style: TextStyle(
                                  color: AppColors.greyWhite.withOpacity(.65))),
                        );
                      },
                      itemCount: mentorList.length,
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              },
            ),
          ),
        ),
      );
    });
  }

  _navigate(UserDto profile) async {
    // UserRepository().updateUser(profile.copyWith(
    //     userCode: DateTime.now().millisecondsSinceEpoch.toString()));
    //1740059281574
    //1740059287419
    //1740059289516
  }
}
