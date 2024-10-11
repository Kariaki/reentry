import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import '../../../generated/assets.dart';
import '../../components/buttons/primary_button.dart';

class SignInOptionsScreen extends StatelessWidget {
  const SignInOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    return BaseScaffold(child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Reentry',style: textTheme.titleLarge,),
        50.height,
        Text('Sign in',style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),),
        20.height,
        Text("Let's get you all set up",style: textTheme.titleSmall),
        20.height,
        PrimaryButton(text: 'Sign up with Email',startIcon: SvgPicture.asset(Assets.svgMailOutline),
        onPress: (){},),
        15.height,
        PrimaryButton.dark(text: 'Continue with Google',startIcon: SvgPicture.asset(Assets.svgGoogle),),
        15.height,
        PrimaryButton.dark(text: 'Continue with Apple',startIcon: SvgPicture.asset(Assets.svgApple),),
        40.height,
        Text("Don't have an account? Tap to signin up",style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold))
      ],
    ));
  }
}
