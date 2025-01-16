import 'package:beamer/beamer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:reentry/beam_locations.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/routes/router.dart';
import 'package:reentry/core/routes/routes.dart';
import 'package:reentry/core/util/input_validators.dart';
import 'package:reentry/data/enum/account_type.dart';
import 'package:reentry/ui/components/date_time_picker.dart';
import 'package:reentry/ui/components/scaffold/onboarding_scaffold.dart';
import 'package:reentry/ui/modules/authentication/bloc/auth_events.dart';
import 'package:reentry/ui/modules/authentication/bloc/authentication_bloc.dart';
import 'package:reentry/ui/modules/authentication/bloc/onboarding_cubit.dart';
import 'package:reentry/ui/modules/authentication/onboarding_success.dart';
import 'package:reentry/ui/modules/authentication/peer_mentor_organization_info_screen.dart';

import '../../../core/theme/style/app_styles.dart';
import '../../components/buttons/primary_button.dart';
import '../../components/date_dialog.dart';
import '../../components/input/input_field.dart';
import '../../components/input/password_field.dart';
import 'bloc/authentication_state.dart';

class BasicInfoScreen extends HookWidget {
  const BasicInfoScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppStyles.textTheme(context);

    final data = context.read<OnboardingCubit>().state!;
    debugPrint('Data retrieved in acctType: $data');
    final key = GlobalKey<FormState>();
    final nameController = useTextEditingController(text: data.name);
    final addressController = useTextEditingController();
    final phoneController = useTextEditingController();
    final date = useState<DateTime?>(DateTime(2000));
    return BlocListener<AuthBloc, AuthState>(
      listener: (_, state) {
        if (state is RegistrationSuccessFull) {
          if (kIsWeb) {
            //navigate to home screen....
            context.goNamed(AppRoutes.success.name);
          } else {
            context.pushRemoveUntil(const OnboardingSuccess());
          }
        }
        if (state is AuthError) {
          context.showSnackbarError(state.message);
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
        return OnboardingScaffold(
            formKey: key,
            title: 'Account setup',
            showBack: !kIsWeb,
            children: [
              50.height,
              InputField(
                hint: 'First name Last name',
                validator: InputValidators.stringValidation,
                enable: data.name == null,
                label: 'Full name',
                controller: nameController,
              ),
              15.height,
              InputField(
                hint: 'Address',
                validator: (v) => null,
                label: 'Street, City, State',
                controller: addressController,
              ),
              15.height,
              DateTimePicker(
                hint: 'Date of birth',
                height: 12,
                radius: 50,
                onTap: () async {
                  context.displayDialog(DateTimeDialog(
                      firstDate: DateTime(1900),
                      dob: true,
                      lastDate: DateTime.now()
                          .subtract(const Duration(days: 365 * 16)),
                      onSelect: (result) {
                        date.value = result;
                      }));
                },
                title: date.value?.formatDate(),
              ),
              15.height,
              InputField(
                label: 'Phone',
                controller: phoneController,
                phone: true,
                validator: (v) => null,
                hint: '(000) 000-0000',
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
                        dob: date.value?.toIso8601String(),
                        phoneNumber: phoneController.text);

                    // if (date.value == null) {
                    //   context.showSnackbarError('Please select dob');
                    //   return;
                    // }
                    if (result.accountType == AccountType.citizen) {
                      //create account;
                      context.read<AuthBloc>().add(RegisterEvent(data: result));
                      return;
                    }
                    context.read<OnboardingCubit>().setOnboarding(result);
                    if (kIsWeb) {
                      context.goNamed(
                        AppRoutes.organizationInfo.name,
                      );
                    } else {
                      context.pushRoute(PeerMentorOrganizationInfoScreen());
                    }
                  }
                },
              )
            ]);
      }),
    );
  }
}
