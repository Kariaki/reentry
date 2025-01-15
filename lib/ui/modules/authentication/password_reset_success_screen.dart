import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/routes/routes.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/ui/components/app_check_box.dart';
import 'package:reentry/ui/components/scaffold/onboarding_scaffold.dart';
import 'package:reentry/ui/modules/authentication/account_type_screen.dart';
import 'package:reentry/ui/modules/authentication/bloc/auth_events.dart';
import 'package:reentry/ui/modules/authentication/bloc/authentication_bloc.dart';
import 'package:reentry/ui/modules/authentication/bloc/authentication_state.dart';
import 'package:reentry/ui/modules/root/root_page.dart';
import 'package:reentry/ui/modules/shared/success_screen.dart';
import '../../components/buttons/primary_button.dart';
import '../../components/input/input_field.dart';
import '../../components/input/password_field.dart';

class PasswordResetSuccessScreen extends HookWidget {
  const PasswordResetSuccessScreen({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<FormState>();
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, current) {
        if (current is PasswordResetSuccess) {
          if (current.resend) {
            context.showSnackbarSuccess("Password reset link sent");
          }
        }

        if (current is AuthError) {
          context.showSnackbarError(current.message);
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
          buildWhen: (prev, current) => prev != current,
          builder: (context, state) {
            return OnboardingScaffold(
                isLoading: state is AuthLoading,
                formKey: key,
                title: 'Password reset email sent',
                description:
                    "An email has been sent you. Follow the instructions in the email to reset your password",
                children: [
                  100.height,
                  const Text(
                    "Did not receive an email?",
                    style: TextStyle(fontSize: 18, color: AppColors.white),
                  ),
                  10.height,
                  PrimaryButton.dark(
                      text: 'Resend link',
                      onPress: () {
                        context
                            .read<AuthBloc>()
                            .add(PasswordResetEvent(email, resend: true));
                      }),
                  20.height,
                  PrimaryButton(
                    text: 'Go back',
                    onPress: () {
                      if (kIsWeb) {
                        context.goNamed(AppRoutes.login.name);
                      } else {
                        context.popRoute();
                      }
                    },
                  )
                ]);
          }),
    );
  }

  Widget _rememberMe(bool value, Function(bool?) onChange) {
    return appCheckBox(value, onChange, title: "Remember me");
  }
}
