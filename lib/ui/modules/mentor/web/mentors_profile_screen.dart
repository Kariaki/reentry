import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/data/model/user_dto.dart';
import 'package:reentry/generated/assets.dart';
import 'package:reentry/ui/components/input/input_field.dart';
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

class MentorProfileScreen extends StatefulWidget {
  final String mentorId;

  const MentorProfileScreen({
    super.key,
    required this.mentorId,
  });

  @override
  State<MentorProfileScreen> createState() => _MentorProfileScreenState();
}

class _MentorProfileScreenState extends State<MentorProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ClientCubit>().fetchClientsByUserId(widget.mentorId);
    context
        .read<AppointmentGraphCubit>()
        .appointmentGraphData(userId: widget.mentorId);
    mentor = context.read<AdminUsersCubit>().getMentorById(widget.mentorId);
  }

  UserDto? mentor;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminUserCubitNew, MentorDataState>(
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
      child: BlocBuilder<AdminUserCubitNew, MentorDataState>(
        builder: (context, _state) {
          final state = _state.state;
          final currentMentor = _state.currentData;
          return Stack(
            children: [
              Scaffold(
                backgroundColor: AppColors.greyDark,
                appBar: _buildAppBar(context),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        if (currentMentor != null)
                          _buildProfileCard(currentMentor),
                        const SizedBox(height: 40),
                        _buildCitizensSection(),
                        const SizedBox(height: 40),
                        AppointmentGraphComponent(userId: widget.mentorId)
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
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(120),
      child: AppBar(
        backgroundColor: AppColors.greyDark,
        flexibleSpace: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Search",
                style: context.textTheme.bodyLarge?.copyWith(
                  color: AppColors.greyWhite,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              InputField(
                hint: 'Enter name, email or code to search',
                radius: 10.0,
                preffixIcon: SvgPicture.asset(Assets.search),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(UserDto mentor) {
    print(mentor.createdAt?.toIso8601String());
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
              name: mentor.name,
              email: mentor.email,
              imageUrl: mentor.avatar,
              showActions: false,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
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
                              children: [
                                Text(
                                  "Peer mentor",
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
                            Row(
                              children: [
                                const SizedBox(width: 10),
                                CustomIconButton(
                                  icon: Assets.edit,
                                  label: "Edit",
                                  backgroundColor: AppColors.white,
                                  textColor: AppColors.black,
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return ReusableEditModal(
                                          name: mentor.name,
                                          dob: mentor.dob ??
                                              DateTime.now().toIso8601String(),
                                          onSave: (String updatedName,
                                              String updatedDateOfBirth) {
                                            context.pop();
                                            mentor = mentor.copyWith(
                                              name: updatedName,
                                              dob: updatedDateOfBirth,
                                            );
                                            context
                                                .read<AdminUserCubitNew>()
                                                .updateProfile(
                                                  mentor,
                                                );
                                          },
                                          onCancel: () {
                                            Navigator.of(context).pop();
                                          },
                                        );
                                      },
                                    );
                                  },
                                ),
                                // const SizedBox(width: 10),
                                // CustomIconButton(
                                //   icon: Assets.match,
                                //   label: "Match",
                                //   backgroundColor: AppColors.primary,
                                //   textColor: AppColors.white,
                                //   onPressed: () {},
                                // ),
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
                            Text(
                              // mentor.createdAt?.toIso8601String() ?? "N/A",
                              formatDate(mentor.createdAt),
                              style: context.textTheme.bodySmall?.copyWith(
                                color: AppColors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 60),
                        Row(
                          children: [
                            BlocBuilder<AppointmentGraphCubit,
                                AppointmentGraphState>(
                              builder: (context, appointmentState) {
                                if (appointmentState
                                    is AppointmentGraphLoading) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Appointments: ",
                                        style: context.textTheme.bodySmall
                                            ?.copyWith(
                                          color: AppColors.greyWhite,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 16,
                                        width: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ],
                                  );
                                } else if (appointmentState
                                    is AppointmentGraphSuccess) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Appointments: ",
                                        style: context.textTheme.bodySmall
                                            ?.copyWith(
                                          color: AppColors.greyWhite,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        appointmentState.data.length.toString(),
                                        style: context.textTheme.bodySmall
                                            ?.copyWith(
                                          color: AppColors.greyWhite,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  );
                                } else if (appointmentState
                                    is AppointmentGraphError) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Appointments: ",
                                        style: context.textTheme.bodySmall
                                            ?.copyWith(
                                          color: AppColors.greyWhite,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        "Error",
                                        style: context.textTheme.bodySmall
                                            ?.copyWith(
                                          color: AppColors.red,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              },
                            ),
                            const SizedBox(width: 30),
                            Text(
                              "Clients: ",
                              style: context.textTheme.bodySmall?.copyWith(
                                color: AppColors.greyWhite,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                       Builder(builder: (context){
                         final cubit = context.watch<ClientCubit>().state;
                         int count = 0;
                         if(cubit is ClientDataSuccess){
                           count = cubit.data.length;
                         }
                         return      Text(
                           "$count",
                           style: context.textTheme.bodySmall?.copyWith(
                             color: AppColors.greyWhite,
                             fontSize: 16,
                             fontWeight: FontWeight.w400,
                           ),
                         );
                       }),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    color: AppColors.gray2,
                    thickness: 1,
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCitizensSection() {
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
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: citizens.length,
            itemBuilder: (context, index) {
              final citizen = citizens[index];
              return ProfileCard(
                name: citizen.name,
                email: citizen.email,
                imageUrl: citizen.avatar,
                showActions: false,
              );
            },
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
