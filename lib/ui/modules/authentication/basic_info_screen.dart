import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/util/input_validators.dart';
import 'package:reentry/data/enum/account_type.dart';
import 'package:reentry/ui/components/scaffold/onboarding_scaffold.dart';
import 'package:reentry/ui/modules/authentication/bloc/auth_events.dart';
import 'package:reentry/ui/modules/authentication/bloc/authentication_bloc.dart';
import 'package:reentry/ui/modules/authentication/onboarding_success.dart';
import 'package:reentry/ui/modules/authentication/peer_mentor_organization_info_screen.dart';

import '../../../core/theme/style/app_styles.dart';
import '../../components/buttons/primary_button.dart';
import '../../components/input/input_field.dart';
import '../../components/input/password_field.dart';
import 'bloc/authentication_state.dart';

class BasicInfoScreen extends HookWidget {
  final OnboardingEntity data;

  const BasicInfoScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = AppStyles.textTheme(context);

    final key = GlobalKey<FormState>();
    final nameController = useTextEditingController(text: data.name);
    final addressController = useTextEditingController();
    final phoneController = useTextEditingController();
    return BlocListener<AuthBloc, AuthState>(
      listener: (_, state) {
        if (state is RegistrationSuccessFull) {
          context.pushRemoveUntil(const OnboardingSuccess());
        }
        if (state is AuthError) {
          context.showSnackbarError(state.message);
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
        return OnboardingScaffold(
            formKey: key,
            title: 'Account setup',
            children: [
              50.height,
              InputField(
                hint: 'First name, Last name',
                validator: InputValidators.stringValidation,
                label: 'Full name',
                controller: nameController,
              ),
              15.height,
              InputField(
                hint: 'Address',
                validator: InputValidators.stringValidation,
                label: 'Street, City, State',
                controller: addressController,
              ),
              15.height,
              InputField(
                label: 'Phone',
                controller: phoneController,
                validator: InputValidators.stringValidation,
                hint: '+1-0000-0000-0000',
              ),
              50.height,
              PrimaryButton(
                text: 'Save',
                loading: state is AuthLoading,
                onPress: () {
                  if (key.currentState!.validate()) {
                    final result = data.copyWith(
                        name: nameController.text,
                        address: addressController.text,
                        phoneNumber: phoneController.text);
                    if (result.accountType == AccountType.citizen) {
                      //create account;
                      context.read<AuthBloc>().add(RegisterEvent(data: result));
                      return;
                    }
                    context.push(PeerMentorOrganizationInfoScreen(
                      data: result,
                    ));
                  }
                },
              )
            ]);
      }),
    );
  }
}
