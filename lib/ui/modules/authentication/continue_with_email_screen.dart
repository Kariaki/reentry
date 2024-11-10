import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/style/app_styles.dart';
import 'package:reentry/core/util/input_validators.dart';
import 'package:reentry/ui/components/app_bar.dart';
import 'package:reentry/ui/components/buttons/primary_button.dart';
import 'package:reentry/ui/components/input/input_field.dart';
import 'package:reentry/ui/components/input/password_field.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/modules/authentication/account_type_screen.dart';
import 'package:reentry/ui/modules/authentication/bloc/auth_events.dart';
import 'package:reentry/ui/modules/authentication/bloc/authentication_bloc.dart';
import 'package:reentry/ui/modules/authentication/bloc/authentication_state.dart';

class ContinueWithEmailScreen extends HookWidget {
  const ContinueWithEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppStyles.textTheme(context);
    final key = GlobalKey<FormState>();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();
    return BlocConsumer<AuthBloc, AuthState>(listener: (_, state) {
      if (state is AuthenticationSuccess) {
        final entity = OnboardingEntity(
            email: emailController.text,
            id: state.userId,
            password: passwordController.text);
        context.push(AccountTypeScreen(
          data: entity,
        ));
      }
      if (state is AuthError) {
        context.showSnackbarError(state.message);
      }
    }, builder: (context, state) {
      return BaseScaffold(
          appBar: const CustomAppbar(),
          child: Form(
              key: key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  10.height,
                  Text(
                    'Sign up',
                    style: theme.titleSmall,
                  ),
                  50.height,
                  InputField(
                    hint: 'hello@mail.com',
                    controller: emailController,
                    label: 'Email',
                    validator: InputValidators.emailValidation,
                  ),
                  15.height,
                  PasswordField(
                    label: 'Password',
                    controller: passwordController,
                  ),
                  15.height,
                  PasswordField(
                    controller: confirmPasswordController,
                    label: 'Repeat password',
                    validator: (value) {
                      final text = passwordController.text;
                      return text == value ? null : "Password does not match";
                    },
                  ),
                  50.height,
                  PrimaryButton(
                    text: 'Sign in',
                    loading: state is AuthLoading,
                    onPress: () {
                      if (key.currentState!.validate()) {
                        context.read<AuthBloc>().add(CreateAccountEvent(
                            emailController.text, passwordController.text));
                      }
                    },
                  )
                ],
              )));
    });
  }
}
