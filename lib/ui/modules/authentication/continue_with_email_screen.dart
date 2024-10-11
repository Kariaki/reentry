import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/style/app_styles.dart';
import 'package:reentry/ui/components/app_bar.dart';
import 'package:reentry/ui/components/buttons/primary_button.dart';
import 'package:reentry/ui/components/input/input_field.dart';
import 'package:reentry/ui/components/input/password_field.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';

class ContinueWithEmailScreen extends HookWidget {
  const ContinueWithEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppStyles.textTheme(context);
    return BaseScaffold(
        appBar: CustomAppbar(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            10.height,
            Text('Sign up',style: theme.titleSmall,),
            50.height,
            InputField(
              hint: 'hello@mail.com',
              label: 'Email',
            ),
            15.height,
            PasswordField(
              label: 'Password',
            ),
            15.height,
            PasswordField(
              label: 'Repeat password',
            ),
            50.height,
            PrimaryButton(text: 'Sign in',onPress: (){},)
          ],
        ));
  }
}
