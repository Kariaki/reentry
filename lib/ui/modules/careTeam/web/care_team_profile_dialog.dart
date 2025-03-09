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
import '../../../../core/const/app_constants.dart';
import '../../../../core/routes/routes.dart';
import '../../../dialog/alert_dialog.dart';
import '../../citizens/dialog/citizen_profile_dialog.dart';
import '../../profile/bloc/profile_cubit.dart';
import '../../profile/bloc/profile_state.dart';

class CareTeamProfileDialog extends StatefulWidget {
  const CareTeamProfileDialog({
    super.key,
  });

  @override
  State<CareTeamProfileDialog> createState() => _CareTeamProfileDialogState();
}

class _CareTeamProfileDialogState extends State<CareTeamProfileDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CareTeamProfileCubit, CareTeamProfileCubitState>(
      builder: (context, _state) {
        final state = _state.state;
        final user = _state.user;
        return BaseScaffold(child: Builder(builder: (context) {
          if (state is CubitStateLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Scrollbar(
              child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (user != null) _buildProfileCard(_state),
                  40.height, const Text(
                    'Clients',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: AppColors.greyWhite,
                    ),
                  ),
                  20.height,
                  _buildCitizensSection(_state.citizens),
                  const SizedBox(height: 40),
                  AppointmentGraphComponent(
                    userId: user?.userId,
                    appointments: _state.appointments,
                  )
                ],
              ),
            ),
          ));
        }));
      },
    );
  }

  Widget _buildProfileCard(CareTeamProfileCubitState state) {
    final client = state.user;
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
                              client?.accountType.name
                                      .capitalizeFirst()
                                      .replaceAll('_', ' ') ??
                                  '',
                              style: context.textTheme.bodyLarge?.copyWith(
                                color: AppColors.greyWhite,
                                fontWeight: FontWeight.w600,
                                fontSize: 36,
                              ),
                            ),
                            10.width,
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
                          "Clients: ${state.citizens.length.toString()}",
                          style: context.textTheme.bodySmall?.copyWith(
                            color: AppColors.greyWhite,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        )
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

  Widget _buildCitizensSection(List<UserDto> citizens) {
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
        ...citizens.map((user) => ListTile(
              leading: SizedBox(
                width: 40,
                height: 40,
                child: CircleAvatar(
                  backgroundImage:
                      NetworkImage(user.avatar ?? AppConstants.avatar),
                ),
              ),
              title: Text(
                user.name,
                style: context.textTheme.bodyMedium?.copyWith(fontSize: 17),
              ),
              subtitle: Text(
                user.accountType.name.replaceAll('_', ' ').capitalizeFirst(),
                style: context.textTheme.bodySmall
                    ?.copyWith(fontSize: 14, color: Colors.white),
              ),
            ))
      ],
    );
  }
}

String formatDate(DateTime? date) {
  if (date == null) return "N/A";
  final DateFormat formatter = DateFormat('dd MMM yyyy');
  return formatter.format(date);
}
