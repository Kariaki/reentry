import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:reentry/data/enum/account_type.dart';
import 'package:reentry/ui/components/web_sidebar_layout.dart';
import 'package:reentry/ui/modules/admin/dashboard.dart';
import 'package:reentry/ui/modules/appointment/web/appointment_screen.dart';
import 'package:reentry/ui/modules/authentication/login_screen.dart';
import 'package:reentry/ui/modules/blog/web/add_resources.dart';
import 'package:reentry/ui/modules/blog/web/blog_details.dart';
import 'package:reentry/ui/modules/blog/web/blog_screen.dart';
import 'package:reentry/ui/modules/calender/web/calendar_screen.dart';
import 'package:reentry/ui/modules/citizens/citizens_profile_screen.dart';
import 'package:reentry/ui/modules/citizens/citizens_screen.dart';
import 'package:reentry/ui/modules/mentor/web/mentors_profile_screen.dart';
import 'package:reentry/ui/modules/officers/officers_profile_screen.dart';
import 'package:reentry/ui/modules/officers/officers_screen.dart';
import 'package:reentry/ui/modules/report/web/report_screen.dart';
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
        const BeamPage(
          key: ValueKey('report'),
          title: 'Report',
          child: WebSideBarLayout(
            child: ReportPage(),
          ),
        ),
      ];

  @override
  List<String> get pathPatterns => ['/report'];
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
        const BeamPage(
          key: ValueKey('settings'),
          title: 'Settings',
          child: WebSideBarLayout(
            child: SettingsPage(),
          ),
        ),
      ];

  @override
  List<String> get pathPatterns => ['/settings'];
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

class BlogLocation extends BeamLocation<BeamState> {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      const BeamPage(
        key: ValueKey('blog'),
        title: 'Blog',
        child: WebSideBarLayout(
          child: BlogPage(),
        ),
      )
    ];
  }

  @override
  List<String> get pathPatterns => [
        '/blog',
      ];
}

class BlogDetailsLocation extends BeamLocation<BeamState> {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final blog = {
      'title': state.queryParameters['title'] ?? '',
      'content': state.queryParameters['content'] ?? '',
      'imageUrl': state.queryParameters['imageUrl'] ?? '',
      'author': state.queryParameters['author'] ?? '',
      // 'date': state.queryParameters['date'] ?? '',
    };

    return [
      BeamPage(
        key: const ValueKey('blog-details'),
        title: blog['title'] ?? 'Blog Details',
        child: WebSideBarLayout(
          child: BlogDetailsPage(
            blog: blog,
          ),
        ),
      ),
    ];
  }

  @override
  List<String> get pathPatterns => [
        '/blog/details',
      ];
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
  List<String> get pathPatterns => ['/splash'];
}
