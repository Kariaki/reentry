import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/ui/components/pill_selector_component.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/modules/organizations/cubit/organization_cubit.dart';
import 'package:reentry/ui/modules/organizations/cubit/organization_cubit_state.dart';
import 'package:reentry/ui/modules/organizations/modal/organization_members_dialog.dart';
import 'package:reentry/ui/modules/shared/cubit_state.dart';

import '../../../core/theme/colors.dart';
import '../../../data/enum/account_type.dart';
import '../../../data/model/user_dto.dart';
import '../../../generated/assets.dart';
import '../../dialog/alert_dialog.dart';
import '../authentication/bloc/account_cubit.dart';
import '../citizens/component/icon_button.dart';
import '../citizens/component/profile_card.dart';
import '../profile/bloc/profile_cubit.dart';
import '../profile/bloc/profile_state.dart';
import '../shared/cubit/admin_cubit.dart';

class OrganizationProfile extends StatefulWidget {
  const OrganizationProfile({super.key});

  @override
  State<OrganizationProfile> createState() => _OrganizationProfileState();
}

class _OrganizationProfileState extends State<OrganizationProfile> {
  @override
  void initState() {
    final org = context.read<OrganizationCubit>().state.selectedOrganization;
    if (org != null) {
      context
          .read<OrganizationMembersCubit>()
          .fetchUsersByOrganization(org.userId ?? '');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final account = context.read<AccountCubit>().state;
    return BlocConsumer<ProfileCubit, ProfileState>(builder: (context, state) {
      return BlocBuilder<OrganizationMembersCubit,
          OrganizationMembersCubitState>(builder: (context, memberState) {
        return BaseScaffold(
          isLoading:
              state is ProfileLoading || memberState.state is CubitStateLoading,
          child: _buildDefaultView(memberState.data),
        );
      });
    }, listener: (_, state) {
      if (state is ProfileError) {
        context.showSnackbarError(state.message);
      }
      if (state is DeleteAccountSuccess) {
        context.showSnackbarSuccess('Organization deleted');
        context
            .read<OrganizationCubit>()
            .fetchOrganizations(currentUser: account);
        context.pop();
      }
    });
  }

  Widget _buildDefaultView(List<UserDto> members) {
    final careTeam =
        members.where((e) => e.accountType != AccountType.citizen).toList();
    final citizens =
        members.where((e) => e.accountType == AccountType.citizen).toList();
    final org = context.read<OrganizationCubit>().state.selectedOrganization;
    return Scrollbar(child: ListView(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      children: [
        _buildProfileCard([], appointmentCount: 0, 0),
        ...[
          const SizedBox(height: 40),
          const Text(
            'Services',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: AppColors.greyWhite,
            ),
          ),
          PillSelector(options: org?.services ?? [], onChange: (value) {},wrap: true,selectable: false,),
          20.height,
          if (careTeam.isNotEmpty) ...[
            const Text(
              'Care team',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: AppColors.greyWhite,
              ),
            ),
            20.height,
            _showMembers(careTeam),
            20.height,
          ],
          if (citizens.isNotEmpty) ...[
            const Text(
              'Citizens',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: AppColors.greyWhite,
              ),
            ),
            20.height,
            _showMembers(citizens),
          ]
        ],
        50.height,
      ],
    ));
  }

  Widget _showMembers(List<UserDto> careTeam) {
    return BlocBuilder<OrganizationCubit, OrganizationCubitState>(
        builder: (context, state) {
      UserDto? client = state.selectedOrganization;
      return Wrap(
        direction: Axis.horizontal,
        children: [
          ...careTeam.map((user) => Container(
                width: 200,
                height: 275,
                margin: const EdgeInsets.only(right: 20, bottom: 10),
                child: ProfileCard(
                  name: user.name,
                  showActions: true,
                  isOrg: true,
                  actionText1: 'Remove',
                  onViewProfile: () {

                    AppAlertDialog.show(context,
                        description:
                        "Are you sure you want to remove ${user.name} from this organization?",
                        title: "Remove from Organization?",
                        action: "Delete", onClickAction: () {
                          context
                              .read<OrganizationMembersCubit>()
                              .deleteAmount(user, client?.userId ?? '');
                        });
                  },
                  onUnmatch: () {

                    context.read<AdminUserCubitNew>().selectCurrentUser(user);
                  },
                  email: user.accountType.name.capitalizeFirst(),
                ),
              ))
        ],
      );
    });
  }

  Widget _buildProfileCard(List<UserDto> preselected, int? careTeam,
      {int? appointmentCount}) {
    return BlocBuilder<OrganizationMembersCubit, OrganizationMembersCubitState>(
      builder: (context, state) {
        final careTeam = state.data
            .where((e) => e.accountType != AccountType.citizen)
            .length;
        final citizens = state.data
            .where((e) => e.accountType == AccountType.citizen)
            .length;

        return BlocBuilder<OrganizationCubit, OrganizationCubitState>(
            builder: (context, adminUserState) {
          final account = context.read<AccountCubit>().state;
          UserDto? client = adminUserState.selectedOrganization;
          return Container(
            constraints: const BoxConstraints(
              maxHeight: 250,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 168,
                  child: ProfileCard(
                    name: client?.name,
                    email: client?.email,
                    idNumber: client?.userCode ?? '',
                    imageUrl: client?.avatar,
                    showActions: false,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 53),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Organization",
                                    style:
                                        context.textTheme.bodyLarge?.copyWith(
                                      color: AppColors.greyWhite,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 36,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                ],
                              ),
                              if (account?.accountType == AccountType.admin)
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CustomIconButton(
                                      icon: Assets.webDelete,
                                      label: "Delete",
                                      onPressed: () {
                                        AppAlertDialog.show(context,
                                            description:
                                                "Are you sure you want to delete this organization?",
                                            title: "Delete Organization?",
                                            action: "Delete",
                                            onClickAction: () {
                                          context
                                              .read<ProfileCubit>()
                                              .deleteAccount(
                                                  client?.userId ?? '',
                                                  'Admin deletion');
                                        });
                                      },
                                      backgroundColor: AppColors.greyDark,
                                      textColor: AppColors.white,
                                    ),
                                    const SizedBox(width: 10),
                                    CustomIconButton(
                                      icon: Assets.webMatch,
                                      label: "Add to org",
                                      backgroundColor: AppColors.primary,
                                      textColor: AppColors.white,
                                      onPressed: () async {
                                        final members = state.data
                                            .map((e) => e.userId ?? '')
                                            .toList();
                                        context.displayDialog(
                                            AddOrganizationMembersDialog(
                                          onResult: (value) {
                                            context
                                                .read<
                                                    OrganizationMembersCubit>()
                                                .addToOrg(value,
                                                    client?.userId ?? '');
                                          },
                                          ignore: members,
                                        ));
                                      },
                                    ),
                                  ],
                                ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          RichText(
                              text: TextSpan(
                                  text: 'Active since:\t',
                                  style: context.textTheme.bodySmall?.copyWith(
                                    color: AppColors.green,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  children: [
                                TextSpan(
                                  text: client?.createdAt
                                          ?.toIso8601String()
                                          .split('T')
                                          .firstOrNull ??
                                      '',
                                  style: context.textTheme.bodySmall?.copyWith(
                                    color: AppColors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                              ])),
                          50.height,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Total users: ${careTeam + citizens}",
                                style: context.textTheme.bodySmall?.copyWith(
                                  color: AppColors.greyWhite,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(width: 30),
                              Text(
                                "Care team: $careTeam",
                                style: context.textTheme.bodySmall?.copyWith(
                                  color: AppColors.greyWhite,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              30.width,
                              Text(
                                "Citizens: $citizens",
                                style: context.textTheme.bodySmall?.copyWith(
                                  color: AppColors.greyWhite,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          15.height,
                          const Divider(
                            color: AppColors.white,
                            height: .5,
                            thickness: 1,
                          )
                        ],
                      ),
                    ),
                  ],
                ))
              ],
            ),
          );
        });
      },
    );
  }
}
