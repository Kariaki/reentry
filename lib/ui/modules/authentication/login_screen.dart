import 'dart:io';

import 'package:beamer/beamer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:reentry/beam_locations.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/routes/routes.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/core/theme/style/app_styles.dart';
import 'package:reentry/core/util/input_validators.dart';
import 'package:reentry/generated/assets.dart';
import 'package:reentry/ui/components/app_check_box.dart';
import 'package:reentry/ui/components/scaffold/onboarding_scaffold.dart';
import 'package:reentry/ui/components/web_sidebar_layout.dart';
import 'package:reentry/ui/modules/authentication/bloc/onboarding_cubit.dart';
import 'package:reentry/ui/modules/root/web/web_root.dart';
import 'package:reentry/ui/modules/webview/app_webview.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../components/buttons/primary_button.dart';
import '../../components/input/input_field.dart';
import '../../components/input/password_field.dart';
import '../root/root_page.dart';
import 'bloc/account_cubit.dart';
import 'bloc/auth_events.dart';
import 'bloc/authentication_bloc.dart';
import 'bloc/authentication_state.dart';
import 'password_reset_screen.dart';
import 'account_type_screen.dart';

class LoginScreen extends HookWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final loginFormKey = GlobalKey<FormState>();
    final rememberMe = useState(false);
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();
    // final theme = AppStyles.textTheme(context);
    final isChecked = useState(false);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          if (state.data != null) {
            print('loginResult -> ${state.data?.toJson()}');
            context.read<AccountCubit>().setAccount(state.data!);

            if (kIsWeb) {
              context.go(
                AppRoutes.dashboard.path,
              );
              return;
            } else {
              context.pushRemoveUntil(const RootPage());
            }
          } else if (state.authId != null) {
            final entity = OnboardingEntity(
                email: emailController.text,
                id: state.authId!,
                password: passwordController.text);
            context.read<OnboardingCubit>().setOnboarding(entity);
            if (kIsWeb) {
              context.goNamed(AppRoutes.accountType.name);
              return;
            }
            context.pushRemoveUntil(const AccountTypeScreen());
          }
        }
        if (state is AuthenticationSuccess) {
          final entity = OnboardingEntity(
              email: emailController.text,
              id: state.userId,
              password: passwordController.text);
          context.read<OnboardingCubit>().setOnboarding(entity);
          if (kIsWeb) {
            context.goNamed(AppRoutes.accountType.name);
          } else {
            context.pushRoute(AccountTypeScreen());
          }
        }
        if (state is AuthError) {
          context.showSnackbarError(state.message);
        }
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          bool smallScreen = constraints.maxWidth > 800;

          if (kIsWeb) {
            return _buildWebAuthScreen(
                context,
                formKey,
                loginFormKey,
                emailController,
                passwordController,
                confirmPasswordController,
                rememberMe,
                isChecked,
                smallScreen: smallScreen);
          }
          return _buildMobileLoginScreen(
            context,
            loginFormKey,
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
                  context.pushRoute(const PasswordResetScreen());
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
              loading: state is LoginLoading,
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
            if (Platform.isIOS)
              PrimaryButton.dark(
                text: 'Continue with Apple',
                onPress: () {
                  context.read<AuthBloc>().add(OAuthEvent(OAuthType.apple));
                },
                startIcon: SvgPicture.asset(Assets.webApple),
              ),
          ],
        );
      },
    );
  }

  Widget _buildWebAuthScreen(
      BuildContext context,
      GlobalKey<FormState>? loginFormKey,
      GlobalKey<FormState>? formKey,
      TextEditingController emailController,
      TextEditingController passwordController,
      TextEditingController confirmPasswordController,
      ValueNotifier<bool> isChecked,
      ValueNotifier<bool>? rememberMe,
      {bool smallScreen = false}
      // AppStyles.textTheme(context) theme;
      ) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      return Scaffold(
        backgroundColor: AppColors.white,
        body: Row(
          children: [
            if(smallScreen)
            Expanded(
              child: Container(
                color: Colors.black,
                child: Stack(
                  children: [
                    const Center(
                      child: SizedBox(
                        width: 432,
                        child: Image(
                          image: AssetImage(
                            Assets.imagesPeople,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.black.withOpacity(.5),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Text(
                              'Sainte',
                              style: context.textTheme.titleLarge
                                  ?.copyWith(fontSize: 54),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
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
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: DefaultTabController(
                length: 2,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  child: Column(
                    children: [
                      const TabBar(
                        indicatorColor: AppColors.black,
                        labelColor: AppColors.black,
                        unselectedLabelColor: AppColors.hintColor,
                        tabs: [
                          Tab(
                            text: 'Login',
                          ),
                          Tab(text: 'Register'),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: TabBarView(
                          children: [
                            _buildLoginForm(
                              context,
                              loginFormKey!,
                              emailController,
                              passwordController,
                              rememberMe!,
                              state,
                            ),

                            _buildRegistrationForm(
                              context,
                              formKey!,
                              emailController,
                              passwordController,
                              confirmPasswordController,
                              // rememberMe,
                              isChecked,
                              state,
                            ),
                            // _buildRegistrationForm(context),
                          ],
                        ),
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

Widget _buildLoginForm(
  BuildContext context,
  GlobalKey<FormState> formKey,
  TextEditingController emailController,
  TextEditingController passwordController,
  ValueNotifier<bool> rememberMe,
  AuthState state,
) {
  return Form(
    key: formKey,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InputField(
          hint: 'hello@gmail.com',
          validator: (input) =>
              (input?.isNotEmpty ?? true) ? null : 'Enter an email',
          controller: emailController,
          label: 'Email',
          color: AppColors.black,
          textColor: AppColors.black,
          fillColor: AppColors.white,
        ),
        const SizedBox(height: 15),
        PasswordField(
          label: 'Password',
          controller: passwordController,
          labelColor: AppColors.black,
          textColor: AppColors.black,
          fillColor: AppColors.white,
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            appCheckBox(
              rememberMe.value,
              (value) => rememberMe.value = value ?? false,
              title: "Remember me",
              textColor: AppColors.greyDark,
            ),
            InkWell(
              onTap: () {
                if (kIsWeb) {
                  context.goNamed(AppRoutes.forgotPassword.name);
                } else {
                  context.pushRoute(const PasswordResetScreen());
                }
              },
              child: const Text(
                'Forgot Password?',
                style: TextStyle(color: Colors.blueAccent, fontSize: 16.5),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        PrimaryButton.dark(
          loading: state is LoginLoading || state is AuthLoading,
          text: 'Login',
          onPress: () {
            final entity = OnboardingEntity(
                email: 'emailController.text',
                id: 'state.userId',
                password: 'passwordController.text');
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
  );
}

Widget _buildRegistrationForm(
  BuildContext context,
  GlobalKey<FormState> formKey,
  TextEditingController emailController,
  TextEditingController passwordController,
  TextEditingController confirmPasswordController,
  ValueNotifier<bool> isChecked,
  AuthState state,
) {
  return SingleChildScrollView(
    child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            10.height,
            Text(
              'Sign up',
              // style: theme.titleSmall,
            ),
            50.height,
            InputField(
              hint: 'hello@mail.com',
              controller: emailController,
              label: 'Email',
              validator: InputValidators.emailValidation,
              color: AppColors.black,
              textColor: AppColors.black,
              fillColor: AppColors.white,
            ),
            15.height,
            PasswordField(
              label: 'Password',
              controller: passwordController,
              labelColor: AppColors.black,
              textColor: AppColors.black,
              fillColor: AppColors.white,
            ),
            15.height,
            PasswordField(
              controller: confirmPasswordController,
              label: 'Repeat password',
              labelColor: AppColors.black,
              textColor: AppColors.black,
              fillColor: AppColors.white,
              validator: (value) {
                final text = passwordController.text;
                return text == value ? null : "Password does not match";
              },
            ),
            15.height,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: appCheckBox(
                    isChecked.value,
                    (bool? value) {
                      isChecked.value = value ?? false;
                    },
                    textColor: AppColors.greyDark,
                  ),
                ),
                3.width,
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    // setState(() {
                    //   isChecked = !isChecked;
                    // });
                    isChecked.value = !isChecked.value;
                  },
                  child: RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      style: const TextStyle(
                        color: Color(0xFF454545),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                      children: [
                        TextSpan(
                          text: 'By signing Up, you agree to have read our',
                          style: context.textTheme.bodySmall
                              ?.copyWith(color: AppColors.black),
                        ),
                        TextSpan(
                          text: ' privacy policy,',
                          style: context.textTheme.bodySmall
                              ?.copyWith(color: AppColors.primary),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final Uri url = Uri.parse(
                                  "https://totalreentry.com/privacy-policy");
                              if (await canLaunchUrl(url)) {
                                await launchUrl(url,
                                    mode: LaunchMode.externalApplication);
                              }
                            },
                        ),
                        TextSpan(
                          text: " as well as our",
                          style: context.textTheme.bodySmall
                              ?.copyWith(color: AppColors.black),
                        ),
                        TextSpan(
                          text: " end user license agreement",
                          style: context.textTheme.bodySmall
                              ?.copyWith(color: AppColors.primary),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final Uri url = Uri.parse(
                                  "https://docs.google.com/document/d/1z_0_dSV8gLPz33NuwZHroTUkw_4gbP3VGUaD9OSFEvE/edit?tab=t.0#heading=h.u47rcz5u4m2a");
                              if (await canLaunchUrl(url)) {
                                await launchUrl(url,
                                    mode: LaunchMode.externalApplication);
                              }
                            },
                        ),
                      ],
                    ),
                  ),
                ))
              ],
            ),
            50.height,
            PrimaryButton.dark(
              text: 'Sign up',
              loading: state is AuthLoading,
              // enable: isChecked.value,
              // color: isChecked.value
              //     ? AppColors.white
              //     : AppColors.white.withOpacity(.75),
              onPress: () {
                if (formKey.currentState!.validate()) {
                  context.read<AuthBloc>().add(CreateAccountEvent(
                      emailController.text, passwordController.text));
                }
              },
            )
          ],
        )),
  );
}
