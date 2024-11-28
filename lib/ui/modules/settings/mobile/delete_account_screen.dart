import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/core/util/input_validators.dart';
import 'package:reentry/ui/components/app_bar.dart';
import 'package:reentry/ui/components/buttons/primary_button.dart';
import 'package:reentry/ui/components/input/input_field.dart';
import 'package:reentry/ui/dialog/alert_dialog.dart';
import 'package:reentry/ui/modules/authentication/bloc/account_cubit.dart';
import 'package:reentry/ui/modules/authentication/login_screen.dart';
import '../../../components/scaffold/base_scaffold.dart';
import '../../profile/bloc/profile_cubit.dart';
import '../../profile/bloc/profile_state.dart';

class DeleteAccountScreen extends HookWidget {
  const DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = context.textTheme;
    final controller = useTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final user = context.read<AccountCubit>().state;
    ;
    return BlocConsumer<ProfileCubit, ProfileState>(builder: (context, state) {
      return BaseScaffold(
          isLoading: state is ProfileLoading,
          appBar: CustomAppbar(),
          child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  20.height,
                  InputField(
                    hint: 'Enter your reason for deletion',
                    label: "Reason for account deletion",
                    controller: controller,
                    lines: 3,
                    radius: 10,
                    validator: InputValidators.stringValidation,
                  ),
                  10.height,
                  Text(
                    "Deleting your account means you will no longer have access to your account and will not be able to create another with the same credential. Please enter a reason for account deletion to continue.",
                    style: textStyle.bodySmall
                        ?.copyWith(color: Colors.red.withOpacity(.75)),
                  ),
                  20.height,
                  PrimaryButton(
                    text: 'Delete Account',
                    color: Colors.red,
                    textColor: AppColors.white,
                    onPress: () {
                      if (formKey.currentState!.validate()) {
                        AppAlertDialog.show(context,
                            title: "Delete Account?",
                            description:
                                'Are you sure you want to delete your account?',
                            action: 'Proceed', onClickAction: () {
                          context.read<ProfileCubit>().deleteAccount(
                              user?.userId ?? '', controller.text);
                        });
                      }
                    },
                  )
                ],
              )));
    }, listener: (_, state) {
      if (state is DeleteAccountSuccess) {
        context.showSnackbarSuccess("Account has been deleted");
        context.pushRemoveUntil(const LoginScreen());
      }
      if (state is ProfileError) {
        context.showSnackbarError(state.message);
      }
    });
  }
}
