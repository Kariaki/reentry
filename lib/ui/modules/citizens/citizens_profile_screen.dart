// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/data/enum/account_type.dart';
import 'package:reentry/data/model/user_dto.dart';
import 'package:reentry/generated/assets.dart';
import 'package:reentry/ui/components/input/input_field.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/modules/appointment/appointment_graph/appointment_graph_component.dart';
import 'package:reentry/ui/modules/citizens/bloc/citizen_profile_cubit.dart';
import 'package:reentry/ui/modules/citizens/bloc/citizen_profile_state.dart';
import 'package:reentry/ui/modules/citizens/component/icon_button.dart';
import 'package:reentry/ui/modules/citizens/component/match_result_modal.dart';
import 'package:reentry/ui/modules/citizens/component/profile_card.dart';
import 'package:reentry/ui/modules/citizens/component/reusable_edit_modal.dart';
import 'package:reentry/ui/modules/citizens/component/selectedable_card.dart';
import 'package:reentry/ui/modules/clients/bloc/client_bloc.dart';
import 'package:reentry/ui/modules/clients/bloc/client_profile_cubit.dart';
import 'package:reentry/ui/modules/clients/bloc/client_state.dart';
import 'package:reentry/ui/modules/shared/cubit/admin_cubit.dart';
import 'package:reentry/ui/modules/shared/cubit/fetch_user_list_state.dart';
import 'package:reentry/ui/modules/shared/cubit/fetch_users_list_cubit.dart';
import 'package:reentry/ui/modules/shared/cubit_state.dart';

import '../../../data/enum/client_status.dart';
import '../../../data/model/client_dto.dart';
import '../clients/bloc/client_event.dart';

class CitizenProfileScreen extends StatefulWidget {
  final String id;

  const CitizenProfileScreen({
    super.key,
    required this.id,
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
    if (currentUser != null) {
      context.read<CitizenProfileCubit>().fetchCitizenProfileInfo(currentUser);
      context.read<AdminUsersCubit>().fetchNonCitizens();
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

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: AppColors.greyDark,
  //     appBar: _buildAppBar(context),
  //     body: MultiBlocListener(
  //       listeners: [
  //         BlocListener<ClientProfileCubit, ClientState>(
  //           listener: (context, state) {
  //             if (state is ClientSuccess) {
  //               final assignees = state.client.assignees;
  //               if (assignees.isNotEmpty) {
  //                 context.read<FetchUserListCubit>().fetchUsers(assignees);
  //               }
  //             }
  //           },
  //         ),
  //       ],
  //       child: showMatchView ? _buildMatchView() : _buildDefaultView(),
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyDark,
      appBar: _buildAppBar(context),
      body: MultiBlocListener(
        listeners: [
          BlocListener<CitizenProfileCubit, CitizenProfileCubitState>(
            listener: (context, _state) {
              final state = _state.state;
              if (state is CubitStateSuccess) {
                final assignees = _state.client?.assignees ?? [];
                if (assignees.isNotEmpty) {
                  context.read<FetchUserListCubit>().fetchUsers(assignees);
                }
              }
            },
          ),
        ],
        child: BlocBuilder<CitizenProfileCubit, CitizenProfileCubitState>(
          builder: (context, _state) {
            final state = _state.state;
            if (state is CubitStateLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is CubitStateError) {
              return _buildError(state.message);
            }

            final data = _state.client;
            final user = _state.user;
            if (data == null) {
              return const SizedBox();
            }
            return SingleChildScrollView(
              child: showMatchView
                  ? _buildMatchView(user!, _state)
                  : Column(
                      children: [
                        _buildDefaultView(),
                        const SizedBox(height: 40),
                        AppointmentGraphComponent(userId: widget.id)
                      ],
                    ),
            );
          },
        ),
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
                preffixIcon: SvgPicture.asset(Assets.webSearch),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultView() {
    return BlocBuilder<CitizenProfileCubit, CitizenProfileCubitState>(
      builder: (context, _state) {
        final state = _state.state;
        if (state is CubitStateLoading) {
          return const Center(child: CircularProgressIndicator());
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
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                // _buildProfileCard(client),
                _buildProfileCard(
                    data,
                    appointmentCount: _state.appointmentCount ?? 0,
                    careTeam),
                const SizedBox(height: 40),
                _buildSection(
                  context,
                  title: "Peer Mentors",
                  users: mentors,
                  emptyMessage: "No mentors available.",
                ),
                const SizedBox(height: 40),
                _buildSection(
                  context,
                  title: "Parole Officers",
                  users: officers,
                  emptyMessage: "No officers available.",
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMatchView(UserDto client, CitizenProfileCubitState state) {
    return BlocConsumer<ClientBloc, ClientState>(listener: (_, state) {
      if (state is ClientSuccess) {
        setState(() {
          showMatchView=false;
        });
        showDialog(
          context: context,
          builder: (context) {
            return const MatchResultModal(
              isSuccess: true,
              title: "Match successful",
              message:
                  "The purpose of human life is to serve, and show compassion and the will to help others",
              quoteAuthor: "Albert Schweitzer",
              icon: Icons.thumb_up,
            );
          },
        );
      } else if (state is ClientError) {
        showDialog(
          context: context,
          builder: (context) {
            return const MatchResultModal(
              isSuccess: false,
              title: "Match unsuccessful",
              message: "Try again",
              quoteAuthor: "",
              icon: Icons.close,
            );
          },
        );
      }
    }, builder: (context, clientState) {
      if (clientState is ClientLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      if (clientState is ClientError) {
        return _buildError(clientState.error);
      }
      return BlocBuilder<AdminUsersCubit, CubitState>(
        builder: (context, adminState) {
          if (adminState is CubitStateLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (adminState is CubitStateError) {
            return _buildError(adminState.message);
          } else if (adminState is CubitDataStateSuccess<List<UserDto>>) {
            final users = adminState.data;
            final careTeam = users.length;
            final mapCareTeam = state.careTeam.map((e) => e.userId).toList();
            final mentors = users
                .where((user) =>
                    user.accountType == AccountType.mentor &&
                    !mapCareTeam.contains(user.userId))
                .toList();
            final officers = users
                .where((user) =>
                    user.accountType == AccountType.officer &&
                    !mapCareTeam.contains(user.userId))
                .toList();

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    _buildProfileCard(client, careTeam),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: AppColors.red,
                            size: 24,
                          ),
                          onPressed: () {
                            setState(() {
                              showMatchView = false;
                            });
                          },
                        ),
                      ],
                    ),
                    _buildMatchSection(
                      context,
                      title: "Peer Mentors",
                      users: mentors,
                    ),
                    const SizedBox(height: 40),
                    _buildMatchSection(
                      context,
                      title: "Parole Officers",
                      users: officers,
                    ),
                    if (selectedUsers.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 40.0),
                        child: CustomIconButton(
                          icon: Assets.webMatch,
                          label: "Match",
                          backgroundColor: AppColors.primary,
                          textColor: AppColors.white,
                          onPressed: () {
                            final client = state.client;
                            if (client == null) {
                              return;
                            }
                            context.read<ClientBloc>().add(ClientActionEvent(
                                  client.copyWith(
                                    status: ClientStatus.active,
                                    assignees: selectedUsers
                                        .map((user) => user.userId ?? '')
                                        .toList(),
                                  ),
                                ));
                          },
                        ),
                      ),
                  ],
                ),
              ),
            );
          } else {
            return const SizedBox();
          }
        },
      );
    });
  }

  Widget _buildProfileCard(UserDto client, int? careTeam,
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
                            Expanded(
                              child: Row(
                                children: [
                                  Text(
                                    "Citizen",
                                    style:
                                        context.textTheme.bodyLarge?.copyWith(
                                      color: AppColors.greyWhite,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 36,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "Unverified",
                                    style:
                                        context.textTheme.bodySmall?.copyWith(
                                      color: AppColors.red,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                      decorationColor: AppColors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                // CustomIconButton(
                                //   icon: Assets.delete,
                                //   label: "Delete",
                                //   onPressed: () {},
                                //   backgroundColor: AppColors.greyDark,
                                //   textColor: AppColors.white,
                                // ),
                                const SizedBox(width: 10),
                                CustomIconButton(
                                  icon: Assets.webEdit,
                                  label: "Edit",
                                  backgroundColor: AppColors.white,
                                  textColor: AppColors.black,
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return ReusableEditModal(
                                          name: client.name,
                                          dob: client.dob ??
                                              DateTime.now().toIso8601String(),
                                          onSave: (String updatedName,
                                              String updatedDateOfBirth) {
                                            context.popRoute();
                                            client = client.copyWith(
                                              name: updatedName,
                                              dob: updatedDateOfBirth,
                                            );
                                            context
                                                .read<CitizenProfileCubit>()
                                                .updateProfile(
                                                  client,
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
                                const SizedBox(width: 10),
                                CustomIconButton(
                                  icon: Assets.webMatch,
                                  label: "Match",
                                  backgroundColor: AppColors.primary,
                                  textColor: AppColors.white,
                                  onPressed: () {
                                    setState(() {
                                      showMatchView = true;
                                    });
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
                            // Text(
                            //   client.createdAt != null
                            //       ? DateFormat('dd MMM yyyy, hh:mm a').format(
                            //           DateTime.fromMillisecondsSinceEpoch(
                            //               client.createdAt),
                            //         )
                            //       : 'Unknown Date',
                            //   style: context.textTheme.bodySmall?.copyWith(
                            //     color: AppColors.white,
                            //     fontSize: 14,
                            //     fontWeight: FontWeight.w400,
                            //   ),
                            // ),
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

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<UserDto> users,
    required String emptyMessage,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.greyWhite,
          ),
        ),
        const SizedBox(height: 10),
        users.isEmpty
            ? Center(
                child: Text(
                  emptyMessage,
                  style: TextStyle(color: AppColors.gray2),
                ),
              )
            : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 0.8,
                ),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return ProfileCard(
                    name: user.name,
                    email: user.email,
                    imageUrl: user.avatar,
                    showActions: false,
                  );
                },
              ),
      ],
    );
  }

  Widget _buildMatchSection(
    BuildContext context, {
    required String title,
    required List<UserDto> users,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.greyWhite,
          ),
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 0.8,
          ),
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            final isSelected = selectedUsers.contains(user);

            return Opacity(
              opacity: selectedUsers.contains(user) ? 1.0 : 1.0,
              child: SelectableCard(
                name: user.name,
                email: user.email,
                imageUrl: user.avatar,
                isSelected: isSelected,
                onToggleSelection: () => toggleSelection(user),
              ),
            );
          },
        ),
      ],
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
