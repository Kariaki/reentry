import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/generated/assets.dart';
import 'package:reentry/ui/components/app_check_box.dart';
import 'package:reentry/ui/components/scaffold/onboarding_scaffold.dart';
import 'package:reentry/ui/components/web_sidebar_layout.dart';
import '../../components/buttons/primary_button.dart';
import '../../components/input/input_field.dart';
import '../../components/input/password_field.dart';
import '../root/root_page.dart';
import 'bloc/auth_events.dart';
import 'bloc/authentication_bloc.dart';
import 'bloc/authentication_state.dart';
import 'password_reset_screen.dart';
import 'account_type_screen.dart';

class LoginScreen extends HookWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<FormState>();
    final rememberMe = useState(false);
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          if (state.data != null) {
            if (kIsWeb) {
              context.pushRemoveUntil(const WebSideBarLayout());
            } else {
              context.pushRemoveUntil(const RootPage());
            }
          } else if (state.authId != null) {
            context.pushRemoveUntil(AccountTypeScreen(
              data: OnboardingEntity(
                email: emailController.text,
                id: state.authId!,
              ),
            ));
          }
        }
        if (state is AuthError) {
          context.showSnackbarError(state.message);
        }
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          bool isWeb = constraints.maxWidth > 800;

          return isWeb
              ? _buildWebLoginScreen(
                  context,
                  key,
                  emailController,
                  passwordController,
                  rememberMe,
                )
              : _buildMobileLoginScreen(
                  context,
                  key,
                  emailController,
                  passwordController,
                  rememberMe,
                );
        },
      ),
    );
  }

  Widget _buildMobileLoginScreen(
    BuildContext context,
    GlobalKey<FormState> formKey,
    TextEditingController emailController,
    TextEditingController passwordController,
    ValueNotifier<bool> rememberMe,
  ) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return OnboardingScaffold(
          formKey: formKey,
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
                onTap: () {
                  context.push(const PasswordResetScreen());
                },
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(color: Colors.blueAccent, fontSize: 16.5),
                ),
              ),
            ),
            5.height,
            PasswordField(
              label: 'Password',
              controller: passwordController,
            ),
            10.height,
            appCheckBox(
              rememberMe.value,
              (value) => rememberMe.value = value ?? false,
              title: "Remember me",
            ),
            30.height,
            PrimaryButton(
              loading: state is AuthLoading,
              text: 'Sign in',
              onPress: () {
                if (formKey.currentState!.validate()) {
                  context.read<AuthBloc>().add(LoginEvent(
                        email: emailController.text,
                        password: passwordController.text,
                      ));
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
              startIcon: SvgPicture.asset(Assets.apple),
            ),
          ],
        );
      },
    );
  }

  Widget _buildWebLoginScreen(
    BuildContext context,
    GlobalKey<FormState> formKey,
    TextEditingController emailController,
    TextEditingController passwordController,
    ValueNotifier<bool> rememberMe,
  ) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      return Scaffold(
        backgroundColor: AppColors.white,
        body: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                color: Colors.black,
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Sainte',
                      style:
                          context.textTheme.titleLarge?.copyWith(fontSize: 64),
                    ),
                    const SizedBox(height: 20),
                    const Image(
                      image: AssetImage(
                        Assets.imagesPeople,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Everybody is a sainte",
                      style: context.textTheme.bodyLarge?.copyWith(
                        color: AppColors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PrimaryButton(
                        text: 'Sign in with Google',
                        onPress: () {
                          context
                              .read<AuthBloc>()
                              .add(OAuthEvent(OAuthType.google));
                        },
                        startIcon: SvgPicture.asset(Assets.svgGoogle),
                      ),
                      const SizedBox(height: 15),
                      PrimaryButton(
                        text: 'Sign in with Apple',
                        onPress: () {
                          context
                              .read<AuthBloc>()
                              .add(OAuthEvent(OAuthType.apple));
                        },
                        startIcon: SvgPicture.asset(Assets.svgApple),
                      ),
                      const SizedBox(height: 20),
                      InputField(
                        hint: 'hello@gmail.com',
                        validator: (input) => (input?.isNotEmpty ?? true)
                            ? null
                            : 'Enter an email',
                        controller: emailController,
                        label: 'Email',
                        color: AppColors.black,
                        textColor: AppColors.black,
                      ),
                      const SizedBox(height: 15),
                      PasswordField(
                        label: 'Password',
                        controller: passwordController,
                        labelColor: AppColors.black,
                        textColor: AppColors.black,
                      ),
                      const SizedBox(height: 30),
                      Align(
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: () {
                            context.push(const PasswordResetScreen());
                          },
                          child: const Text(
                            'Forgot Password?',
                            style:
                                TextStyle(color: AppColors.black, fontSize: 16),
                          ),
                        ),
                      ),
                      20.height,
                      PrimaryButton.dark(
                        loading: state is AuthLoading,
                        text: 'Login',
                        onPress: () {
                          if (formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(LoginEvent(
                                  email: emailController.text,
                                  password: passwordController.text,
                                ));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
