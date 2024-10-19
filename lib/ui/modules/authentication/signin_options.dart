import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/modules/authentication/continue_with_email_screen.dart';
import 'package:reentry/ui/modules/authentication/login_screen.dart';
import '../../../generated/assets.dart';
import '../../components/buttons/primary_button.dart';

class SignInOptionsScreen extends StatelessWidget {
  const SignInOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    return BaseScaffold(
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
          'Sign in',
          style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        20.height,
        Text("Let's get you all set up", style: textTheme.titleSmall),
        20.height,
        PrimaryButton(
          text: 'Sign up with Email',
          startIcon: SvgPicture.asset(Assets.svgMailOutline),
          onPress: () => context.push(const ContinueWithEmailScreen()),
        ),
        15.height,
        PrimaryButton.dark(
          text: 'Continue with Google',
          onPress: (){
            googleAuth();
          },
          startIcon: SvgPicture.asset(Assets.svgGoogle),
        ),
        15.height,
        PrimaryButton.dark(
          text: 'Continue with Apple',
          startIcon: SvgPicture.asset(Assets.svgApple),
        ),
        40.height,
        GestureDetector(
          onTap: () =>context.push(LoginScreen())
          ,
          child: Text("Already have an account? Tap to Sign in",
              style:
                  textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
        )
      ],
    ));
  }
  void googleAuth()async{
    final result = await GoogleSignIn(scopes: ['email']).signIn();

  }
}
