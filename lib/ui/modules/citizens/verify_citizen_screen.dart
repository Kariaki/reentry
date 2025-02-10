import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/data/enum/account_type.dart';
import 'package:reentry/data/model/user_dto.dart';
import 'package:reentry/generated/assets.dart';
import 'package:reentry/ui/components/error_component.dart';
import 'package:reentry/ui/components/loading_component.dart';
import 'package:reentry/ui/modules/authentication/bloc/account_cubit.dart';
import 'package:reentry/ui/modules/citizens/bloc/citizen_profile_cubit.dart';
import 'package:reentry/ui/modules/citizens/bloc/citizen_profile_state.dart';
import 'package:reentry/ui/modules/citizens/component/icon_button.dart';
import 'package:reentry/ui/modules/citizens/component/profile_card.dart';
import 'package:reentry/ui/modules/citizens/component/reusable_edit_modal.dart';
import 'package:reentry/ui/modules/citizens/dialog/care_team_selection_dialog.dart';
import 'package:reentry/ui/modules/citizens/verify_form.dart';
import 'package:reentry/ui/modules/profile/bloc/profile_cubit.dart';
import 'package:reentry/ui/modules/shared/cubit/admin_cubit.dart';
import 'package:reentry/ui/modules/shared/cubit_state.dart';
import '../../dialog/alert_dialog.dart';
import '../profile/bloc/profile_state.dart';

class VerifyCitizenScreen extends StatefulWidget {
  const VerifyCitizenScreen({
    super.key,
  });

  @override
  State<VerifyCitizenScreen> createState() => _VerifyCitizenScreenState();
}

class _VerifyCitizenScreenState extends State<VerifyCitizenScreen> {
  bool showMatchView = false;
  List<UserDto> selectedUsers = [];

  @override
  void initState() {
    super.initState();
    final currentUser = context.read<AdminUserCubitNew>().state.currentData;
    if (currentUser != null) {
      context.read<CitizenProfileCubit>().fetchCitizenProfileInfo(currentUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyDark,
      body: BlocBuilder<AdminUserCubitNew, MentorDataState>(
          builder: (context, state) {
        if (state.currentData == null) {
        } else {}
        return _buildDefaultView();
      }),
    );
  }

  Widget _buildDefaultView() {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (_, state) {
        if (state is DeleteAccountSuccess) {
          context.showSnackbarSuccess('Account deleted');
          context.pop();
        }
        if (state is ProfileError) {
          context.showSnackbarError(state.message);
        }
      },
      builder: (context, profileState) {
        final currentUser = context.read<AdminUserCubitNew>().state.currentData;
        final loggedInUser = context.read<AccountCubit>().state;
        if (currentUser == null) {
          return const ErrorComponent(
            title: 'User not found',
          );
        }
        return BlocBuilder<CitizenProfileCubit, CitizenProfileCubitState>(
          builder: (context, _state) {
            final state = _state.state;
            if (state is CubitStateLoading || profileState is ProfileLoading) {
              return const LoadingComponent();
            }
            if (state is CubitStateError) {
              return _buildError(state.message);
            }
            final data = _state.user;
            if (data == null) {
              return const SizedBox();
            }
            final careTeam = _state.careTeam.length;
            final mentors = _state.careTeam
                .where((user) => user.accountType == AccountType.mentor)
                .toList();
            final officers = _state.careTeam
                .where((user) => user.accountType == AccountType.officer)
                .toList();

            return SafeArea(
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileCard(
                      data,
                      [...mentors, ...officers],
                      appointmentCount: _state.appointmentCount ?? 0,
                      careTeam,
                    ),
                    if (loggedInUser?.accountType != AccountType.mentor &&
                        loggedInUser?.accountType != AccountType.officer) ...[
                      40.height,
                      // const SizedBox(
                      //   height: 700,
                      //   child: MultiStepForm(),
                      // ),
                      // MultiStepForm(),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildProfileCard(
      UserDto client, List<UserDto> preselected, int? careTeam,
      {int? appointmentCount}) {
    final account = context.read<AccountCubit>().state;
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
              name: client.name,
              email: client.email,
              imageUrl: client.avatar,
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
                            Text(
                              "Unverified",
                              style: context.textTheme.bodySmall?.copyWith(
                                color: AppColors.red,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.red,
                              ),
                            ),
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
                                    context.read<ProfileCubit>().deleteAccount(
                                        client.userId ?? '', 'Admin deletion');
                                  });
                                },
                                backgroundColor: AppColors.greyDark,
                                textColor: AppColors.white,
                              ),
                              const SizedBox(width: 10),
                              CustomIconButton(
                                icon: Assets.webEdit,
                                label: "Edit",
                                backgroundColor: AppColors.white,
                                textColor: AppColors.black,
                                onPressed: () {
                                  context.displayDialog(ReusableEditModal(
                                    name: client.name,
                                    phone: client.phoneNumber ?? '',
                                    address: client.address ?? '',
                                    dob: client.dob ??
                                        DateTime.now().toIso8601String(),
                                    onSave: (String updatedName,
                                        String updatedDateOfBirth,
                                        String phone,
                                        String address) {
                                      client = client.copyWith(
                                        name: updatedName,
                                        phoneNumber: phone,
                                        address: address,
                                        dob: updatedDateOfBirth,
                                      );
                                      context
                                          .read<CitizenProfileCubit>()
                                          .updateProfile(
                                            client,
                                          );
                                    },
                                    onCancel: () {
                                      context.popBack();
                                    },
                                  ));
                                },
                              ),
                              const SizedBox(width: 10),
                              CustomIconButton(
                                icon: Assets.webMatch,
                                label: "Match",
                                backgroundColor: AppColors.primary,
                                textColor: AppColors.white,
                                onPressed: () async {
                                  context.displayDialog(CareTeamSelectionDialog(
                                      preselected: preselected,
                                      onResult: (result) {}));
                                },
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
  }

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
