import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/ui/components/app_check_box.dart';
import 'package:reentry/ui/components/scaffold/onboarding_scaffold.dart';
import 'package:reentry/ui/modules/authentication/bloc/auth_events.dart';
import 'package:reentry/ui/modules/authentication/bloc/authentication_bloc.dart';
import 'package:reentry/ui/modules/authentication/bloc/authentication_state.dart';
import 'package:reentry/ui/modules/root/root_page.dart';
import '../../components/buttons/primary_button.dart';
import '../../components/input/input_field.dart';
import '../../components/input/password_field.dart';

class LoginScreen extends HookWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<FormState>();
    final rememberMe = useState(false);
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, current) {
        if (current is LoginSuccess) {
          context.pushRemoveUntil(const RootPage());
          return;
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
                title: 'Sign in with Email',
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
                  15.height,
                  PasswordField(
                    label: 'Password',
                    controller: passwordController,
                  ),
                  10.height,
                  _rememberMe(rememberMe.value, (value) {
                    rememberMe.value = value ?? false;
                  }),
                  //TODO remember me and forgot password fields
                  50.height,
                  PrimaryButton(
                    loading: state is AuthLoading,
                    text: 'Sign in',
                    onPress: () {
                      if (key.currentState!.validate()) {
                        context.read<AuthBloc>().add(LoginEvent(
                            password: passwordController.text,
                            email: emailController.text));
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
