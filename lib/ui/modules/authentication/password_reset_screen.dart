import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/routes/routes.dart';
import 'package:reentry/ui/components/app_check_box.dart';
import 'package:reentry/ui/components/scaffold/onboarding_scaffold.dart';
import 'package:reentry/ui/modules/authentication/account_type_screen.dart';
import 'package:reentry/ui/modules/authentication/bloc/auth_events.dart';
import 'package:reentry/ui/modules/authentication/bloc/authentication_bloc.dart';
import 'package:reentry/ui/modules/authentication/bloc/authentication_state.dart';
import 'package:reentry/ui/modules/authentication/password_reset_success_screen.dart';
import 'package:reentry/ui/modules/root/root_page.dart';
import 'package:reentry/ui/modules/shared/success_screen.dart';
import '../../components/buttons/primary_button.dart';
import '../../components/input/input_field.dart';
import '../../components/input/password_field.dart';

class PasswordResetScreen extends HookWidget {
  const PasswordResetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<FormState>();
    final rememberMe = useState(false);
    final emailController = useTextEditingController();
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, current) {
        if (current is PasswordResetSuccess) {
          if (current.resend) {
            return;
          }
          if (kIsWeb) {
            context.goNamed(AppRoutes.passwordResetInfo.name, extra:  {'email': emailController.text});
          } else {
            context.pushReplace(
                PasswordResetSuccessScreen(email: emailController.text));
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
                formKey: key,
                title: 'Password Reset',
                description:
                    "Enter the email address associated with your account to reset your password",
                children: [
                  50.height,
                  InputField(
                    hint: 'hello@mail.com',
                    validator: (input) => (input?.isNotEmpty ?? true)
                        ? null
                        : 'Please enter a valid input',
                    controller: emailController,
                    label: 'Email',
                  ),
                  50.height,
                  PrimaryButton(
                    loading: state is AuthLoading,
                    text: 'Reset Password',
                    onPress: () {
                      if (key.currentState!.validate()) {
                        context
                            .read<AuthBloc>()
                            .add(PasswordResetEvent(emailController.text));
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
