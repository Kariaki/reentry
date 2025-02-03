import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/di/get_it.dart';
import 'package:reentry/ui/modules/activities/bloc/activity_bloc.dart';
import 'package:reentry/ui/modules/activities/bloc/activity_cubit.dart';
import 'package:reentry/ui/modules/admin/admin_stat_cubit.dart';
import 'package:reentry/ui/modules/appointment/appointment_graph/appointment_graph_cubit.dart';
import 'package:reentry/ui/modules/appointment/bloc/appointment_cubit.dart';
import 'package:reentry/ui/modules/authentication/bloc/account_cubit.dart';
import 'package:reentry/ui/modules/authentication/bloc/authentication_bloc.dart';
import 'package:reentry/ui/modules/authentication/bloc/onboarding_cubit.dart';
import 'package:reentry/ui/modules/blog/bloc/blog_bloc.dart';
import 'package:reentry/ui/modules/blog/bloc/blog_cubit.dart';
import 'package:reentry/ui/modules/citizens/bloc/citizen_profile_cubit.dart';
import 'package:reentry/ui/modules/clients/bloc/client_bloc.dart';
import 'package:reentry/ui/modules/clients/bloc/client_cubit.dart';
import 'package:reentry/ui/modules/clients/bloc/client_profile_cubit.dart';
import 'package:reentry/ui/modules/goals/bloc/goals_bloc.dart';
import 'package:reentry/ui/modules/goals/bloc/goals_cubit.dart';
import 'package:reentry/ui/modules/incidents/cubit/report_cubit.dart';
import 'package:reentry/ui/modules/messaging/bloc/conversation_cubit.dart';
import 'package:reentry/ui/modules/profile/bloc/profile_cubit.dart';
import 'package:reentry/ui/modules/root/cubit/feelings_cubit.dart';
import 'package:reentry/ui/modules/shared/cubit/admin_cubit.dart';
import 'package:reentry/ui/modules/shared/cubit/fetch_users_list_cubit.dart';
import 'package:reentry/ui/modules/splash/splash_screen.dart';
import 'core/routes/router.dart';
import 'domain/firebase_api.dart';

late final FirebaseApp app;
late final FirebaseAuth auth;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
// We're using the manual installation on non-web platforms since Google sign in plugin doesn't yet support Dart initialization.
// See related issue: https://github.com/flutter/flutter/issues/96391

  // final storage = await HydratedStorage.build(
  //   storageDirectory: HydratedStorage.webStorageDirectory,
  // );
  //
  // HydratedBloc.storage = storage;
// We store the app and auth to make testing with a named instance easier.
  setupDi();
  // final version = await fetchAppStoreVersion('com.lisbon.driver');
  // print('***** app version ${version}');

  final String appId;
  if (kIsWeb) {
    if (kDebugMode) {
      debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
    }
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
  if (!kIsWeb) {
    await FirebaseApi().init();
  }
  //await FirebaseApi().init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AuthBloc()),
          BlocProvider(create: (context) => AccountCubit()),
          BlocProvider(create: (context) => ProfileCubit()),
          BlocProvider(create: (context) => ProfileCubit()),
          BlocProvider(create: (context) => GoalCubit()),
          BlocProvider(create: (context) => ReportCubit()),
          BlocProvider(create: (context) => GoalsBloc()),
          // BlocProvider(create: (context) => MessageCubit()),
          BlocProvider(create: (context) => ConversationUsersCubit()),
          BlocProvider(create: (context) => UserAppointmentCubit()),
          BlocProvider(create: (context) => AppointmentCubit()),
          BlocProvider(create: (context) => ActivityBloc()),
          BlocProvider(create: (context) => ActivityCubit()),
          BlocProvider(create: (context) => OnboardingCubit()),
          BlocProvider(create: (context) => ClientBloc()),
          BlocProvider(create: (context) => BlogBloc()),
          BlocProvider(create: (context) => BlogCubit()),
          BlocProvider(create: (context) => AdminUsersCubit()),
          BlocProvider(create: (context) => ClientProfileCubit()),
          BlocProvider(create: (context) => FeelingsCubit()),
          BlocProvider(create: (context) => CitizenProfileCubit()),
          BlocProvider(create: (context) => AdminUserCubitNew()),
          BlocProvider(create: (context) => AdminStatCubit()),
          BlocProvider(create: (context) => AppointmentGraphCubit()),
          // BlocProvider(create: (context) => UserProfileCubit()),
          BlocProvider(create: (context) => ConversationCubit()),
          BlocProvider(create: (context) => ClientCubit()),
          BlocProvider(create: (context) => AdminCitizenCubit()),
          BlocProvider(create: (context) => FetchUserListCubit()),
          BlocProvider(create: (context) => RecommendedClientCubit()),
        ],
        child: kIsWeb
            ? MaterialApp.router(
                title: 'Sainte',
                debugShowCheckedModeBanner: false,
                themeAnimationDuration: const Duration(
                    seconds: 0, minutes: 0, milliseconds: 0, microseconds: 0),
                themeMode: ThemeMode.dark,
                darkTheme: ThemeData(
                    colorScheme:
                        ColorScheme.fromSeed(seedColor: AppColors.primary),
                    useMaterial3: true,
                    appBarTheme:
                        const AppBarTheme(backgroundColor: AppColors.black),
                    primaryColor: AppColors.primary,
                    bottomNavigationBarTheme:
                        const BottomNavigationBarThemeData(
                            backgroundColor: AppColors.black),
                    textTheme: const TextTheme(
                      bodyMedium:
                          TextStyle(color: AppColors.white, fontSize: 14),
                      displaySmall:
                          TextStyle(color: AppColors.white, fontSize: 12),
                      bodyLarge:
                          TextStyle(color: AppColors.white, fontSize: 16),
                      bodySmall:
                          TextStyle(color: AppColors.white, fontSize: 12),
                      titleLarge: TextStyle(
                          color: AppColors.primary,
                          fontSize: 40,
                          fontFamily: 'InterBold',
                          fontWeight: FontWeight.bold),
                      titleSmall: TextStyle(
                          color: AppColors.white,
                          fontSize: 18,
                          fontFamily: 'InterBold'),
                      titleMedium:
                          TextStyle(color: AppColors.white, fontSize: 20),
                    ),
                    fontFamily: 'Inter'),
                routeInformationParser: AppRouter.router.routeInformationParser,
                routeInformationProvider:
                    AppRouter.router.routeInformationProvider,
                routerDelegate: AppRouter.router.routerDelegate,
              )
            : MaterialApp(
                title: 'Sainte',
                debugShowCheckedModeBanner: false,
                themeMode: ThemeMode.dark,
                darkTheme: ThemeData(
                    colorScheme:
                        ColorScheme.fromSeed(seedColor: AppColors.primary),
                    useMaterial3: true,
                    appBarTheme:
                        const AppBarTheme(backgroundColor: AppColors.black),
                    primaryColor: AppColors.primary,
                    bottomNavigationBarTheme:
                        const BottomNavigationBarThemeData(
                            backgroundColor: AppColors.black),
                    textTheme: const TextTheme(
                      bodyMedium:
                          TextStyle(color: AppColors.white, fontSize: 14),
                      displaySmall:
                          TextStyle(color: AppColors.white, fontSize: 12),
                      bodyLarge:
                          TextStyle(color: AppColors.white, fontSize: 16),
                      bodySmall:
                          TextStyle(color: AppColors.white, fontSize: 12),
                      titleLarge: TextStyle(
                          color: AppColors.primary,
                          fontSize: 40,
                          fontFamily: 'InterBold',
                          fontWeight: FontWeight.bold),
                      titleSmall: TextStyle(
                          color: AppColors.white,
                          fontSize: 18,
                          fontFamily: 'InterBold'),
                      titleMedium:
                          TextStyle(color: AppColors.white, fontSize: 20),
                    ),
                    fontFamily: 'Inter'),
                home: const SplashScreen()));
  }
}
