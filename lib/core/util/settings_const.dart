import 'package:flutter/material.dart';
import 'package:reentry/ui/modules/profile/profile_screen.dart';
import 'package:reentry/ui/modules/report/select_report_user_screen.dart';
import 'package:reentry/ui/modules/root/navigations/settings_navigation_screen.dart';
import 'package:reentry/ui/modules/support/support_ticket_screen.dart';

class SettingsConstants {
  static final settingsItem1 = [
    const SettingsItemEntity(
        title: 'Profile', icon: Icons.person, route: profileRouteName),
    SettingsItemEntity(
        title: 'Notification',
        icon: Icons.notification_important_sharp,
        route: notificationRouteName),
  ];
  static final settingsItem2 = [
    const SettingsItemEntity(
        title: 'Report an incident',
        icon: Icons.star_border_purple500,
        route: reportRouteName),
    SettingsItemEntity(
        title: 'Support',
        icon: Icons.info_outline_rounded,
        route: supportRouteName),
  ];
  static final settingsRoutes = {
    profileRouteName: ProfileScreen(),
    reportRouteName: SelectReportUserScreen(),
    supportRouteName: SupportTicketScreen()
  };
  static const profileRouteName = 'profile';
  static const notificationRouteName = 'notification';
  static const reportRouteName = 'report_incident';
  static const supportRouteName = 'support';
}
