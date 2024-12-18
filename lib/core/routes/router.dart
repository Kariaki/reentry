import 'package:go_router/go_router.dart';
import 'package:reentry/core/routes/routes.dart';
import 'package:reentry/ui/modules/authentication/account_type_screen.dart';
import 'package:reentry/ui/modules/authentication/basic_info_screen.dart';
import 'package:reentry/ui/modules/authentication/bloc/authentication_state.dart';
import 'package:reentry/ui/modules/authentication/peer_mentor_organization_info_screen.dart';
import 'package:reentry/ui/modules/citizens/citizens_profile_screen.dart';
import 'package:reentry/ui/modules/root/web/web_root.dart';
import 'package:reentry/ui/modules/splash/web_splash_screen.dart';

import '../../ui/modules/authentication/login_screen.dart';

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
          return NoTransitionPage(child: CitizenProfileScreen(id: id!));
        },
      ),
      GoRoute(
          path: AppRoutes.root.path,
          name: AppRoutes.root.name,
          pageBuilder: (context, state) {
            return const NoTransitionPage(child: Webroot());
          },
          routes: [

            GoRoute(
              path: AppRoutes.citizenProfile.path,
              name: AppRoutes.citizenProfile.name,
              pageBuilder: (context, state) {
                final citizenId = state.extra as String?;
                return NoTransitionPage(child: CitizenProfileScreen(id: citizenId??'',));
              },
            ),
          ])
    ],
  );
}
