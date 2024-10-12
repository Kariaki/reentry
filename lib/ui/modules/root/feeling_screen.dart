import 'package:easy_animate/animation/pulse_animation.dart';
import 'package:easy_animate/animation/shake_animation.dart';
import 'package:easy_animate/enum/animate_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/ui/components/buttons/primary_button.dart';
import 'package:reentry/ui/components/scaffold/onboarding_scaffold.dart';
import 'package:reentry/ui/modules/root/navigations/home_navigation_screen.dart';

import '../../../generated/assets.dart';

class FeelingEntity {
  final String title;
  final String asset;

  const FeelingEntity({required this.title, required this.asset});
}

class FeelingScreen extends HookWidget {
  const FeelingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    return OnboardingScaffold(
      title: "Hello Justin",
      description: "How are you feeling today?",
      showBack: false,
      children: [
        Container(
          width: double.infinity,
          height: 300,
          margin: const EdgeInsets.symmetric(vertical: 30),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
          decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: const BorderSide(color: AppColors.white))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "I am feeling...",
                style: textTheme.bodyMedium,
              ),
              20.height,
              GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, mainAxisSpacing: 20),
                shrinkWrap: true,
                children: getFeelingsWidget((result) {}),
              )
            ],
          ),
        ),
        30.height,
        PrimaryButton(
          text: 'Continue',
          onPress: () => context.push(HomeNavigationScreen()),
        )
      ],
    );
  }

  List<Widget> getFeelingsWidget(Function(FeelingEntity) onPress) {
    return _getFeelings()
        .map((e) => GestureDetector(
              onTap: () => onPress(e),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  PulseAnimation(
                    durationMilliseconds: 1200,
                    child: Image.asset(e.asset),
                    animateType: AnimateType.loop,
                  ),
                  3.height,
                  Text(e.title)
                ],
              ),
            ))
        .toList();
  }

  List<FeelingEntity> _getFeelings() => const [
        FeelingEntity(title: "Happy", asset: Assets.imagesHappy),
        FeelingEntity(title: "Sad", asset: Assets.imagesSad),
        FeelingEntity(title: "Angry", asset: Assets.imagesAngry),
        FeelingEntity(title: "Fear", asset: Assets.imagesFear),
        FeelingEntity(title: "Loved", asset: Assets.imagesLoved),
        FeelingEntity(title: "Shame", asset: Assets.imagesShame),
        FeelingEntity(title: "Confusion", asset: Assets.imagesConfusion),
        FeelingEntity(title: "Anxiety", asset: Assets.imagesAnxiety),
      ];
}
