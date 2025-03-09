import 'package:beamer/beamer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/routes/routes.dart';
import 'package:reentry/data/enum/account_type.dart';
import 'package:reentry/ui/components/app_bar.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/components/success_screen_component.dart';
import 'package:reentry/ui/modules/authentication/bloc/account_cubit.dart';
import 'package:reentry/ui/modules/authentication/bloc/onboarding_cubit.dart';
import 'package:reentry/ui/modules/root/feeling_screen.dart';
import 'package:reentry/ui/modules/root/mobile_root.dart';

class OnboardingSuccess extends HookWidget {
  const OnboardingSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    final entity = context.read<OnboardingCubit>().state;
    useEffect(() {
      context.read<AccountCubit>().fetchUsers();
      Future.delayed(const Duration(seconds: 1, milliseconds: 500))
          .then((value) {
        if (entity?.accountType == AccountType.citizen) {
          if (kIsWeb) {
            // Beamer.of(context).beamToNamed('/feeling');
            context.goNamed(AppRoutes.feeling.name);
          } else {
            context.pushReplace(const FeelingScreen(
              onboarding: true,
            ));
          }
        } else {
          if (kIsWeb) {
            return;
          }
          context.pushRemoveUntil(const MobileRootPage());
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
