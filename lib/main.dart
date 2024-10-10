import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/ui/components/buttons/primary_button.dart';
import 'package:reentry/ui/components/input/input_field.dart';
import 'package:reentry/ui/components/input/password_field.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';

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
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
            useMaterial3: true,
            fontFamily: 'Inter'),
        home: BaseScaffold(
          child: Center(
            // Wrap the entire body in Center to center everything
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // Vertically center content
              crossAxisAlignment: CrossAxisAlignment.center,
              // Horizontally center content
              children: [
                PrimaryButton(
                  text: 'Create a new goal',
                  onPress: () {},
                ),
                20.height,
                PrimaryButton.dark(
                  text: 'Go back',
                  onPress: () {},
                ),
                20.height,
                InputField(hint: 'hello@mail.com',label: 'Email',),
                20.height,
                PasswordField(label: 'Password'),
                20.height,
                PrimaryButton(text: 'Sign up with Email',startIcon: SvgPicture.asset(Assets.svgMailOutline),),
                20.height,
                PrimaryButton.dark(text: 'Sign up with Email',startIcon: SvgPicture.asset(Assets.svgGoogle),),
                20.height,
                PrimaryButton.dark(text: 'Sign up with Email',startIcon: SvgPicture.asset(Assets.svgApple),),

              ],
            ),
          ),
        ));
  }
}
