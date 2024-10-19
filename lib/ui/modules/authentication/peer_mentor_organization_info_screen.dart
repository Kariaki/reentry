import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/ui/components/scaffold/onboarding_scaffold.dart';
import 'package:reentry/ui/modules/authentication/bloc/authentication_state.dart';
import 'package:reentry/ui/modules/authentication/onboarding_success.dart';
import 'package:reentry/ui/modules/root/feeling_screen.dart';

import '../../../core/theme/style/app_styles.dart';
import '../../components/buttons/primary_button.dart';
import '../../components/input/input_field.dart';

class PeerMentorOrganizationInfoScreen extends HookWidget {
  final OnboardingEntity data;

  const PeerMentorOrganizationInfoScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<FormState>();
    final theme = AppStyles.textTheme(context);
    final organizationController = useTextEditingController();
    final organizationAddressController = useTextEditingController();
    final supervisorNameController = useTextEditingController();
    final supervisorEmailController = useTextEditingController();
    return OnboardingScaffold(
        formKey: key,
        title: 'Account setup', children: [
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
        onPress: (){
          if(key.currentState!.validate()){
            context.pushRemoveUntil(FeelingScreen());
          }
        },
      )
    ]);
  }
}
