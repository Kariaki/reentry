import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/ui/components/app_check_box.dart';
import 'package:reentry/ui/components/scaffold/onboarding_scaffold.dart';
import 'package:reentry/ui/modules/authentication/account_type_screen.dart';
import 'package:reentry/ui/modules/authentication/bloc/auth_events.dart';
import 'package:reentry/ui/modules/authentication/bloc/authentication_bloc.dart';
import 'package:reentry/ui/modules/authentication/bloc/authentication_state.dart';
import 'package:reentry/ui/modules/authentication/password_reset_screen.dart';
import 'package:reentry/ui/modules/root/root_page.dart';
import '../../../generated/assets.dart';
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
          if (current.data == null) {
            return;
          }
          if (current.data != null) {
            context.pushRemoveUntil(const RootPage());
          }
          if (current.data == null && current.authId != null) {
            context.pushRemoveUntil(AccountTypeScreen(
                data: OnboardingEntity(
                    email: emailController.text, id: current.authId!)));
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
                isLoading: state is AuthLoading,
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
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: (){
                        context.push(const PasswordResetScreen());
                      },
                      child: const Text('Forgot Password?',style: TextStyle(color: Colors.blueAccent,fontSize: 16.5),),
                    ),
                  ),
                  5.height,
                  PasswordField(
                    label: 'Password',
                    controller: passwordController,
                  ),
                  10.height,
                  _rememberMe(rememberMe.value, (value) {
                    rememberMe.value = value ?? false;
                  }),
                  //TODO remember me and forgot password fields
                  30.height,
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
                  ),
                  15.height,
                  PrimaryButton.dark(
                    text: 'Continue with Google',
                    onPress: () {
                      context.read<AuthBloc>().add(OAuthEvent(OAuthType.google));
                    },
                    startIcon: SvgPicture.asset(Assets.svgGoogle),
                  ),
                  15.height,
                  PrimaryButton.dark(
                    text: 'Continue with Apple',
                    onPress: () {
                      context.read<AuthBloc>().add(OAuthEvent(OAuthType.apple));
                    },
                    startIcon: SvgPicture.asset(Assets.svgApple),
                  ),
                ]);
          }),
    );
  }

  Widget _rememberMe(bool value, Function(bool?) onChange) {
    return appCheckBox(value, onChange, title: "Remember me");
  }
}
