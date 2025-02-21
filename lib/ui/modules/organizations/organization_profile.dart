import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';

import '../../../core/theme/colors.dart';
import '../../../data/enum/account_type.dart';
import '../../../data/model/user_dto.dart';
import '../../../generated/assets.dart';
import '../../dialog/alert_dialog.dart';
import '../authentication/bloc/account_cubit.dart';
import '../citizens/component/icon_button.dart';
import '../citizens/component/profile_card.dart';
import '../profile/bloc/profile_cubit.dart';
import '../shared/cubit/admin_cubit.dart';

class OrganizationProfile extends StatelessWidget {
  const OrganizationProfile({super.key});



  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      child: _buildDefaultView(),
    );
  }

  Widget _buildDefaultView() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      children: [
        _buildProfileCard([], appointmentCount: 0, 0),
        ...[
          const SizedBox(height: 40),
          const Text(
            'Care team',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: AppColors.greyWhite,
            ),
          ),
          20.height,
        ],
        50.height,
      ],
    );
  }

  Widget _buildProfileCard(List<UserDto> preselected, int? careTeam,
      {int? appointmentCount}) {
    return BlocBuilder<AdminUserCubitNew, MentorDataState>(
        builder: (context, adminUserState) {
      final account = context.read<AccountCubit>().state;
      UserDto? client = adminUserState.currentData;
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
                                "Citizen",
                                style: context.textTheme.bodyLarge?.copyWith(
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
                                            "Are you sure you want to delete this user account?",
                                        title: "Delete Account?",
                                        action: "Delete", onClickAction: () {
                                      // context
                                      //     .read<CitizenProfileCubit>()
                                      //     .deleteAccount(
                                      //     client.userId ?? '', 'Admin deletion');
                                      context
                                          .read<ProfileCubit>()
                                          .deleteAccount(client?.userId ?? '',
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
                                  onPressed: () async {},
                                ),
                              ],
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            "Active since ",
                            style: context.textTheme.bodySmall?.copyWith(
                              color: AppColors.green,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 60),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Appointments: ",
                            style: context.textTheme.bodySmall?.copyWith(
                              color: AppColors.greyWhite,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          // if (appointmentCount == null)
                          //   const SizedBox(
                          //     height: 16,
                          //     width: 16,
                          //     child: CircularProgressIndicator(
                          //       strokeWidth: 2,
                          //       color: AppColors.primary,
                          //     ),
                          //   )
                          // else
                          Text(
                            appointmentCount.toString(),
                            style: context.textTheme.bodySmall?.copyWith(
                              color: AppColors.greyWhite,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(width: 30),
                          Text(
                            "Care team: ",
                            style: context.textTheme.bodySmall?.copyWith(
                              color: AppColors.greyWhite,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            careTeam.toString(),
                            style: context.textTheme.bodySmall?.copyWith(
                              color: AppColors.greyWhite,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      15.height,
                      Divider(
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
  }

  //
  // _navigate(UserDto profile) async {
  //   context.read<AdminUserCubitNew>().selectCurrentUser(profile);
  //   context.goNamed(AppRoutes.verifyCitizen.name,
  //       queryParameters: {'id': profile.userId});
  // }

  Widget _buildError(String errorMessage) {
    return Center(
      child: Text(
        errorMessage,
        style: const TextStyle(
          color: AppColors.red,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
