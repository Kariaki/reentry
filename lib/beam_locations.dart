import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:reentry/data/enum/account_type.dart';
import 'package:reentry/data/model/client_dto.dart';
import 'package:reentry/data/model/user_dto.dart';
import 'package:reentry/ui/components/web_sidebar_layout.dart';
import 'package:reentry/ui/modules/activities/web/create_activity_screen.dart';
import 'package:reentry/ui/modules/activities/web/web_activity_screen.dart';
import 'package:reentry/ui/modules/admin/dashboard.dart';
import 'package:reentry/ui/modules/appointment/web/appointment_screen.dart';
import 'package:reentry/ui/modules/authentication/login_screen.dart';
import 'package:reentry/ui/modules/authentication/signin_options.dart';
import 'package:reentry/ui/modules/blog/web/add_resources.dart';
import 'package:reentry/ui/modules/blog/web/blog_details.dart';
import 'package:reentry/ui/modules/blog/web/blog_screen.dart';
import 'package:reentry/ui/modules/calender/web/calendar_screen.dart';
import 'package:reentry/ui/modules/citizens/citizens_profile_screen.dart';
import 'package:reentry/ui/modules/citizens/citizens_screen.dart';
import 'package:reentry/ui/modules/goals/web/web_create_goal_screen.dart';
import 'package:reentry/ui/modules/goals/web/web_goals_screen.dart';
import 'package:reentry/ui/modules/mentor/web/mentors_profile_screen.dart';
import 'package:reentry/ui/modules/messaging/web/web_chat.dart';
import 'package:reentry/ui/modules/officers/officers_profile_screen.dart';
import 'package:reentry/ui/modules/officers/officers_screen.dart';
import 'package:reentry/ui/modules/report/web/report_screen.dart';
import 'package:reentry/ui/modules/report/web/view_report_screen.dart';
import 'package:reentry/ui/modules/settings/web/settings_screen.dart';
import 'package:reentry/ui/modules/splash/splash_screen.dart';
import 'package:reentry/ui/modules/support/web/support_screen.dart';

class DashboardLocation extends BeamLocation<BeamState> {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
        const BeamPage(
          key: ValueKey('dashboard'),
          title: 'Dashboard',
          child: WebSideBarLayout(
            child: DashboardPage(),
          ),
        ),
      ];

  @override
  List<String> get pathPatterns => ['/dashbaord'];
}

class AppointmentLocation extends BeamLocation<BeamState> {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
        const BeamPage(
          key: ValueKey('appointments'),
          title: 'Appointments',
          child: WebSideBarLayout(
            child: AppointmentPage(),
          ),
        ),
      ];

  @override
  List<String> get pathPatterns => ['/appointments'];
}

class ReportLocation extends BeamLocation<BeamState> {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
        BeamPage(
          key: const ValueKey('report'),
          title: 'Report',
          child: WebSideBarLayout(
            child: ViewReportPage(),
          ),
        ),
      ];

  @override
  List<String> get pathPatterns => ['/report'];
}

class GoalsLocation extends BeamLocation<BeamState> {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final uri = Uri.parse(state.uri.path);
    return [
      const BeamPage(
        key: const ValueKey('goals'),
        title: 'Goals',
        child: WebSideBarLayout(
          child: WebGoalsPage(),
        ),
      ),
      if (uri.pathSegments.contains('create'))
        const BeamPage(
          key: ValueKey('create_goals'),
          title: 'Create Goals',
          child: WebSideBarLayout(
            child: CreateGoalPage(),
          ),
        ),
    ];
  }

  @override
  List<String> get pathPatterns => [
        '/goals',
        '/goals/create',
      ];
}

class ActivitiesLocation extends BeamLocation<BeamState> {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final uri = Uri.parse(state.uri.path);

    return [
      const BeamPage(
        key: ValueKey('activities'),
        title: 'Daily activities',
        child: WebSideBarLayout(
          child: AcitivityPage(),
        ),
      ),
      if (uri.pathSegments.contains('create'))
        const BeamPage(
          key: ValueKey('create_activities'),
          title: 'Create Activity',
          child: WebSideBarLayout(
            child: CreateAcitivityPage(),
          ),
        ),
    ];
  }

  @override
  List<String> get pathPatterns => [
        '/activities',
        '/activities/create',
      ];
}

class SupportLocation extends BeamLocation<BeamState> {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
        const BeamPage(
          key: ValueKey('support'),
          title: 'Support',
          child: WebSideBarLayout(
            child: SupportPage(),
          ),
        ),
      ];

  @override
  List<String> get pathPatterns => ['/support'];
}

class SettingsLocation extends BeamLocation<BeamState> {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
        BeamPage(
          key: const ValueKey('settings'),
          title: 'Settings',
          child: WebSideBarLayout(
            child: SettingsPage(),
          ),
        ),
      ];

  @override
  List<String> get pathPatterns => ['/settings'];
}

class ChatLocation extends BeamLocation<BeamState> {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
        BeamPage(
          key: const ValueKey('chat'),
          title: 'Chat',
          child: WebSideBarLayout(
            child: WebChatPage(
              currentUser: UserDto(
                userId: '1',
                accountType: AccountType.mentor,
                name: 'Phoenix Baker',
                avatar: 'https://www.example.com/path/to/phoenix_baker.jpg',
              ),
              chatPartner: ClientDto(
                  id: '1',
                  name: 'Phoenix Baker',
                  avatar: 'https://www.example.com/path/to/phoenix_baker.jpg',
                  status: ClientStatus.active,
                  createdAt: DateTime.now()
                      .subtract(Duration(days: 30))
                      .millisecondsSinceEpoch,
                  updatedAt: DateTime.now().millisecondsSinceEpoch),
            ),
          ),
        ),
      ];

  @override
  List<String> get pathPatterns => ['/chats'];
}

class CalendarLocation extends BeamLocation<BeamState> {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
        const BeamPage(
          key: ValueKey('calendar'),
          title: 'Calendar',
          child: WebSideBarLayout(
            child: CalendarPage(),
          ),
        ),
      ];

  @override
  List<String> get pathPatterns => ['/calendar'];
}

class AddResourcesLocation extends BeamLocation<BeamState> {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      const BeamPage(
        key: ValueKey('create-blog'),
        title: 'Create Blog',
        child: WebSideBarLayout(
          child: AddResourcesPage(),
        ),
      ),
    ];
  }

  @override
  List<String> get pathPatterns => ['/blog/create'];
}

class LoginLocation extends BeamLocation<BeamState> {
  @override
  List<String> get pathPatterns => ['/login'];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
        const BeamPage(
          key: ValueKey('login'),
          title: 'Login',
          child: LoginScreen(),
        ),
      ];
}

class CitizensLocation extends BeamLocation<BeamState> {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final id = state.pathParameters['id'];

    return [
      const BeamPage(
        key: ValueKey('citizens'),
        title: 'Citizens',
        child: WebSideBarLayout(
          child: CitizensScreen(),
        ),
      ),
      if (id != null)
        BeamPage(
          key: ValueKey('citizen-profile-$id'),
          title: 'Citizen Profile',
          child: WebSideBarLayout(
            child: CitizenProfileScreen(id: id),
          ),
        ),
    ];
  }

  @override
  List<String> get pathPatterns => [
        '/citizens',
        '/citizens/:id',
      ];
}

class PeerMentorsLocation extends BeamLocation<BeamState> {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final mentorId = state.pathParameters['mentorId'];

    return [
      const BeamPage(
        key: ValueKey('peer_mentors'),
        title: 'Peer Mentors',
        child: WebSideBarLayout(
          child: NoncitizensScreen(accountType: AccountType.mentor),
        ),
      ),
      if (mentorId != null)
        BeamPage(
          key: ValueKey('mentor_profile_$mentorId'),
          title: 'Mentor Profile',
          child: WebSideBarLayout(
            child: MentorProfileScreen(mentorId: mentorId),
          ),
        ),
    ];
  }

  @override
  List<String> get pathPatterns =>
      ['/peer_mentors', '/peer_mentors/profile/:mentorId'];
}

class BlogLocation extends BeamLocation<BeamState> {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final blogId = state.pathParameters['blogId'];
    final editBlogId = state.pathParameters['editBlogId'];

    return [
      const BeamPage(
        key: ValueKey('blog'),
        title: 'Blog',
        child: WebSideBarLayout(
          child: BlogPage(),
        ),
      ),
      if (blogId != null)
        BeamPage(
          key: ValueKey('blog_details_$blogId'),
          title: 'Blog Details',
          child: WebSideBarLayout(
            child: BlogDetailsPage(blogId: blogId),
          ),
        ),
      if (editBlogId != null)
        BeamPage(
          key: ValueKey('edit_blog_$editBlogId'),
          title: 'Edit Blog',
          child: WebSideBarLayout(
            child: AddResourcesPage(editBlogId: editBlogId),
          ),
        ),
    ];
  }

  @override
  List<String> get pathPatterns =>
      ['/blog', '/blog/details/:blogId', '/blog/edit/:editBlogId'];
}

class OfficersLocation extends BeamLocation<BeamState> {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final officerId = state.pathParameters['officerId'];
    return [
      const BeamPage(
        key: ValueKey('parole_officers'),
        title: 'Parole Officers',
        child: WebSideBarLayout(
          child: NoncitizensScreen(accountType: AccountType.mentor),
        ),
      ),
      if (officerId != null)
        BeamPage(
          key: ValueKey('parole_officers_$officerId'),
          title: 'Parole Officers',
          child: WebSideBarLayout(
            child: OfficersProfileScreen(officerId: officerId),
          ),
        ),
    ];
  }

  @override
  List<String> get pathPatterns =>
      ['/parole_officers', '/parole_officers/profile/:officerId'];
}

class SplashLocation extends BeamLocation<BeamState> {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
        const BeamPage(
          key: ValueKey('splash'),
          title: 'Splash',
          child: SplashScreen(),
        ),
      ];

  @override
  List<String> get pathPatterns => ['/'];
}

class SignInOptionsLocation extends BeamLocation<BeamState> {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
        const BeamPage(
          key: ValueKey('welcome'),
          title: 'Welcome',
          child: SignInOptionsScreen(),
        ),
      ];

  @override
  List<String> get pathPatterns => ['/welcome'];
}
