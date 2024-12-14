import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/core/theme/style/app_styles.dart';
import 'package:reentry/core/util/input_validators.dart';
import 'package:reentry/ui/components/app_bar.dart';
import 'package:reentry/ui/components/app_check_box.dart';
import 'package:reentry/ui/components/buttons/primary_button.dart';
import 'package:reentry/ui/components/input/input_field.dart';
import 'package:reentry/ui/components/input/password_field.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/modules/authentication/account_type_screen.dart';
import 'package:reentry/ui/modules/authentication/bloc/auth_events.dart';
import 'package:reentry/ui/modules/authentication/bloc/authentication_bloc.dart';
import 'package:reentry/ui/modules/authentication/bloc/authentication_state.dart';
import 'package:reentry/ui/modules/webview/app_webview.dart';

import 'bloc/onboarding_cubit.dart';

class ContinueWithEmailScreen extends HookWidget {
  const ContinueWithEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppStyles.textTheme(context);
    final key = GlobalKey<FormState>();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();
    final isChecked = useState(false);
    return BlocConsumer<AuthBloc, AuthState>(listener: (_, state) {
      if (state is AuthenticationSuccess) {
        final entity = OnboardingEntity(
            email: emailController.text,
            id: state.userId,
            password: passwordController.text);

        context.read<OnboardingCubit>().setOnboarding(entity);
        context.pushReplace(AccountTypeScreen(
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
                            style: TextStyle(
                              color: Color(0xFF454545),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                            children: [
                              TextSpan(
                                text:
                                    'By signing Up, you agree to have read our',
                                style: context.textTheme.bodySmall,
                              ),
                              TextSpan(
                                text: ' privacy policy,',
                                style: context.textTheme.bodySmall
                                    ?.copyWith(color: AppColors.primary),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    context.pushRoute(const AppWebView(
                                        url:
                                            'https://totalreentry.com/privacy-policy',
                                        title: 'Terms & condition'));
                                  },
                              ),
                              TextSpan(
                                text: " as well as our",
                                style: context.textTheme.bodySmall,
                              ),
                              TextSpan(
                                text: " end user license agreement",
                                style: context.textTheme.bodySmall
                                    ?.copyWith(color: AppColors.primary),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    context.pushRoute(const AppWebView(
                                        url:
                                            'https://docs.google.com/document/d/1z_0_dSV8gLPz33NuwZHroTUkw_4gbP3VGUaD9OSFEvE/edit?tab=t.0#heading=h.u47rcz5u4m2a',
                                        title: 'End user license agreement'));
                                  },
                              ),
                            ],
                          ),
                        ),
                      ))
                    ],
                  ),
                  50.height,
                  PrimaryButton(
                    text: 'Sign in',
                    loading: state is AuthLoading,
                    enable: isChecked.value,
                    color: isChecked.value
                        ? AppColors.white
                        : AppColors.white.withOpacity(.75),
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
