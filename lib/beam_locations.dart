import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:reentry/ui/components/web_sidebar_layout.dart';
import 'package:reentry/ui/modules/admin/dashboard.dart';
import 'package:reentry/ui/modules/appointment/web/appointment_screen.dart';
import 'package:reentry/ui/modules/authentication/login_screen.dart';
import 'package:reentry/ui/modules/blog/web/blog_screen.dart';
import 'package:reentry/ui/modules/calender/web/calendar_screen.dart';
import 'package:reentry/ui/modules/citizens/citizens_profile_screen.dart';
import 'package:reentry/ui/modules/citizens/citizens_screen.dart';
import 'package:reentry/ui/modules/mentor/web/peer_mentors.dart';
import 'package:reentry/ui/modules/officers/officers_screen.dart';
import 'package:reentry/ui/modules/splash/splash_screen.dart';

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
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
        const BeamPage(
          key: ValueKey('blog'),
          title: 'Blog',
          child: WebSideBarLayout(
            child: BlogPage(),
          ),
        ),
      ];

  @override
  List<String> get pathPatterns => ['/blog'];
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
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
        const BeamPage(
          key: ValueKey('peer_mentors'),
          title: 'Peer Mentors',
          child: WebSideBarLayout(
            child: PeerMentorScreen(),
          ),
        ),
      ];

  @override
  List<String> get pathPatterns => ['/peer_mentors'];
}

class OfficersLocation extends BeamLocation<BeamState> {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
        const BeamPage(
          key: ValueKey('officers'),
          title: 'Officers',
          child: WebSideBarLayout(
            child: OfficersScreen(),
          ),
        ),
      ];

  @override
  List<String> get pathPatterns => ['/parole_officers'];
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
