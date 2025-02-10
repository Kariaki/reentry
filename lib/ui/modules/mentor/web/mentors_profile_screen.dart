import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/data/enum/account_type.dart';
import 'package:reentry/data/model/user_dto.dart';
import 'package:reentry/generated/assets.dart';
import 'package:reentry/ui/modules/appointment/appointment_graph/appointment_graph_component.dart';
import 'package:reentry/ui/modules/appointment/appointment_graph/appointment_graph_cubit.dart';
import 'package:reentry/ui/modules/appointment/appointment_graph/appointment_graph_state.dart';
import 'package:reentry/ui/modules/citizens/component/icon_button.dart';
import 'package:reentry/ui/modules/citizens/component/profile_card.dart';
import 'package:reentry/ui/modules/citizens/component/reusable_edit_modal.dart';
import 'package:reentry/ui/modules/clients/bloc/client_cubit.dart';
import 'package:reentry/ui/modules/clients/bloc/client_state.dart';
import 'package:reentry/ui/modules/shared/cubit/admin_cubit.dart';
import 'package:reentry/ui/modules/shared/cubit_state.dart';
import '../../../../core/routes/routes.dart';
import '../../../dialog/alert_dialog.dart';
import '../../profile/bloc/profile_cubit.dart';
import '../../profile/bloc/profile_state.dart';

class CareTeamProfileScreen extends StatefulWidget {
  final String? id;

  const CareTeamProfileScreen({super.key, this.id});

  @override
  State<CareTeamProfileScreen> createState() => _CareTeamProfileScreenState();
}

class _CareTeamProfileScreenState extends State<CareTeamProfileScreen> {
  @override
  void initState() {
    super.initState();
    final mentor = context.read<AdminUserCubitNew>().state.currentData;
    print('* user id -> ${mentor?.userId}');
    context.read<ClientCubit>().fetchClientsByUserId(mentor?.userId ?? '');
    context
        .read<AppointmentGraphCubit>()
        .appointmentGraphData(userId: mentor?.userId ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final mentor = context.read<AdminUserCubitNew>().state.currentData;
    return MultiBlocListener(
        listeners: [
          BlocListener<AdminUserCubitNew, MentorDataState>(
            listener: (context, _state) {
              final state = _state.state;
              if (state is CubitStateError) {
                context.showSnackbarError(state.message);
                return;
              }
              if (state is CubitStateSuccess) {
                context.showSnackbarSuccess("Profile update success");
                return;
              }
            },
          ),
          BlocListener<ProfileCubit, ProfileState>(
            listener: (_, state) {
              if (state is DeleteAccountSuccess) {
                context.showSnackbarSuccess('Account deleted');
                context.pop();
              }
              if (state is ProfileError) {
                context.showSnackbarError(state.message);
              }
            },
          ),
          BlocListener<ClientCubit, ClientState>(
            listener: (_, state) {
              if (state is ClientDataSuccess) {
                if(state.message!=null) {
                  context.showSnackbarSuccess(state.message!);
                }
              }
              if (state is ClientError) {
                context.showSnackbarError(state.error);
              }
            },
          ),
        ],
        child: BlocBuilder<AdminUserCubitNew, MentorDataState>(
          builder: (context, _state) {
            final state = _state.state;
            final currentMentor = _state.currentData;
            return Stack(
              children: [
                Scaffold(
                  backgroundColor: AppColors.greyDark,
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (currentMentor != null)
                            _buildProfileCard(
                                currentMentor, [], _state.data.length),
                          const SizedBox(height: 40),
                          _buildCitizensSection(mentor?.userId??''),
                          const SizedBox(height: 40),
                          AppointmentGraphComponent(
                              userId: _state.currentData?.userId)
                        ],
                      ),
                    ),
                  ),
                ),
                if (state is CubitStateLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            );
          },
        ));
  }

  Widget _buildProfileCard(
      UserDto client, List<UserDto> preselected, int? careTeam,
      {int? appointmentCount}) {
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
                    53.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              client.accountType.name.capitalizeFirst(),
                              style: context.textTheme.bodyLarge?.copyWith(
                                color: AppColors.greyWhite,
                                fontWeight: FontWeight.w600,
                                fontSize: 36,
                              ),
                            ),
                            10.width,
                          ],
                        ),
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
                                  context.read<ProfileCubit>().deleteAccount(
                                      client.userId ?? '', 'Admin deletion');
                                });
                              },
                              backgroundColor: AppColors.greyDark,
                              textColor: AppColors.white,
                            ),
                            10.width,
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
                                        .read<AdminUserCubitNew>()
                                        .updateProfile(
                                          client,
                                        );
                                  },
                                  onCancel: () {
                                    Navigator.of(context).pop();
                                  },
                                ));
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    10.height,
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
                    60.height,
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
                        BlocBuilder<AppointmentGraphCubit,
                                AppointmentGraphState>(
                            builder: (context, appointmentState) {
                          String count = '0';
                          if (appointmentState is AppointmentGraphSuccess) {
                            count =
                                appointmentState.appointmentCount.toString();
                          }
                          return Text(
                            count.toString(),
                            style: context.textTheme.bodySmall?.copyWith(
                              color: AppColors.greyWhite,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          );
                        }),
                        30.width,
                        BlocBuilder<ClientCubit, ClientState>(
                            builder: (context, clientCubit) {
                          String value = '0';
                          if (clientCubit is ClientDataSuccess) {
                            value = clientCubit.data.length.toString();
                          }
                          return Text(
                            "Clients: $value",
                            style: context.textTheme.bodySmall?.copyWith(
                              color: AppColors.greyWhite,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          );
                        }),
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
  }

  Widget _buildCitizensSection(String careTeamId) {
    return BlocBuilder<ClientCubit, ClientState>(
      builder: (context, state) {
        if (state is ClientLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is ClientError) {
          return Center(
            child: Text(
              state.error,
              style: const TextStyle(color: AppColors.red),
            ),
          );
        } else if (state is ClientDataSuccess) {
          final citizens = state.data;
          if (citizens.isEmpty) {
            return const Center(
              child: Text(
                "No citizens available.",
                style: TextStyle(color: AppColors.gray2),
              ),
            );
          }

          return Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.start,
            children: [
              ...citizens.map((user) => Container(
                    width: 200,
                    height: 275,
                    margin: const EdgeInsets.only(right: 20),
                    child: ProfileCard(
                      name: user.name,
                      showActions: true,
                      onViewProfile: () {
                        context
                            .read<AdminUserCubitNew>()
                            .selectCurrentUser(user.toUserDto());
                        context.goNamed(AppRoutes.citizenProfile.name,
                            queryParameters: {'id': user.id});
                      },
                      onUnmatch: () {
                        AppAlertDialog.show(context,
                            description:
                                "Are you sure you want to unmatch this ${AccountType.citizen}?",
                            title: "Unmatch citizen?",
                            action: "Continue",
                            onClickAction: () {
                          context.read<ClientCubit>().unmatch(careTeamId, user.id);
                            });
                      },
                      email: user.email?.capitalizeFirst(),
                    ),
                  ))
            ],
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}

String formatDate(DateTime? date) {
  if (date == null) return "N/A";
  final DateFormat formatter = DateFormat('dd MMM yyyy');
  return formatter.format(date);
}
