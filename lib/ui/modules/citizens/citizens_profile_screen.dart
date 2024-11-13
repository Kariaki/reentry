import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/data/enum/account_type.dart';
import 'package:reentry/data/model/client_dto.dart';
import 'package:reentry/data/model/user_dto.dart';
import 'package:reentry/generated/assets.dart';
import 'package:reentry/ui/components/input/input_field.dart';
import 'package:reentry/ui/modules/authentication/bloc/account_cubit.dart';
import 'package:reentry/ui/modules/citizens/component/icon_button.dart';
import 'package:reentry/ui/modules/citizens/component/profile_card.dart';
import 'package:reentry/ui/modules/citizens/component/selectedable_card.dart';
import 'package:reentry/ui/modules/clients/bloc/client_bloc.dart';
import 'package:reentry/ui/modules/clients/bloc/client_event.dart';
import 'package:reentry/ui/modules/clients/bloc/client_profile_cubit.dart';
import 'package:reentry/ui/modules/clients/bloc/client_state.dart';
import 'package:reentry/ui/modules/shared/cubit/admin_cubit.dart';
import 'package:reentry/ui/modules/shared/cubit/fetch_user_list_state.dart';
import 'package:reentry/ui/modules/shared/cubit/fetch_users_list_cubit.dart';
import 'package:reentry/ui/modules/shared/cubit_state.dart';

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
    context.read<ClientProfileCubit>().fetchClientById(widget.id);
    context.read<AdminUsersCubit>().fetchNonCitizens();
  }

  void toggleSelection(UserDto user) {
    setState(() {
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
          BlocListener<ClientProfileCubit, ClientState>(
            listener: (context, state) {
              if (state is ClientSuccess) {
                final assignees = state.client.assignees;
                if (assignees.isNotEmpty) {
                  context.read<FetchUserListCubit>().fetchUsers(assignees);
                }
              }
            },
          ),
        ],
        child: BlocBuilder<ClientProfileCubit, ClientState>(
          builder: (context, clientState) {
            if (clientState is ClientLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (clientState is ClientError) {
              return _buildError(clientState.error);
            } else if (clientState is ClientSuccess) {
              return showMatchView
                  ? _buildMatchView(clientState.client)
                  : _buildDefaultView();
            } else {
              return const SizedBox();
            }
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
                preffixIcon: SvgPicture.asset(Assets.search),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultView() {
    return BlocBuilder<ClientProfileCubit, ClientState>(
      builder: (context, clientState) {
        if (clientState is ClientLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (clientState is ClientError) {
          return _buildError(clientState.error);
        } else if (clientState is ClientSuccess) {
          final client = clientState.client;
          return BlocBuilder<FetchUserListCubit, FetchUserListCubitState>(
            builder: (context, fetchUserState) {
              if (fetchUserState.isLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (fetchUserState.hasError) {
                return _buildError(fetchUserState.errorMessage);
              } else if (fetchUserState.isSuccess) {
                final users = fetchUserState.data;
                final mentors = users
                    .where((user) => user.accountType == AccountType.mentor)
                    .toList();
                final officers = users
                    .where((user) => user.accountType == AccountType.officer)
                    .toList();

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        _buildProfileCard(client),
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
              } else {
                return const SizedBox();
              }
            },
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget _buildMatchView(ClientDto client) {
    final account = context.read<AccountCubit>().state;
    return BlocBuilder<AdminUsersCubit, CubitState>(
      builder: (context, state) {
        if (state is CubitStateLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CubitStateError) {
          return _buildError(state.message);
        } else if (state is CubitDataStateSuccess<List<UserDto>>) {
          final users = state.data;
          final mentors = users
              .where((user) => user.accountType == AccountType.mentor)
              .toList();
          final officers = users
              .where((user) => user.accountType == AccountType.officer)
              .toList();

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  BlocBuilder<ClientProfileCubit, ClientState>(
                    builder: (context, clientState) {
                      if (clientState is ClientLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (clientState is ClientError) {
                        return _buildError(clientState.error);
                      } else if (clientState is ClientSuccess) {
                        return _buildProfileCard(clientState.client);
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                  const SizedBox(height: 40),
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
                        icon: Assets.match,
                        label: "Match",
                        backgroundColor: AppColors.primary,
                        textColor: AppColors.white,
                        onPressed: () {
                          context.read<ClientBloc>().add(ClientActionEvent(
                                  client.copyWith(
                                      status: ClientStatus.active,
                                      assignees: [
                                    ...client.assignees,
                                    account?.userId ?? ''
                                  ])));
                          setState(() {
                            showMatchView = true;
                          });
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
  }

  Widget _buildProfileCard(ClientDto client) {
    return Row(
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
                          Row(
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
                          Row(
                            children: [
                              CustomIconButton(
                                icon: Assets.delete,
                                label: "Delete",
                                onPressed: () {},
                                backgroundColor: AppColors.greyDark,
                                textColor: AppColors.white,
                              ),
                              const SizedBox(width: 10),
                              CustomIconButton(
                                icon: Assets.edit,
                                label: "Edit",
                                backgroundColor: AppColors.white,
                                textColor: AppColors.black,
                                onPressed: () {},
                              ),
                              const SizedBox(width: 10),
                              CustomIconButton(
                                icon: Assets.match,
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
                          Text(
                            client.createdAt.toString(),
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
                            "465",
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

            return GestureDetector(
              onTap: () => toggleSelection(user),
              child: Opacity(
                opacity: isSelected ? 1.0 : 0.5,
                child: SelectableCard(
                  name: user.name,
                  email: user.email,
                  imageUrl: user.avatar,
                  // isSelected: isSelected,
                ),
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
