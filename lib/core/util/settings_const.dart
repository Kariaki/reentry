import 'package:flutter/material.dart';
import 'package:reentry/ui/modules/profile/profile_screen.dart';
import 'package:reentry/ui/modules/report/select_report_user_screen.dart';
import 'package:reentry/ui/modules/root/navigations/settings_navigation_screen.dart';
import 'package:reentry/ui/modules/support/support_ticket_screen.dart';

import '../../ui/modules/settings/mobile/delete_account_screen.dart';
import '../../ui/modules/settings/mobile/mobile_settings.dart';

class SettingsConstants {
  static final settingsItem1 = [
    const SettingsItemEntity(
        title: 'Profile', icon: Icons.person, route: profileRouteName),
    const SettingsItemEntity(
        title: 'Notification',
        icon: Icons.notification_important_sharp,
        route: notificationRouteName),
  ];
  static final settingsItem2 = [
    const SettingsItemEntity(
        title: 'Report an incident',
        icon: Icons.star_border_purple500,
        route: reportRouteName),
    const SettingsItemEntity(
        title: 'Support',
        icon: Icons.info_outline_rounded,
        route: supportRouteName),    const SettingsItemEntity(
        title: 'Delete Account',
        icon: Icons.delete_outline_rounded,
        route: deleteAccountRouteName),
  ];
  static final settingsRoutes = {
    profileRouteName: const ProfileScreen(),
    reportRouteName: SelectReportUserScreen(),
    supportRouteName: SupportTicketScreen(),
    notificationRouteName: NotificationSettings(),
    deleteAccountRouteName: DeleteAccountScreen(),
  };
  static const profileRouteName = 'profile';
  static const notificationRouteName = 'notification';
  static const reportRouteName = 'report_incident';
  static const deleteAccountRouteName = 'delete_account';
  static const supportRouteName = 'support';
}
