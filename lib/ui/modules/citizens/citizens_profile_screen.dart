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
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/modules/activities/bloc/activity_cubit.dart';
import 'package:reentry/ui/modules/activities/web/web_activity_screen.dart';
import 'package:reentry/ui/modules/appointment/appointment_graph/appointment_graph_component.dart';
import 'package:reentry/ui/modules/appointment/web/appointment_screen.dart';
import 'package:reentry/ui/modules/authentication/bloc/account_cubit.dart';
import 'package:reentry/ui/modules/careTeam/bloc/care_team_profile_cubit.dart';
import 'package:reentry/ui/modules/careTeam/web/care_team_profile_dialog.dart';
import 'package:reentry/ui/modules/citizens/bloc/citizen_profile_cubit.dart';
import 'package:reentry/ui/modules/citizens/bloc/citizen_profile_state.dart';
import 'package:reentry/ui/modules/citizens/component/icon_button.dart';
import 'package:reentry/ui/modules/citizens/component/profile_card.dart';
import 'package:reentry/ui/modules/citizens/component/reusable_edit_modal.dart';
import 'package:reentry/ui/modules/citizens/dialog/care_team_selection_dialog.dart';
import 'package:reentry/ui/modules/citizens/verify_form.dart';
import 'package:reentry/ui/modules/goals/bloc/goals_cubit.dart';
import 'package:reentry/ui/modules/goals/web/web_goals_screen.dart';
import 'package:reentry/ui/modules/profile/bloc/profile_cubit.dart';
import 'package:reentry/ui/modules/root/component/activity_progress_component.dart';
import 'package:reentry/ui/modules/shared/cubit/admin_cubit.dart';
import 'package:reentry/ui/modules/shared/cubit_state.dart';
import 'package:reentry/ui/modules/verification/bloc/submit_verification_question_cubit.dart';
import 'package:reentry/ui/modules/verification/dialog/verification_form_review_dialog.dart';

import '../../../core/routes/routes.dart';
import '../../dialog/alert_dialog.dart';
import '../profile/bloc/profile_state.dart';

class CitizenProfileScreen extends StatefulWidget {
  const CitizenProfileScreen({
    super.key,
  });

  @override
  State<CitizenProfileScreen> createState() => _CitizenProfileScreenState();
}

class _CitizenProfileScreenState extends State<CitizenProfileScreen> {
  bool showMatchView = false;
  List<UserDto> selectedUsers = [];

  @override
  void initState() {
    super.initState();
  }

  // void toggleSelection(UserDto user) {
  //   setState(() {
  //     if (selectedUsers.contains(user)) {
  //       selectedUsers.remove(user);
  //     } else {
  //       selectedUsers.add(user);
  //     }
  //   });
  // }

  void toggleSelection(UserDto user) {
    final userType = user.accountType;
    setState(() {
      if (userType == AccountType.mentor) {
        final selectedMentors =
            selectedUsers.where((u) => u.accountType == AccountType.mentor);
        if (selectedMentors.isNotEmpty && !selectedUsers.contains(user)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("You can only select one mentor."),
              backgroundColor: AppColors.red,
            ),
          );
          return;
        }
      }

      if (userType == AccountType.officer) {
        final selectedOfficers =
            selectedUsers.where((u) => u.accountType == AccountType.officer);
        if (selectedOfficers.isNotEmpty && !selectedUsers.contains(user)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("You can only select one officer."),
              backgroundColor: AppColors.red,
            ),
          );
          return;
        }
      }
      if (selectedUsers.contains(user)) {
        selectedUsers.remove(user);
      } else {
        selectedUsers.add(user);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CitizenProfileCubit, CitizenProfileCubitState>(
        builder: (context, state) {
      if (state.user == null) {
        return const ErrorComponent(
          title: 'No user found',
        );
      }
      return BaseScaffold(
        isLoading: state.state is CubitStateLoading,
          child: _buildDefaultView(state.user!));
    });
  }

  Widget _buildDefaultView(UserDto user) {
    return BlocConsumer<CitizenProfileCubit, CitizenProfileCubitState>(
        listener: (_, cubitState) {
      final state = cubitState.state;
      if (state is AdminDeleteUserSuccess) {
        context.showSnackbarSuccess('Account deleted');
        context.pop();
      }
      if (state is UpdateCitizenProfileSuccess) {
        context.showSnackbarSuccess('Account updated');
      }

      if (state is CubitStateError) {
        context.showSnackbarError(state.message);
      }
    }, builder: (context, _state) {
      final currentUser = _state.user!;
      final loggedInUser = context.read<AccountCubit>().state;

      final state = _state.state;

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

      return Scrollbar(child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          shrinkWrap: true,
          children: [
            _buildProfileCard(
                [...mentors, ...officers],
                appointmentCount: _state.appointments.length,
                careTeam),
            if (loggedInUser?.accountType != AccountType.mentor &&
                loggedInUser?.accountType != AccountType.officer) ...[
              const SizedBox(height: 40),
              if(_state.careTeam.isNotEmpty)
                ...[ const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Care team',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: AppColors.greyWhite,
                    ),
                  ),
                ),
                  20.height,
                  Wrap(
                    direction: Axis.horizontal,
                    children: [
                      ..._state.careTeam.map((user) => Container(
                        width: 200,
                        height: 275,
                        margin: const EdgeInsets.only(right: 20),
                        child: ProfileCard(
                          name: user.name,
                          showActions: true,
                          idNumber: user.userCode,
                          onViewProfile: () async {
                            context.read<CareTeamProfileCubit>()
                              ..selectCurrentUser(user)
                              ..init();
                            await Future.delayed(const Duration(seconds: 1));
                            context.displayDialog(const CareTeamProfileDialog());
                          },
                          onUnmatch: () {
                            AppAlertDialog.show(context,
                                description:
                                "Are you sure you want to unmatch this ${user.accountType.name}?",
                                title: "Unmatch from citizen?",
                                action: "Continue", onClickAction: () {
                                  final currentUser = context
                                      .read<AdminUserCubitNew>()
                                      .state
                                      .currentData;
                                  if (currentUser != null) {
                                    final result = _state.careTeam
                                        .where((e) => e.userId != user.userId)
                                        .map((e) => e.userId ?? '')
                                        .toList();
                                    List<String> orgs = [];
                                    for (var i in _state.careTeam) {
                                      for (var j in i.organizations) {
                                        if (orgs.contains(j)) {
                                          return;
                                        }
                                        orgs.add(j);
                                      }
                                    }
                                    context
                                        .read<CitizenProfileCubit>()
                                        .updateAndRefreshCareTeam(result, orgs);
                                  }
                                });
                          },
                          email: user.accountType.name.capitalizeFirst(),
                        ),
                      ))
                    ],
                  )],
            ],
            50.height,
            Wrap(
              direction: Axis.horizontal,
              children: [
                FutureBuilder(
                    future: goalStats(currentUser.userId ?? ''),
                    builder: (context, _value) {
                      final value = _value.data;
                      if (value == null) {
                        return SizedBox();
                      }
                      var percent = ((value.completed) * 100) /
                          (value.total == 0 ? 1 : value.total);
                      return ActivityProgressComponent(
                          title: 'Goal progress',
                          analyticTitle: 'Goals',
                          name: 'Goals',
                          isGoals: false,
                          centerText: 'Goals completed',
                          centerTextValue: '${percent.toInt()}%',
                          value: percent.toInt());
                    }),
                10.width,
                FutureBuilder(
                    future: activityState(currentUser.userId ?? ''),
                    builder: (context, _value) {
                      final value = _value.data;
                      if (value == null) {
                        return SizedBox();
                      }
                      var percent = ((value.completed ?? 0) * 100) /
                          (value.total == 0 ? 1 : value.total);
                      return ActivityProgressComponent(
                          title: 'Activity progress',
                          analyticTitle: 'Activity log',
                          name: 'Activity',
                          isGoals: false,
                          centerText: 'Completion',
                          centerTextValue: '${percent.toInt()}%',
                          value: percent.toInt());
                    }),
                10.width,
                feelingsChart(context, data: user.feelingTimeLine)

                // 10.width,
                // feelingsChart(context)
              ],
            ),
            50.height,
            AppointmentGraphComponent(
              userId: currentUser.userId ?? '',
            )
          ]
      ));
    });
  }

  Widget _buildProfileCard(List<UserDto> preselected, int? careTeam,
      {int? appointmentCount}) {
    final account = context.read<AccountCubit>().state;
    return BlocBuilder<CitizenProfileCubit, CitizenProfileCubitState>(
        builder: (context, user) {
      UserDto? client = user.user;
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
                              GestureDetector(
                                onTap: () async {
                                  print('kebilate1 ${client?.verificationStatus}');
                                  final form = client?.verification?.form??{};
                                  context.read<SubmitVerificationQuestionCubit>().seResponse(form);
                                  if(client?.verificationStatus ==VerificationStatus.verified.name){
                                    context.displayDialog(VerificationFormReviewDialog(form: form,user: client,));
                                  }
                                },
                                child: Text(
                                  client?.verificationStatus == VerificationStatus.verified.name
                                      ? 'Verified'
                                      : "Unverified",
                                  style: context.textTheme.bodySmall?.copyWith(
                                    color:  client?.verificationStatus == VerificationStatus.verified.name
                                        ? AppColors.primary
                                        : AppColors.red,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    decoration: client?.verificationStatus == VerificationStatus.verified.name
                                        ? null
                                        : TextDecoration.underline,
                                    decorationColor: AppColors.red,
                                  ),
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
                                      context
                                          .read<CitizenProfileCubit>()
                                          .deleteAccount(client?.userId ?? '',
                                              'Admin deletion');
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
                                      name: client?.name ?? '',
                                      phone: client?.phoneNumber ?? '',
                                      address: client?.address ?? '',
                                      dob: client?.dob ??
                                          DateTime.now().toIso8601String(),
                                      onSave: (String updatedName,
                                          String updatedDateOfBirth,
                                          String phone,
                                          String address) {
                                        client = client?.copyWith(
                                          name: updatedName,
                                          phoneNumber: phone,
                                          address: address,
                                          dob: updatedDateOfBirth,
                                        );
                                        if (client == null) {
                                          return;
                                        }
                                        context
                                            .read<CitizenProfileCubit>()
                                            .updateProfile(
                                              client!,
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
                                    context.displayDialog(
                                        CareTeamSelectionDialog(
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

  _navigate(UserDto profile) async {
    context.read<AdminUserCubitNew>().selectCurrentUser(profile);
    context.goNamed(AppRoutes.verifyCitizen.name,
        queryParameters: {'id': profile.userId});
  }

}
