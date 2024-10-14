import 'package:flutter/material.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/ui/modules/root/navigations/home_navigation_screen.dart';
import 'package:reentry/ui/modules/splash/splash_screen.dart';

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
              displaySmall: TextStyle(color: AppColors.white, fontSize: 12),
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
        home: SplashScreen()
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
