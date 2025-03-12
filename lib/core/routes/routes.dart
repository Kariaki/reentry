import 'package:reentry/ui/modules/activities/activity_screen.dart';
import 'package:reentry/ui/modules/activities/daily_progress_screen.dart';
import 'package:reentry/ui/modules/calender/calender_screen.dart';
import 'package:reentry/ui/modules/citizens/citizens_profile_screen.dart';
import 'package:reentry/ui/modules/clients/clients_screen.dart';
import 'package:reentry/ui/modules/goals/goals_screen.dart';

class NavigatorRoutes {
  final String name;
  final String path;
  const NavigatorRoutes({required this.name, required this.path});
}

class AppRoutes {
  static const goals = '/goals';
  static const clients = '/clients';
  static const progress = '/progress';
  static const dailyActions = '/dailyActions';
  static const calender = '/calender';
  static const activities = '/activities';
  // static const profileInfo = '/profileInfo';
  //onboard
  static const welcome = NavigatorRoutes(name: 'welcome', path: '/welcome');
  static const profileInfo =
      NavigatorRoutes(name: 'profile-info', path: '/profileInfo/:id');
  static const login = NavigatorRoutes(name: 'login', path: '/login');
   static const forgotPassword = NavigatorRoutes(name: 'forgotPassword', path: '/forgotPassword');
      static const passwordResetInfo = NavigatorRoutes(name: 'passwordResetInfo', path: '/passwordResetInfo');
  static const root = NavigatorRoutes(name: 'root', path: '/root');
  static const careTeamProfile =
      NavigatorRoutes(name: 'care-team-profile', path: 'careTeamProfile');
  static const basicInfo =
      NavigatorRoutes(name: 'basic-info', path: '/basicInfo');
  static const success = NavigatorRoutes(name: 'success', path: '/success');
  static const accountType =
      NavigatorRoutes(name: 'account-type', path: '/accountType');
      static const feeling =
      NavigatorRoutes(name: 'feeling', path: '/feeling');
  static const organizationInfo =
      NavigatorRoutes(name: 'organization-info', path: '/organizationInfo');
  static const organizationProfile =
      NavigatorRoutes(name: 'organization-profile', path: 'organizations/organizationProfile');
  static Map<String, dynamic> routes = {
    clients: ClientsScreen(),
    calender: CalenderScreen(),
    goals: GoalsScreen(),
    dailyActions: ActivityScreen(),
    progress: DailyProgressScreen(),
  };

  //admin screens

  static const dashboard =
      NavigatorRoutes(name: 'dashboard', path: '/dashboard');
  static const citizens = NavigatorRoutes(name: 'citizens', path: '/citizens');
  static const goal = NavigatorRoutes(name: 'goals', path: '/goals');
  static const activity = NavigatorRoutes(name: 'activities', path: '/activities');
  static const appointment = NavigatorRoutes(name: 'appointments', path: '/appointments');
  static const organization = NavigatorRoutes(name: 'organizations', path: '/organizations');
  static const conversation = NavigatorRoutes(name: 'conversations', path: '/conversations');
  static const blogs = NavigatorRoutes(name: 'blogs', path: '/blogs');
  static const citizenProfile =
      NavigatorRoutes(name: 'citizenProfile', path: 'citizens/profile');
        static const verifyCitizen =
      NavigatorRoutes(name: 'verifyCitizen', path: 'citizens/profile/verify');
  static const mentorProfile =
      NavigatorRoutes(name: 'mentorProfile', path: 'mentors/profile');
  static const officersProfile =
      NavigatorRoutes(name: 'officersProfile', path: 'officers/profile');
  static const mentors = NavigatorRoutes(name: 'mentors', path: '/mentors');
  static const officers = NavigatorRoutes(name: 'officers', path: '/officers');
  static const deleteAccount = NavigatorRoutes(name: 'delete', path: '/delete');
  static const reports = NavigatorRoutes(name: 'reports', path: '/reports');
  static const verificationQuestion = NavigatorRoutes(name: 'questions', path: '/questions');
  static const verificationRequest= NavigatorRoutes(name: 'requests', path: '/requests');
  static const viewReports = NavigatorRoutes(name: 'viewReports', path: '/reports/view');
  static const blog = NavigatorRoutes(name: 'blog', path: '/blog');
  static const createBlog =
      NavigatorRoutes(name: 'createBlog', path: '/blog/create');
  static const updateBlog =
      NavigatorRoutes(name: 'updateBlog', path: '/blog/update');
  static const blogDetails =
      NavigatorRoutes(name: 'blogDetails', path: '/blog/details');
  static const settings = NavigatorRoutes(name: 'settings', path: '/settings');
}
