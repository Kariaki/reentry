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
import 'package:reentry/ui/modules/activities/bloc/activity_cubit.dart';
import 'package:reentry/ui/modules/activities/web/web_activity_screen.dart';
import 'package:reentry/ui/modules/appointment/appointment_graph/appointment_graph_component.dart';
import 'package:reentry/ui/modules/appointment/web/appointment_screen.dart';
import 'package:reentry/ui/modules/authentication/bloc/account_cubit.dart';
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
    final currentUser = context.read<AdminUserCubitNew>().state.currentData;
    print('equalsto -> ${currentUser?.userId}');
    if (currentUser != null) {
      context.read<CitizenProfileCubit>().fetchCitizenProfileInfo(currentUser);
    }
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
    return Scaffold(
      backgroundColor: AppColors.greyDark,
      body: BlocBuilder<AdminUserCubitNew, MentorDataState>(
          builder: (context, state) {
        if (state.currentData == null) {
          print('********** user is null');
        } else {
          print('user still exist');
        }
        return _buildDefaultView();
      }),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: AppColors.greyDark,
  //     appBar: _buildAppBar(context),
  //     body: MultiBlocListener(
  //       listeners: [
  //         BlocListener<CitizenProfileCubit, CitizenProfileCubitState>(
  //           listener: (context, _state) {
  //             final state = _state.state;
  //             if (state is CubitStateSuccess) {
  //               final assignees = _state.client?.assignees ?? [];
  //               if (assignees.isNotEmpty) {
  //                 context.read<FetchUserListCubit>().fetchUsers(assignees);
  //               }
  //             }
  //           },
  //         ),
  //       ],
  //       child: BlocBuilder<CitizenProfileCubit, CitizenProfileCubitState>(
  //         builder: (context, _state) {
  //           final state = _state.state;
  //           if (state is CubitStateLoading) {
  //             return const Center(child: CircularProgressIndicator());
  //           }
  //           if (state is CubitStateError) {
  //             return _buildError(state.message);
  //           }
  //
  //           final data = _state.client;
  //           final user = _state.user;
  //           if (data == null) {
  //             return const SizedBox();
  //           }
  //           return SingleChildScrollView(
  //             child: showMatchView
  //                 ? _buildMatchView(user!, _state)
  //                 : Column(
  //                     children: [
  //                       _buildDefaultView(),
  //                       const SizedBox(height: 40),
  //                       AppointmentGraphComponent(userId: widget.id)
  //                     ],
  //                   ),
  //           );
  //         },
  //       ),
  //     ),
  //   );
  // }

  Widget _buildDefaultView() {
    return BlocConsumer<ProfileCubit, ProfileState>(listener: (_, state) {
      if (state is DeleteAccountSuccess) {
        context.showSnackbarSuccess('Account deleted');
        context.pop();
      }
      if (state is ProfileError) {
        context.showSnackbarError(state.message);
      }
    }, builder: (context, profileState) {
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

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),

            children: [
              _buildProfileCard(
                  [...mentors, ...officers],
                  appointmentCount: _state.appointmentCount ?? 0,
                  careTeam),
              if (loggedInUser?.accountType != AccountType.mentor &&
                  loggedInUser?.accountType != AccountType.officer) ...[
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
                        onViewProfile: () {
                          context
                              .read<AdminUserCubitNew>()
                              .selectCurrentUser(user);
                          context.goNamed(AppRoutes.officersProfile.name,
                              extra: user.userId,
                              queryParameters: {'id': user.userId});
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
                                  context
                                      .read<CitizenProfileCubit>()
                                      .updateAndRefreshCareTeam(result);
                                }
                              });
                        },
                        email: user.accountType.name.capitalizeFirst(),
                      ),
                    ))
                  ],
                ),
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
                        var percent = ((value?.completed ?? 0) * 100) /
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
                  feelingsChart(context)

                  // 10.width,
                  // feelingsChart(context)
                ],
              ),
              50.height,
              AppointmentGraphComponent(
                userId: currentUser.userId ?? '',
              )
            ],
          );
        },
      );
    });
  }

  Widget _buildProfileCard(List<UserDto> preselected, int? careTeam,
      {int? appointmentCount}) {
    final account = context.read<AccountCubit>().state;
    return BlocBuilder<AdminUserCubitNew, MentorDataState>(
        builder: (context, adminUserState) {
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

                                  context.displayDialog(MultiStepForm(
                                    userId: client?.userId ?? '',
                                    form: client?.intakeForm,
                                  ));
                                },
                                child: Text(
                                  client?.intakeForm != null
                                      ? 'Verified'
                                      : "Click to verify",
                                  style: context.textTheme.bodySmall?.copyWith(
                                    color: client?.intakeForm != null
                                        ? AppColors.primary
                                        : AppColors.red,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    decoration: client?.intakeForm != null
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
