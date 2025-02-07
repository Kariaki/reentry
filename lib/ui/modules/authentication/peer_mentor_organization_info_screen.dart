import 'package:beamer/beamer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/routes/routes.dart';
import 'package:reentry/data/enum/account_type.dart';
import 'package:reentry/ui/components/scaffold/onboarding_scaffold.dart';
import 'package:reentry/ui/modules/authentication/bloc/authentication_state.dart';
import 'package:reentry/ui/modules/authentication/onboarding_select_service.dart';
import 'package:reentry/ui/modules/authentication/onboarding_success.dart';
import '../../../core/theme/style/app_styles.dart';
import '../../components/buttons/primary_button.dart';
import '../../components/input/input_field.dart';
import 'bloc/auth_events.dart';
import 'bloc/authentication_bloc.dart';
import 'bloc/onboarding_cubit.dart';

class PeerMentorOrganizationInfoScreen extends HookWidget {


  const PeerMentorOrganizationInfoScreen({super.key,});

  @override
  Widget build(BuildContext context) {

    final data = context.read<OnboardingCubit>().state!;
      debugPrint('Data retrieved in PeerMentorOrganizationInfoScreen: $data');
    final key = GlobalKey<FormState>();
    final theme = AppStyles.textTheme(context);
    final organizationController = useTextEditingController();
    final organizationAddressController = useTextEditingController();
    final jobTitleController = useTextEditingController();
    final supervisorNameController = useTextEditingController();
    final supervisorEmailController = useTextEditingController();
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (_, state) {
        if (state is RegistrationSuccessFull) {
          if (kIsWeb) {
           context.goNamed(AppRoutes.success.name);
          } else {
              context.pushRemoveUntil(const OnboardingSuccess());
              return;

          }
        }
        if (state is AuthError) {
          context.showSnackbarError(state.message);
        }
      },
      builder: (context, state) {
        return OnboardingScaffold(
            formKey: key,
            title: 'Account setup',
            children: [
              50.height,
              InputField(
                hint: 'Organisation name',
                controller: organizationController,
                label: 'Organisation',
              ),
              15.height,
              InputField(
                label: 'Organisation address',
                controller: organizationAddressController,
                hint: 'Street, City, State',
              ),
              15.height,
              InputField(
                label: 'Job title',
                controller: jobTitleController,
                hint: 'Job title',
              ),
              15.height,
              InputField(
                label: 'Supervisor\'s name',
                controller: supervisorNameController,
                hint: 'First name, Last name',
              ),
              15.height,
              InputField(
                label: 'Supervisor\'s email',
                controller: supervisorEmailController,
                hint: 'hello@mail.com',
              ),
              50.height,
              PrimaryButton(
                text: 'Save',
                loading: state is AuthLoading,
                onPress: () {
                  if (key.currentState!.validate()) {
                    final result = data.copyWith(
                        organizationAddress:
                            organizationAddressController.text,
                        organization: organizationController.text,
                        jobTitle: jobTitleController.text,
                        supervisorsName: supervisorNameController.text,
                        supervisorsEmail: supervisorEmailController.text);
                    if(data.accountType!=AccountType.citizen){

                      context.pushRoute(OnboardingSelectService());
                      return;
                    }
                    context
                        .read<AuthBloc>()
                        .add(RegisterEvent(data: result));
                  }
                },
              )
            ]);
      },
    );
  }
}
