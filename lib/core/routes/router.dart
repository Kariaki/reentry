import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:reentry/core/routes/routes.dart';
import 'package:reentry/data/model/user_dto.dart';
import 'package:reentry/ui/modules/authentication/account_type_screen.dart';
import 'package:reentry/ui/modules/authentication/basic_info_screen.dart';
import 'package:reentry/ui/modules/authentication/bloc/authentication_state.dart';
import 'package:reentry/ui/modules/authentication/peer_mentor_organization_info_screen.dart';
import 'package:reentry/ui/modules/blog/web/blog_details.dart';
import 'package:reentry/ui/modules/citizens/citizens_profile_screen.dart';
import 'package:reentry/ui/modules/root/web/web_root.dart';
import 'package:reentry/ui/modules/splash/web_splash_screen.dart';

import '../../data/enum/account_type.dart';
import '../../ui/modules/admin/dashboard.dart';
import '../../ui/modules/authentication/login_screen.dart';
import '../../ui/modules/blog/web/add_resources.dart';
import '../../ui/modules/blog/web/blog_screen.dart';
import '../../ui/modules/citizens/citizens_screen.dart';
import '../../ui/modules/mentor/web/mentors_profile_screen.dart';
import '../../ui/modules/officers/officers_screen.dart';
import '../../ui/modules/report/web/view_report_screen.dart';
import '../../ui/modules/settings/web/settings_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: AppRoutes.login.path,
        name: AppRoutes.login.name,
        pageBuilder: (context, state) {
          return NoTransitionPage(child: LoginScreen());
        },
      ),
      GoRoute(
        path: '/',
        name: 'splash',
        pageBuilder: (context, state) {
          return NoTransitionPage(child: WebSplashScreen());
        },
      ),
      GoRoute(
        path: AppRoutes.basicInfo.path,
        name: AppRoutes.basicInfo.name,
        pageBuilder: (context, state) {
          return NoTransitionPage(child: BasicInfoScreen());
        },
      ),
      GoRoute(
        path: AppRoutes.accountType.path,
        name: AppRoutes.accountType.name,
        pageBuilder: (context, state) {
          return NoTransitionPage(child: AccountTypeScreen());
        },
      ),
      GoRoute(
        path: AppRoutes.organizationInfo.path,
        name: AppRoutes.organizationInfo.name,
        pageBuilder: (context, state) {
          return NoTransitionPage(child: PeerMentorOrganizationInfoScreen());
        },
      ),
      GoRoute(
        path: AppRoutes.profileInfo.path,
        name: AppRoutes.profileInfo.name,
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'];
          return NoTransitionPage(child: SizedBox());
        },
      ),
      StatefulShellRoute.indexedStack(
          builder: (context, state, child) => Webroot(
                child: child,
              ),
          branches: [
            StatefulShellBranch(routes: [
              GoRoute(
                  path: AppRoutes.dashboard.path,
                  name: AppRoutes.dashboard.name,
                  builder: (context, state) => DashboardPage())
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                  path: AppRoutes.citizens.path,
                  name: AppRoutes.citizens.name,
                  builder: (context, state) => CitizensScreen(),
                  routes: [
                    GoRoute(
                      path: AppRoutes.citizenProfile.path,
                      name: AppRoutes.citizenProfile.name,
                      pageBuilder: (context, state) {
                        return const NoTransitionPage(
                            child: CitizenProfileScreen());
                      },
                    ),
                  ]),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                  path: AppRoutes.mentors.path,
                  name: AppRoutes.mentors.name,
                  builder: (context, state) =>
                      const CareTeamScreen(accountType: AccountType.mentor),
                  routes: [
                    GoRoute(
                        path: AppRoutes.mentorProfile.path,
                        name: AppRoutes.mentorProfile.name,
                        builder: (context, state) {
                          final id = state.extra as String?;

                          return CareTeamProfileScreen(
                            id: id,
                          );
                        })
                  ])
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                  path: AppRoutes.officers.path,
                  name: AppRoutes.officers.name,
                  builder: (context, state) =>
                      const CareTeamScreen(accountType: AccountType.officer),
                  routes: [
                    GoRoute(
                        path: AppRoutes.officersProfile.path,
                        name: AppRoutes.officersProfile.name,
                        builder: (context, state) {
                          final id = state.extra as String?;
                          return CareTeamProfileScreen(
                            id: id,
                          );
                        })
                  ])
            ]),


            StatefulShellBranch(routes: [
              GoRoute(
                  path: AppRoutes.viewReports.path,
                  name: AppRoutes.viewReports.name,
                  builder: (context, state) => ViewReportPage())
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                  path: AppRoutes.blog.path,
                  name: AppRoutes.blog.name,
                  builder: (context, state) => BlogPage(),
                  routes: [
                    GoRoute(
                      path: AppRoutes.createBlog.path,
                      name: AppRoutes.createBlog.name,
                      pageBuilder: (context, state) {
                        return const NoTransitionPage(
                            child: AddResourcesPage());
                      },
                    ),
                    GoRoute(
                      path: AppRoutes.updateBlog.path,
                      name: AppRoutes.updateBlog.name,
                      pageBuilder: (context, state) {
                        final data = state.extra as UpdateBlogEntity;
                        return  NoTransitionPage(
                            child: AddResourcesPage(
                              editBlogId: data.editBlogId,
                              blog: data.blog,
                            ));
                      },
                    ),
                    GoRoute(
                      path: AppRoutes.blogDetails.path,
                      name: AppRoutes.blogDetails.name,
                      pageBuilder: (context, state) {
                        final data = state.extra as String;
                        return  NoTransitionPage(
                            child: BlogDetailsPage(
                              blogId: data,
                            ));
                      },
                    ),
                  ])
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                  path: AppRoutes.settings.path,
                  name: AppRoutes.settings.name,
                  builder: (context, state) => SettingsPage())
            ]),
          ])
    ],
  );
}
