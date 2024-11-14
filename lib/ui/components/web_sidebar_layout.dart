// ignore_for_file: library_private_types_in_public_api

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/generated/assets.dart';
import 'package:reentry/ui/modules/citizens/citizens_profile_screen.dart';
import 'package:reentry/ui/modules/citizens/citizens_screen.dart';

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
      key: _scaffoldKey,
      drawer: Drawer(
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
                          const SizedBox(width: 8),
                          SvgPicture.asset(Assets.svgNotification),
                        ],
                      ),
                    ),
                    Expanded(
                      child: widget.child
                    ),
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
    return Column(
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
          child: Row(
            children: [
              const CircleAvatar(
                radius: 20,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Jane Dow', style: context.textTheme.bodyMedium),
                    Text(
                      'jane.dow@example.com',
                      style: context.textTheme.bodyMedium!
                          .copyWith(fontSize: 11, color: AppColors.grey1),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        _buildSidebarItem(Assets.svgDashbaord, 'Dashboard', '/dashbaord'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text("CARE TEAM",
              style: context.textTheme.bodySmall!
                  .copyWith(fontSize: 11, color: AppColors.grey1)),
        ),
        _buildSidebarItem(Assets.svgCitizens, 'Citizens', '/citizens'),
        _buildSidebarItem(Assets.svgPeer, 'Peer Mentors', '/peer_mentors'),
        _buildSidebarItem(
            Assets.svgParole, 'Parole Officers', '/parole_officers'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text("ANALYTICS",
              style: context.textTheme.bodySmall!
                  .copyWith(fontSize: 11, color: AppColors.grey1)),
        ),
        _buildSidebarItem(Assets.svgPeer, 'Appointments', '/appointments'),
        _buildSidebarItem(Assets.svgCalendar, 'Calendar', '/calendar'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text("RESOURCES",
              style: context.textTheme.bodySmall!
                  .copyWith(fontSize: 11, color: AppColors.grey1)),
        ),
        _buildSidebarItem(Assets.svgBlog, 'Blog', '/blog'),
        const Spacer(),
        _buildSidebarItem(Assets.svgSetting, 'Settings', '/settings'),
        _buildSidebarItem(Assets.svgLogout, 'Log Out', '/logout'),
      ],
    );
  }

  Widget _buildSidebarItem(String icon, String label, String route) {
    final isSelected =
        Beamer.of(context).currentConfiguration!.location == route;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          border: isSelected
              ? Border.all(
                  color: AppColors.gray2,
                  width: 1.0,
                )
              : null,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          leading: SvgPicture.asset(icon),
          title: Text(label,
              style: context.textTheme.bodySmall
                  ?.copyWith(color: AppColors.greyWhite)),
          selected: _selectedPage == route,
          // selectedTileColor:
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          onTap: () {
            setState(() {
              _selectedPage = route;
            });
            Beamer.of(context).beamToNamed(route);
          },
        ),
      ),
    );
  }
}