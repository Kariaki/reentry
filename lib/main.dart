import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/ui/components/buttons/primary_button.dart';
import 'package:reentry/ui/components/input/input_field.dart';
import 'package:reentry/ui/components/input/password_field.dart';
import 'package:reentry/ui/components/pill_selector_component.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/modules/authentication/account_type_screen.dart';
import 'package:reentry/ui/modules/authentication/basic_info_screen.dart';
import 'package:reentry/ui/modules/authentication/continue_with_email_screen.dart';
import 'package:reentry/ui/modules/authentication/login_screen.dart';
import 'package:reentry/ui/modules/authentication/onboarding_success.dart';
import 'package:reentry/ui/modules/authentication/peer_mentor_organization_info_screen.dart';
import 'package:reentry/ui/modules/authentication/signin_options.dart';

import 'generated/assets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor:AppColors.primary),
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.black
            ),
            primaryColor: AppColors.primary,
            textTheme: const TextTheme(
              bodyMedium: TextStyle(color: AppColors.white, fontSize: 14),
              bodyLarge: TextStyle(color: AppColors.white, fontSize: 16),
              bodySmall: TextStyle(color: AppColors.white, fontSize: 12),
              titleLarge: TextStyle(
                  color: AppColors.primary,
                  fontSize: 40,
                  fontFamily: 'InterBold',
                  fontWeight: FontWeight.bold),
              titleSmall: TextStyle(color: AppColors.white, fontSize: 18,fontFamily: 'InterBold'),
              titleMedium: TextStyle(color: AppColors.white, fontSize: 20),
            ),
            fontFamily: 'Inter'),
        home: LoginScreen()
        // BaseScaffold(
        //   child: Center(
        //     // Wrap the entire body in Center to center everything
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       // Vertically center content
        //       crossAxisAlignment: CrossAxisAlignment.center,
        //       // Horizontally center content
        //       children: [
        //         PrimaryButton(
        //           text: 'Create a new goal',
        //           onPress: () {},
        //         ),
        //         20.height,
        //         PrimaryButton.dark(
        //           text: 'Go back',
        //           onPress: () {},
        //         ),
        //         20.height,
        //         InputField(hint: 'hello@mail.com',label: 'Email',),
        //         20.height,
        //         PasswordField(label: 'Password'),
        //         20.height,
        //         PrimaryButton(text: 'Sign up with Email',startIcon: SvgPicture.asset(Assets.svgMailOutline),),
        //         20.height,
        //         PrimaryButton.dark(text: 'Sign up with Email',startIcon: SvgPicture.asset(Assets.svgGoogle),),
        //         20.height,
        //         PrimaryButton.dark(text: 'Sign up with Email',startIcon: SvgPicture.asset(Assets.svgApple),),
        //         10.height,
        //         PillSelectorComponent(text: 'Teacher',selected: false,)
        //
        //
        //       ],
        //     ),
        //   ),
        // )
        );
  }
}
