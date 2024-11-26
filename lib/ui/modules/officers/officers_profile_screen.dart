import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
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
import 'package:reentry/ui/modules/profile/bloc/profile_cubit.dart';
import 'package:reentry/ui/modules/profile/bloc/profile_state.dart';
import 'package:reentry/ui/modules/shared/cubit/admin_cubit.dart';

class OfficersProfileScreen extends StatefulWidget {
  final String officerId;

  const OfficersProfileScreen({
    super.key,
    required this.officerId,
  });

  @override
  State<OfficersProfileScreen> createState() => _OfficersProfileScreenState();
}

class _OfficersProfileScreenState extends State<OfficersProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ClientCubit>().fetchClientsByUserId(widget.officerId);
    context
        .read<AppointmentGraphCubit>()
        .appointmentGraphData(userId: widget.officerId);
  }

  @override
  Widget build(BuildContext context) {
    final adminUsersCubit = context.read<AdminUsersCubit>();
    final officer = adminUsersCubit.getMentorById(widget.officerId);

    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),

          );
        } else if (state is ProfileSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')),
          );
          context.read<AdminUsersCubit>().getMentorById(widget.officerId);
        }
      },
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
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
                        _buildProfileCard(officer!),
                        const SizedBox(height: 40),
                        _buildCitizensSection(),
                        const SizedBox(height: 40),
                        AppointmentGraphComponent(userId: widget.officerId)
                      ],
                    ),
                  ),
                ),
              ),
              if (state is ProfileLoading)
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

  Widget _buildProfileCard(UserDto officer) {
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
              name: officer.name,
              email: officer.email,
              imageUrl: officer.avatar,
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
                                  "Parole Officer",
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
                                          name: officer.name,
                                          dob: officer.dob ??
                                              DateTime.now().toIso8601String(),
                                          onSave: (String updatedName,
                                              String updatedDateOfBirth) {
                                            Navigator.of(context).pop();
                                            setState(() {
                                              officer = officer.copyWith(
                                                name: updatedName,
                                                dob: updatedDateOfBirth,
                                              );

                                              context
                                                  .read<ProfileCubit>()
                                                  .updateProfile(
                                                    officer,
                                                    ignoreStorage: false,
                                                  );
                                            });
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
                              officer.createdAt?.toIso8601String() ?? "N/A",
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
                              "Citzens: ",
                              style: context.textTheme.bodySmall?.copyWith(
                                color: AppColors.greyWhite,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              "7",
                              style: context.textTheme.bodySmall?.copyWith(
                                color: AppColors.greyWhite,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
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
