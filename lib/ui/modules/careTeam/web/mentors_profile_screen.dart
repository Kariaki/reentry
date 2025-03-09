import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/data/enum/account_type.dart';
import 'package:reentry/data/model/user_dto.dart';
import 'package:reentry/generated/assets.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/modules/appointment/appointment_graph/appointment_graph_component.dart';
import 'package:reentry/ui/modules/appointment/appointment_graph/appointment_graph_cubit.dart';
import 'package:reentry/ui/modules/appointment/appointment_graph/appointment_graph_state.dart';
import 'package:reentry/ui/modules/authentication/bloc/account_cubit.dart';
import 'package:reentry/ui/modules/careTeam/bloc/care_team_profile_cubit.dart';
import 'package:reentry/ui/modules/careTeam/bloc/mentor_state.dart';
import 'package:reentry/ui/modules/citizens/bloc/citizen_profile_cubit.dart';
import 'package:reentry/ui/modules/citizens/component/icon_button.dart';
import 'package:reentry/ui/modules/citizens/component/profile_card.dart';
import 'package:reentry/ui/modules/citizens/component/reusable_edit_modal.dart';
import 'package:reentry/ui/modules/clients/bloc/client_cubit.dart';
import 'package:reentry/ui/modules/clients/bloc/client_state.dart';
import 'package:reentry/ui/modules/shared/cubit/admin_cubit.dart';
import 'package:reentry/ui/modules/shared/cubit_state.dart';
import '../../../../core/routes/routes.dart';
import '../../../dialog/alert_dialog.dart';
import '../../citizens/dialog/citizen_profile_dialog.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<CareTeamProfileCubit, CareTeamProfileCubitState>(
            listener: (_, state) {
              if (state.state is AdminDeleteUserSuccess) {
                context.showSnackbarSuccess('Account deleted');
                context.pop();
              }
              if (state.state is RemovedCareTeamFromOrganizationSuccess) {
                context.showSnackbarSuccess('Removed from org');
                context.pop();
              }
              final _state = state.state;
              if (_state is CubitStateError) {
                context.showSnackbarError(_state.message);
              }
            },
          ),

        ],
        child: BlocBuilder<CareTeamProfileCubit, CareTeamProfileCubitState>(builder: (context,state){
          final currentMentor= state.user;
          return BaseScaffold(
            isLoading: state.state is CubitStateLoading,
              child:  SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (currentMentor != null)
                    _buildProfileCard(),
                  4.height,
                  _buildCitizensSection(),
                  const SizedBox(height: 40),
                  AppointmentGraphComponent(
                    userId: '',appointments: state.appointments,)
                ],
              ),
            ),
          ));
        }));
  }

  Widget _buildProfileCard() {
    final currentUser = context.read<AccountCubit>().state;
    return BlocBuilder<CareTeamProfileCubit, CareTeamProfileCubitState>(builder: (context,state){
      var client = state.user;
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
                          53.height,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    client?.accountType.name.capitalizeFirst().replaceAll('_', ' ')??'',
                                    style: context.textTheme.bodyLarge?.copyWith(
                                      color: AppColors.greyWhite,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 36,
                                    ),
                                  ),
                                  10.width,
                                ],
                              ),
                              if (currentUser?.accountType ==
                                  AccountType.reentry_orgs) ...[
                                CustomIconButton(
                                  icon: Assets.webDelete,
                                  label: "Remove from Org",
                                  onPressed: () {
                                    AppAlertDialog.show(context,
                                        description:
                                        "Are you sure you want to remove this member from organization?",
                                        title: "Remove from organization?",
                                        action: "Remove", onClickAction: () {
                                          context.read<CareTeamProfileCubit>().removeFromOr(
                                            client?.userId ?? '',
                                            currentUser?.userId ?? '',
                                          );
                                        });
                                  },
                                  backgroundColor: AppColors.greyDark,
                                  textColor: AppColors.white,
                                ),
                              ],
                              if (currentUser?.accountType == AccountType.admin)
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
                                                  client?.userId ?? '', 'Admin deletion');
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
                                          name: client?.name??'',
                                          phone: client?.phoneNumber ?? '',
                                          address: client?.address ?? '',
                                          dob: client?.dob ??
                                              DateTime.now().toIso8601String(),
                                          onSave: (String updatedName,
                                              String updatedDateOfBirth,
                                              String phone,
                                              String address) {
                                            if(client==null){
                                              return;
                                            }
                                            client = client!.copyWith(
                                              name: updatedName,
                                              phoneNumber: phone,
                                              address: address,
                                              dob: updatedDateOfBirth,
                                            );
                                            context
                                                .read<CareTeamProfileCubit>()
                                                .updateProfile(
                                              client!,
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
                              Text(
                                state.appointments.length.toString(),
                                style: context.textTheme.bodySmall?.copyWith(
                                  color: AppColors.greyWhite,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              30.width,
                              Text(
                                "Clients: ${state.citizens.length}",
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

  Widget _buildCitizensSection() {
    return BlocBuilder<CareTeamProfileCubit, CareTeamProfileCubitState>(
      builder: (context, state) {
        final citizens = state.citizens;
        final careTeamId = state.user?.userId;
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
                onViewProfile: () async {
                  context.read<CitizenProfileCubit>()
                    ..setCurrentUser(user)
                    ..fetchCitizenProfileInfo(user);
                  await Future.delayed(Duration(seconds: 1));
                  context.displayDialog(CitizenProfileDialog());
                },
                onUnmatch: () {
                  AppAlertDialog.show(context,
                      description:
                      "Are you sure you want to unmatch this ${AccountType.citizen}?",
                      title: "Unmatch citizen?",
                      action: "Continue", onClickAction: () {
                        context
                            .read<CareTeamProfileCubit>()
                            .unmatch(careTeamId??'', user.userId??'');
                      });
                },
                email: user.email?.capitalizeFirst(),
              ),
            ))
          ],
        );
      },
    );
  }
}

String formatDate(DateTime? date) {
  if (date == null) return "N/A";
  final DateFormat formatter = DateFormat('dd MMM yyyy');
  return formatter.format(date);
}
