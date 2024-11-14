import 'package:beamer/beamer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/beam_locations.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/di/get_it.dart';
import 'package:reentry/ui/components/web_sidebar_layout.dart';
import 'package:reentry/ui/modules/activities/bloc/activity_bloc.dart';
import 'package:reentry/ui/modules/activities/bloc/activity_cubit.dart';
import 'package:reentry/ui/modules/appointment/bloc/appointment_cubit.dart';
import 'package:reentry/ui/modules/authentication/bloc/account_cubit.dart';
import 'package:reentry/ui/modules/authentication/bloc/authentication_bloc.dart';
import 'package:reentry/ui/modules/authentication/login_screen.dart';
import 'package:reentry/ui/modules/clients/bloc/client_bloc.dart';
import 'package:reentry/ui/modules/clients/bloc/client_cubit.dart';
import 'package:reentry/ui/modules/clients/bloc/client_profile_cubit.dart';
import 'package:reentry/ui/modules/goals/bloc/goals_bloc.dart';
import 'package:reentry/ui/modules/goals/bloc/goals_cubit.dart';
import 'package:reentry/ui/modules/messaging/bloc/conversation_cubit.dart';
import 'package:reentry/ui/modules/messaging/bloc/message_cubit.dart';
import 'package:reentry/ui/modules/profile/bloc/profile_cubit.dart';
import 'package:reentry/ui/modules/shared/cubit/admin_cubit.dart';
import 'package:reentry/ui/modules/shared/cubit/fetch_users_list_cubit.dart';
import 'package:reentry/ui/modules/splash/splash_screen.dart';
import 'package:reentry/ui/modules/splash/web_splash_screen.dart';

late final FirebaseApp app;
late final FirebaseAuth auth;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
// We're using the manual installation on non-web platforms since Google sign in plugin doesn't yet support Dart initialization.
// See related issue: https://github.com/flutter/flutter/issues/96391

// We store the app and auth to make testing with a named instance easier.
  setupDi();

  final String appId;
  if (kIsWeb) {
    appId = "1:277362543199:web:d6bcb8bb4b147dd9a1e9ea";
  } else if (defaultTargetPlatform == TargetPlatform.android) {
    appId = "1:277362543199:android:cd75ae50fc9db899a1e9ea";
  } else if (defaultTargetPlatform == TargetPlatform.iOS) {
    appId = "1:277362543199:ios:fea6efa1fc70396da1e9ea";
  } else {
    throw UnsupportedError("This platform is not supported");
  }

  app = await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyDaLHkABOMmrDWZ4qhydqqoQX08XKXP_Zo",
        authDomain: "trs-app-13c75.firebaseapp.com",
        projectId: "trs-app-13c75",
        storageBucket: "trs-app-13c75.appspot.com",
        messagingSenderId: "277362543199",
        // appId: Platform.isAndroid
        //     ? "1:277362543199:android:cd75ae50fc9db899a1e9ea"
        //     : "1:277362543199:ios:9375181851d87c27a1e9ea",
        appId: appId,
        measurementId: "G-DFNJ45R5R9"),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
     final routerDelegate = kIsWeb ? webRouterDelegate : mobileRouterDelegate;
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AuthBloc()),
          BlocProvider(create: (context) => AccountCubit()),
          BlocProvider(create: (context) => ProfileCubit()),
          BlocProvider(
              create: (context) => GoalCubit()
                ..fetchGoals()
                ..fetchHistory()),
          BlocProvider(create: (context) => GoalsBloc()),
         // BlocProvider(create: (context) => MessageCubit()),
          BlocProvider(create: (context) => ConversationUsersCubit()),
          BlocProvider(create: (context) => UserAppointmentCubit()),
          BlocProvider(create: (context) => AppointmentCubit()),
          BlocProvider(create: (context) => ActivityBloc()),
          BlocProvider(create: (context) => ActivityCubit()),
          BlocProvider(create: (context) => ClientBloc()),
          BlocProvider(create: (context) => AdminUsersCubit()),
          // BlocProvider(create: (context) => UserProfileCubit()),
          BlocProvider(
              create: (context) =>
                  ConversationCubit()),
          BlocProvider(create: (context) => ClientCubit()),
          BlocProvider(create: (context) => AdminCitizenCubit()),
          BlocProvider(create: (context) => ClientProfileCubit()),
           BlocProvider(create: (context) => FetchUserListCubit()),
          BlocProvider(create: (context) => RecommendedClientCubit()),
        ],
        child: MaterialApp.router(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.dark,
          darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
              useMaterial3: true,
              appBarTheme: const AppBarTheme(backgroundColor: AppColors.black),
              primaryColor: AppColors.primary,
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                  backgroundColor: AppColors.black),
              textTheme: const TextTheme(
                bodyMedium: TextStyle(color: AppColors.white, fontSize: 14),
                displaySmall: TextStyle(color: AppColors.white, fontSize: 12),
                bodyLarge: TextStyle(color: AppColors.white, fontSize: 16),
                bodySmall: TextStyle(color: AppColors.white, fontSize: 12),
                titleLarge: TextStyle(
                    color: AppColors.primary,
                    fontSize: 40,
                    fontFamily: 'InterBold',
                    fontWeight: FontWeight.bold),
                headlineLarge: TextStyle(
                    color: AppColors.primary,
                    fontSize: 36,
                    fontFamily: 'InterBold',
                    fontWeight: FontWeight.bold),
                titleSmall: TextStyle(
                    color: AppColors.white,
                    fontSize: 18,
                    fontFamily: 'InterBold'),
                titleMedium: TextStyle(color: AppColors.white, fontSize: 20),
              ),
              fontFamily: 'Inter'),
          // home: kIsWeb ? const WebSideBarLayout() : const SplashScreen(),
          routerDelegate: routerDelegate,
      routeInformationParser: BeamerParser(),
        ));
  }
}


final webRouterDelegate = BeamerDelegate(
  initialPath: '/',
  locationBuilder: BeamerLocationBuilder(
    beamLocations: [
      LoginLocation(),
      DashboardLocation(),
      CitizensLocation(),
      PeerMentorsLocation(),
      OfficersLocation(),
      AppointmentLocation(),
      CalendarLocation(),
      BlogLocation(),
      AddResourcesLocation()
    ],
  ).call,
);


final mobileRouterDelegate = BeamerDelegate(
  initialPath: '/splash',
  locationBuilder: BeamerLocationBuilder(
    beamLocations: [
      SplashLocation(),
    ],
  ).call,
);