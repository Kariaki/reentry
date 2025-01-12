import 'package:beamer/beamer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/routes/routes.dart';
import 'package:reentry/ui/components/app_bar.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/components/success_screen_component.dart';
import 'package:reentry/ui/modules/root/feeling_screen.dart';

class OnboardingSuccess extends HookWidget {
  const OnboardingSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      Future.delayed(const Duration(seconds: 1, milliseconds: 500))
          .then((value) {
        if (kIsWeb) {
          // Beamer.of(context).beamToNamed('/feeling');
          context.goNamed(AppRoutes.feeling.name);
        } else {
          context.pushReplace(const FeelingScreen(
            onboarding: true,
          ));
        }
      });
    }, []);
    return const BaseScaffold(
      appBar: CustomAppbar(
        showBack: false,
      ),
      child: SuccessScreenComponent(title: "You're all set"),
    );
  }
}
