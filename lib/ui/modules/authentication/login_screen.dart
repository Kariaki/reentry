import 'package:flutter/cupertino.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/ui/components/scaffold/onboarding_scaffold.dart';

import '../../../core/theme/style/app_styles.dart';
import '../../components/buttons/primary_button.dart';
import '../../components/input/input_field.dart';
import '../../components/input/password_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppStyles.textTheme(context);
    return OnboardingScaffold(
        title: 'Sign in with Email', children: [
      50.height,
      InputField(
        hint: 'hello@mail.com',
        label: 'Email',
      ),
      15.height,
      PasswordField(label: 'Password'),
      //TODO remember me and forgot password fields
      50.height,
      PrimaryButton(
        text: 'Sign in',
        onPress: () {},
      )
    ]);
  }
}
