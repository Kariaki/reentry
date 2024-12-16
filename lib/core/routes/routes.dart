import 'package:reentry/ui/modules/activities/activity_screen.dart';
import 'package:reentry/ui/modules/activities/daily_progress_screen.dart';
import 'package:reentry/ui/modules/calender/calender_screen.dart';
import 'package:reentry/ui/modules/citizens/citizens_profile_screen.dart';
import 'package:reentry/ui/modules/clients/clients_screen.dart';
import 'package:reentry/ui/modules/goals/goals_screen.dart';

class NavigatorRoutes{
  final String name;
  final String path;
  const NavigatorRoutes({required this.name,required this.path});
}
class AppRoutes {
  static const goals = '/goals';
  static const clients = '/clients';
  static const progress = '/progress';
  static const dailyActions = '/dailyActions';
  static const calender = '/calender';
  static const activities = '/activities';
  // static const profileInfo = '/profileInfo';
  static const profileInfo = NavigatorRoutes(name: 'profile-info', path: '/profileInfo/:id');
  static const login = NavigatorRoutes(name: 'login', path: '/login');
  static const root = NavigatorRoutes(name: 'root', path: '/root');
  static const basicInfo = NavigatorRoutes(name: 'basic-info', path: '/basicInfo');
  static const accountType = NavigatorRoutes(name: 'account-type', path: '/accountType');
  static const organizationInfo = NavigatorRoutes(name: 'organization-info', path: '/organizationInfo');
  static Map<String, dynamic> routes = {
    clients: ClientsScreen(),
    calender: CalenderScreen(),
    goals: GoalsScreen(),
    dailyActions: ActivityScreen(),
    progress: DailyProgressScreen(),
  };
}
