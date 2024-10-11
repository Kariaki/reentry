import 'package:flutter/cupertino.dart';
import 'package:reentry/core/const/app_constants.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/ui/components/app_bar.dart';
import 'package:reentry/ui/components/buttons/primary_button.dart';
import 'package:reentry/ui/components/pill_selector_component.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/components/scaffold/onboarding_scaffold.dart';

class AccountTypeScreen extends StatelessWidget {
  const AccountTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      description: 'Please select your identity to begin your journey',
      children: [
        50.height,
        PillSelector(options: AppConstants.accountType, onChange: (index) {}),
        30.height,
        PrimaryButton(text: 'Continue')
      ],
    );
  }
}
