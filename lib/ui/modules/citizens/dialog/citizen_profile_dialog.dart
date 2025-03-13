import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/data/enum/account_type.dart';
import 'package:reentry/data/model/user_dto.dart';
import 'package:reentry/ui/components/error_component.dart';
import 'package:reentry/ui/components/loading_component.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/modules/activities/bloc/activity_cubit.dart';
import 'package:reentry/ui/modules/appointment/appointment_graph/appointment_graph_component.dart';
import 'package:reentry/ui/modules/authentication/bloc/account_cubit.dart';
import 'package:reentry/ui/modules/citizens/bloc/citizen_profile_cubit.dart';
import 'package:reentry/ui/modules/citizens/bloc/citizen_profile_state.dart';
import 'package:reentry/ui/modules/citizens/component/profile_card.dart';
import 'package:reentry/ui/modules/citizens/verify_form.dart';
import 'package:reentry/ui/modules/goals/bloc/goals_cubit.dart';
import 'package:reentry/ui/modules/profile/bloc/profile_cubit.dart';
import 'package:reentry/ui/modules/root/component/activity_progress_component.dart';
import 'package:reentry/ui/modules/shared/cubit/admin_cubit.dart';
import 'package:reentry/ui/modules/shared/cubit_state.dart';
import '../../../../core/const/app_constants.dart';
import '../../../../core/routes/routes.dart';
import '../../profile/bloc/profile_state.dart';


class CitizenProfileDialog extends StatefulWidget {
  const CitizenProfileDialog({
    super.key,
  });

  @override
  State<CitizenProfileDialog> createState() => _CitizenProfileDialogState();
}

class _CitizenProfileDialogState extends State<CitizenProfileDialog> {
  bool showMatchView = false;
  List<UserDto> selectedUsers = [];

  @override
  void initState() {
    super.initState();
    // final currentUser = context.read<CitizenProfileCubit>().state.user;
    // if (currentUser != null) {
    //   context.read<CitizenProfileCubit>().fetchCitizenProfileInfo(currentUser);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CitizenProfileCubit, CitizenProfileCubitState>(listener: (_, state) {

      final newState = state.state;
      if (newState is CubitStateError) {
        context.showSnackbarError(newState.message);
      }
    }, builder: (context, _state) {
      final currentUser = _state.user;
      final loggedInUser = context.read<AccountCubit>().state;
      if (currentUser == null) {
        return const ErrorComponent(
          title: 'User not found',
        );
      }
      final careTeam = _state.careTeam.length;
      final mentors = _state.careTeam
          .where((user) => user.accountType == AccountType.mentor)
          .toList();
      final officers = _state.careTeam
          .where((user) => user.accountType == AccountType.officer)
          .toList();

      return BaseScaffold(
          isLoading: _state.state is CubitStateLoading,
          child: Scrollbar(
            child:ListView(
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
                        ..._state.careTeam.map((user) =>  ListTile(
                          leading:
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  user.avatar ?? AppConstants.avatar),
                            ),
                          ),
                          title:  Text(user.name,style: context.textTheme.bodyMedium?.copyWith(fontSize: 17),),
                          subtitle: Text(user.accountType.name.replaceAll('_', ' ').capitalizeFirst(),style: context.textTheme.bodySmall?.copyWith(fontSize: 14,color: Colors.white),),
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
                      feelingsChart(context,data:currentUser.feelingTimeLine )

                      // 10.width,
                      // feelingsChart(context)
                    ],
                  ),
                  50.height,
                  AppointmentGraphComponent(
                    appointments: _state.appointments,
                    userId: currentUser.userId ?? '',
                  )
                ]
            ),
          ));
    });
  }


  Widget _buildProfileCard(List<UserDto> preselected, int? careTeam,
      {int? appointmentCount}) {
    return BlocBuilder<CitizenProfileCubit, CitizenProfileCubitState>(
        builder: (context, adminUserState) {
          UserDto? client = adminUserState.user;
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
                    idNumber: client?.userCode??'',
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
                                          // context.displayDialog(MultiStepForm(
                                          //   userId: client?.userId ?? '',
                                          //   form: client?.intakeForm,
                                          // ));
                                          context.showSnackbarInfo('Verify citizen from their profile');
                                        },
                                        child: Text(
                                          client?.verificationStatus == VerificationStatus.verified.name
                                              ? 'Verified'
                                              : "Unverified",
                                          style: context.textTheme.bodySmall?.copyWith(
                                            color: client?.verificationStatus == VerificationStatus.verified.name
                                                ? AppColors.primary
                                                : AppColors.red,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            decorationColor: AppColors.red,
                                          ),
                                        ),
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
