import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/di/get_it.dart';
import 'package:reentry/ui/modules/appointment/bloc/appointment_cubit.dart';
import 'package:reentry/ui/modules/authentication/bloc/account_cubit.dart';
import 'package:reentry/ui/modules/authentication/bloc/authentication_bloc.dart';
import 'package:reentry/ui/modules/clients/bloc/client_bloc.dart';
import 'package:reentry/ui/modules/clients/bloc/client_cubit.dart';
import 'package:reentry/ui/modules/messaging/bloc/conversation_cubit.dart';
import 'package:reentry/ui/modules/messaging/bloc/message_cubit.dart';
import 'package:reentry/ui/modules/profile/bloc/profile_cubit.dart';
import 'package:reentry/ui/modules/profile/bloc/user_profile_cubit.dart';
import 'package:reentry/ui/modules/splash/splash_screen.dart';

late final FirebaseApp app;
late final FirebaseAuth auth;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
// We're using the manual installation on non-web platforms since Google sign in plugin doesn't yet support Dart initialization.
// See related issue: https://github.com/flutter/flutter/issues/96391

// We store the app and auth to make testing with a named instance easier.
  setupDi();
  app = await Firebase.initializeApp(
    options:  FirebaseOptions(
        apiKey: "AIzaSyDaLHkABOMmrDWZ4qhydqqoQX08XKXP_Zo",
        authDomain: "trs-app-13c75.firebaseapp.com",
        projectId: "trs-app-13c75",
        storageBucket: "trs-app-13c75.appspot.com",
        messagingSenderId: "277362543199",
        appId: Platform.isAndroid
            ? "1:277362543199:android:cd75ae50fc9db899a1e9ea"
            : "1:277362543199:ios:9375181851d87c27a1e9ea",
        measurementId: "G-DFNJ45R5R9"),
  );
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
          BlocProvider(create: (context) => MessageCubit()),
          BlocProvider(create: (context) => ConversationUsersCubit()),
          BlocProvider(create: (context) => AppointmentCubit()),
          BlocProvider(create: (context) => ClientBloc()),
          // BlocProvider(create: (context) => UserProfileCubit()),
          BlocProvider(
              create: (context) =>
                  ConversationCubit()..listenForConversationsUpdate()),
          BlocProvider(create: (context) => ClientCubit()),
          BlocProvider(create: (context) => RecommendedClientCubit()),
        ],
        child: MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            themeMode: ThemeMode.dark,
            darkTheme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
                useMaterial3: true,
                appBarTheme:
                    const AppBarTheme(backgroundColor: AppColors.black),
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
                  titleSmall: TextStyle(
                      color: AppColors.white,
                      fontSize: 18,
                      fontFamily: 'InterBold'),
                  titleMedium: TextStyle(color: AppColors.white, fontSize: 20),
                ),
                fontFamily: 'Inter'),
            home: const SplashScreen()));
  }
}
