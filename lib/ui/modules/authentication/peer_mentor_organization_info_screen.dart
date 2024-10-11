import 'package:flutter/cupertino.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/ui/components/scaffold/onboarding_scaffold.dart';

import '../../../core/theme/style/app_styles.dart';
import '../../components/buttons/primary_button.dart';
import '../../components/input/input_field.dart';

class PeerMentorOrganizationInfoScreen extends StatelessWidget {
  const PeerMentorOrganizationInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppStyles.textTheme(context);
    return OnboardingScaffold(title: 'Account setup', children: [
      50.height,
      InputField(
        hint: 'Organisation name',
        label: 'Organisation',
      ),
      15.height,
      InputField(
        label: 'Organisation address',
        hint: 'Street, City, State',
      ),
      15.height,
      InputField(
        label: 'Supervisor\'s name',
        hint: 'First name, Last name',
      ),
      15.height,
      InputField(
        label: 'Supervisor\'s email',
        hint: 'hello@mail.com',
      ),
      50.height,
      PrimaryButton(
        text: 'Save',
        onPress: () {},
      )
    ]);
  }
}
