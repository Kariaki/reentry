import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reentry/core/const/app_constants.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/data/enum/account_type.dart';
import 'package:reentry/data/model/user_dto.dart';
import 'package:reentry/generated/assets.dart';
import 'package:reentry/ui/modules/authentication/bloc/account_cubit.dart';
import 'package:reentry/ui/modules/authentication/bloc/auth_events.dart';
import 'package:reentry/ui/modules/authentication/bloc/authentication_bloc.dart';

import '../dialog/alert_dialog.dart';

class WebSideBarLayout extends StatefulWidget {
  final Widget child;

  const WebSideBarLayout({super.key, required this.child});

  @override
  _WebSideBarLayoutState createState() => _WebSideBarLayoutState();
}

class _WebSideBarLayoutState extends State<WebSideBarLayout> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedPage = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyDark,
      key: _scaffoldKey,
      drawer: Drawer(
        backgroundColor: AppColors.greyDark,
        child: _buildSidebar(),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isDesktop = constraints.maxWidth > 800;
          return Row(
            children: [
              if (isDesktop)
                Container(
                  width: 250,
                  color: AppColors.greyDark,
                  child: _buildSidebar(),
                ),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      color: AppColors.greyDark,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (!isDesktop)
                            IconButton(
                              icon: const Icon(Icons.menu,
                                  color: AppColors.white),
                              onPressed: () {
                                _scaffoldKey.currentState?.openDrawer();
                              },
                            ),
                          const SizedBox(width: 16),
                          SvgPicture.asset(Assets.svgMail),
                        ],
                      ),
                    ),
                    Expanded(child: widget.child),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSidebar() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Sainte',
              style: context.textTheme.titleLarge?.copyWith(fontSize: 30),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                BlocBuilder<AccountCubit, UserDto?>(builder: (context, state) {
              if (state == null) return const SizedBox();
              // final accountType = state.accountType;
              return Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage:
                        NetworkImage(state.avatar ?? AppConstants.avatar),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(state.name, style: context.textTheme.bodyMedium),
                        Text(
                          state.email ?? 'jane.dow@example.com',
                          style: context.textTheme.bodyMedium!
                              .copyWith(fontSize: 11, color: AppColors.grey1),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),
          40.height,
          _buildSidebarItem(Assets.svgDashbaord, 'Dashboard', '/dashbaord'),
          // BlocBuilder<AccountCubit, UserDto?>(builder: (context, state) {
          //   if (state?.accountType != AccountType.citizen) {
          //     return Column(
          //       children: [
          //         Padding(
          //           padding: const EdgeInsets.symmetric(
          //               horizontal: 16.0, vertical: 8.0),
          //           child: Text(
          //             "CARE TEAM",
          //             style: context.textTheme.bodySmall!
          //                 .copyWith(fontSize: 11, color: AppColors.grey1),
          //           ),
          //         ),
          //         _buildSidebarItem(
          //             Assets.svgCitizens, 'Citizens', '/citizens'),
          //         _buildSidebarItem(
          //             Assets.svgPeer, 'Peer Mentors', '/peer_mentors'),
          //         _buildSidebarItem(
          //             Assets.svgParole, 'Parole Officers', '/parole_officers'),
          //       ],
          //     );
          //   } else {
          //     return const SizedBox();
          //   }
          // }),
          BlocBuilder<AccountCubit, UserDto?>(builder: (context, state) {
            if (state?.accountType == AccountType.citizen) {
              return const SizedBox();
            }

            if (state?.accountType == AccountType.mentor ||
                state?.accountType == AccountType.officer) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Text(
                      "CARE TEAM",
                      style: context.textTheme.bodySmall!
                          .copyWith(fontSize: 11, color: AppColors.grey1),
                    ),
                  ),
                  _buildSidebarItem(
                      Assets.svgCitizens, 'Citizens', '/citizens'),
                ],
              );
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    "CARE TEAM",
                    style: context.textTheme.bodySmall!
                        .copyWith(fontSize: 11, color: AppColors.grey1),
                  ),
                ),
                _buildSidebarItem(Assets.svgCitizens, 'Citizens', '/citizens'),
                _buildSidebarItem(
                    Assets.svgPeer, 'Peer Mentors', '/peer_mentors'),
                _buildSidebarItem(
                    Assets.svgParole, 'Parole Officers', '/parole_officers'),
              ],
            );
          }),
          30.height,
          // _buildSidebarItem(Assets.svgChatBubble, 'Chat', '/chats'),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              "ACTIONS",
              style: context.textTheme.bodySmall!
                  .copyWith(fontSize: 11, color: AppColors.grey1),
            ),
          ),
          _buildSidebarItem(Assets.svgPeer, 'Goals', '/goals'),
          _buildSidebarItem(Assets.svgCalendar, 'Daily activities', '/activities'),
          30.height,

          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              "ANALYTICS",
              style: context.textTheme.bodySmall!
                  .copyWith(fontSize: 11, color: AppColors.grey1),
            ),
          ),
          _buildSidebarItem(Assets.svgPeer, 'Report', '/report'),
          _buildSidebarItem(Assets.svgCalendar, 'Support Ticket', '/support'),
          _buildSidebarItem(Assets.svgCalendar, 'Appointment', '/appointments'),
          30.height,

          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              "RESOURCES",
              style: context.textTheme.bodySmall!
                  .copyWith(fontSize: 11, color: AppColors.grey1),
            ),
          ),
          7.height,
          _buildSidebarItem(Assets.svgBlog, 'Blog', '/blog'),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              children: [
                _buildSidebarItem(Assets.svgSetting, 'Settings', '/settings'),
                _buildSidebarItem(Assets.svgLogout, 'Log Out', '/logout'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void closeApp(BuildContext context, void Function() callback) {
    AppAlertDialog.show(context,
        description: "Are you sure you want to logout?",
        title: "Logout?",
        action: "Logout", onClickAction: () {
      context.pop();
      callback();
    });
  }

  Widget _buildSidebarItem(String icon, String label, String route) {
    final isSelected =
        Beamer.of(context).currentConfiguration!.location == route;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          border: isSelected
              ? Border.all(
                  color: AppColors.gray2,
                  width: 1.0,
                )
              : null,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: InkWell(
          onTap: label == "Log Out"
              ? () {
                  closeApp(context, () {
                    context.read<AuthBloc>().add(LogoutEvent());
                  });
                }
              : () {
                  setState(() {
                    _selectedPage = route;
                  });
                  Beamer.of(context).beamToNamed(route);
                },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: SvgPicture.asset(icon),
              ),
              const SizedBox(width: 16),
              Text(
                label,
                style: context.textTheme.bodySmall
                    ?.copyWith(color: AppColors.greyWhite),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
