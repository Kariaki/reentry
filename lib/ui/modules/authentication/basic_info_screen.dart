import 'package:flutter/cupertino.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/ui/components/scaffold/onboarding_scaffold.dart';
import 'package:reentry/ui/modules/authentication/peer_mentor_organization_info_screen.dart';

import '../../../core/theme/style/app_styles.dart';
import '../../components/buttons/primary_button.dart';
import '../../components/input/input_field.dart';
import '../../components/input/password_field.dart';

class BasicInfoScreen extends StatelessWidget {
  const BasicInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppStyles.textTheme(context);
    return OnboardingScaffold(title: 'Account setup', children: [
      50.height,
      InputField(
        hint: 'First name, Last name',
        label: 'Full name',
      ),
      15.height,
      InputField(
        hint: 'Address',
        label: 'Street, City, State',
      ),
      15.height,
      InputField(
        label: 'Phone',
        hint: '+1-0000-0000-0000',
      ),
      50.height,
      PrimaryButton(
        text: 'Save',
        onPress: () => context.push(PeerMentorOrganizationInfoScreen()),
      )
    ]);
  }
}
