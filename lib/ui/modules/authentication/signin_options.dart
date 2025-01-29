import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/main.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/modules/authentication/account_type_screen.dart';
import 'package:reentry/ui/modules/authentication/basic_info_screen.dart';
import 'package:reentry/ui/modules/authentication/bloc/auth_events.dart';
import 'package:reentry/ui/modules/authentication/bloc/authentication_bloc.dart';
import 'package:reentry/ui/modules/authentication/continue_with_email_screen.dart';
import 'package:reentry/ui/modules/authentication/login_screen.dart';
import 'package:reentry/ui/modules/root/feeling_screen.dart';
import '../../../generated/assets.dart';
import '../../components/buttons/primary_button.dart';
import 'bloc/authentication_state.dart';

class SignInOptionsScreen extends StatelessWidget {
  const SignInOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final vm = context.watch<AuthBloc>();

    return BlocListener<AuthBloc, AuthState>(
      listener: (_, state) {
        if (state is OAuthSuccess) {
          if (state.user == null) {
            context.pushRoute(AccountTypeScreen());
          } else {
            context.pushRemoveUntil(const FeelingScreen());
          }
        }
        if (state is AuthError) {
          context.showSnackbarError(state.message);
        }
      },
      child: BaseScaffold(
          isLoading: vm.state is AuthLoading,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Reentry',
                style: textTheme.titleLarge,
              ),
              50.height,
              Text(
                'Sign up',
                style:
                    textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              20.height,
              Text("Let's get you all set up", style: textTheme.titleSmall),
              20.height,
              PrimaryButton(
                text: 'Sign up with Email',
                startIcon: SvgPicture.asset(Assets.svgMailOutline),
                onPress: () => context.pushRoute(const ContinueWithEmailScreen()),
              ),
              15.height,
              PrimaryButton.dark(
                text: 'Sign up with Google',
                onPress: () {
                  context.read<AuthBloc>().add(OAuthEvent(OAuthType.google));
                },
                startIcon: SvgPicture.asset(Assets.svgGoogle),
              ),
              if(Platform.isIOS)
             ...[ 15.height,
              PrimaryButton.dark(
                text: 'Sign up with Apple',
                onPress: () {
                  context.read<AuthBloc>().add(OAuthEvent(OAuthType.apple));
                },
                startIcon: SvgPicture.asset(Assets.svgApple),
              )],
              40.height,
              GestureDetector(
                onTap: () => context.pushRoute(const LoginScreen()),
                child: Text("Already have an account? Tap to Sign in",
                    style: textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold,decoration:TextDecoration.underline)),
              )
            ],
          )),
    );
  }

  void googleAuth() async {
    final result = await GoogleSignIn(scopes: ['email']).signIn();
  }
}
