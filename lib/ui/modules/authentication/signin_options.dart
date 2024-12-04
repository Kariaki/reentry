import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/main.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/modules/authentication/account_type_screen.dart';
import 'package:reentry/ui/modules/authentication/basic_info_screen.dart';
import 'package:reentry/ui/modules/authentication/bloc/auth_events.dart';
import 'package:reentry/ui/modules/authentication/bloc/authentication_bloc.dart';
import 'package:reentry/ui/modules/authentication/continue_with_email_screen.dart';
import 'package:reentry/ui/modules/authentication/login_screen.dart';
import 'package:reentry/ui/modules/root/feeling_screen.dart';
import '../../../core/theme/colors.dart';
import '../../../generated/assets.dart';
import '../../components/app_check_box.dart';
import '../../components/buttons/primary_button.dart';
import '../webview/app_webview.dart';
import 'bloc/authentication_state.dart';

class SignInOptionsScreen extends HookWidget {
  const SignInOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final vm = context.watch<AuthBloc>();

    final isChecked = useState(false);
    return BlocListener<AuthBloc, AuthState>(
      listener: (_, state) {
        if (state is OAuthSuccess) {
          if (state.user == null) {

            context.push(AccountTypeScreen(
                data: OnboardingEntity(
                    email: state.email, id: state.id, name: state.name)));
          } else {
            context.pushRemoveUntil(const FeelingScreen());
          }
        }
        if (state is AuthError) {
          context.showSnackbarError(state.message);
        }
      },
      child: BaseScaffold(
          isLoading: vm.state is AuthLoading,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Reentry',
                style: textTheme.titleLarge,
              ),
              50.height,
              Text(
                'Sign up',
                style:
                    textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              20.height,
              Text("Let's get you all set up", style: textTheme.titleSmall),
              20.height,
              PrimaryButton(
                text: 'Sign up with Email',
                startIcon: SvgPicture.asset(Assets.svgMailOutline),
                onPress: () => context.push(const ContinueWithEmailScreen()),
              ),
              15.height,
              PrimaryButton.dark(
                text: 'Sign up with Google',
                onPress: () {
                  if(!isChecked.value){
                    context.showSnackbar('Please accept our privacy policy to continue');
                  return;
                }
                  context.read<AuthBloc>().add(OAuthEvent(OAuthType.google));
                },
                startIcon: SvgPicture.asset(Assets.svgGoogle),
              ),
               if (!kIsWeb && Platform.isIOS)
             ...[ 15.height,
              PrimaryButton.dark(
                text: 'Sign up with Apple',
                onPress: () {
                  if(!isChecked.value){
                    context.showSnackbar('Please accept our privacy policy to continue');
                    return;
                  }
                  context.read<AuthBloc>().add(OAuthEvent(OAuthType.apple));
                },
                startIcon: SvgPicture.asset(Assets.svgApple),
              )],
              40.height,
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
                                    context.push(const AppWebView(
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
                                    context.push(const AppWebView(
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

            ],
          )),
    );
  }

  void googleAuth() async {
    final result = await GoogleSignIn(scopes: ['email']).signIn();
  }
}
