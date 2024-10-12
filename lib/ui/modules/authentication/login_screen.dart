
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/ui/components/app_check_box.dart';
import 'package:reentry/ui/components/scaffold/onboarding_scaffold.dart';

import '../../../core/theme/style/app_styles.dart';
import '../../components/buttons/primary_button.dart';
import '../../components/input/input_field.dart';
import '../../components/input/password_field.dart';

class LoginScreen extends HookWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppStyles.textTheme(context);
    final rememberMe = useState(false);
    return OnboardingScaffold(
        title: 'Sign in with Email', children: [
      50.height,
      InputField(
        hint: 'hello@mail.com',
        label: 'Email',
      ),
      15.height,
      PasswordField(label: 'Password'),
      10.height,
      _rememberMe(rememberMe.value, (value) {
        rememberMe.value = value ?? false;
      }),
      //TODO remember me and forgot password fields
      50.height,
      PrimaryButton(
        text: 'Sign in',
        onPress: () {},
      )
    ]);
  }

  Widget _rememberMe(bool value, Function(bool?)onChange) {
    return appCheckBox(value, onChange,title: "Remember me");
  }
}
