import 'package:easy_animate/animation/pulse_animation.dart';
import 'package:easy_animate/animation/shake_animation.dart';
import 'package:easy_animate/enum/animate_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/data/enum/emotions.dart';
import 'package:reentry/ui/components/buttons/primary_button.dart';
import 'package:reentry/ui/components/scaffold/onboarding_scaffold.dart';
import 'package:reentry/ui/modules/authentication/bloc/account_cubit.dart';
import 'package:reentry/ui/modules/root/navigations/home_navigation_screen.dart';

import '../../../generated/assets.dart';

class FeelingEntity {
  final String title;
  final String asset;
  final Emotions emotion;

  const FeelingEntity(
      {required this.title, required this.asset, required this.emotion});
}

class FeelingScreen extends HookWidget {
  const FeelingScreen({super.key, this.onboarding = true});

  final bool onboarding;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final selectedFeeling = useState<FeelingEntity?>(null);
    return OnboardingScaffold(
      title: "Hello Justin",
      description: "How are you feeling today?",
      showBack: !onboarding,
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
                children: getFeelingsWidget(emotion: selectedFeeling.value?.emotion, (result) {
                  selectedFeeling.value = result;
                }),
              )
            ],
          ),
        ),
        30.height,
        PrimaryButton(
          text: 'Continue',
          enable: selectedFeeling.value != null,
          onPress: () {
            if (selectedFeeling.value == null) {
              return;
            }
            context
                .read<AccountCubit>()
                .updateFeeling(selectedFeeling.value!.emotion);
            if (onboarding) {
              context.pushRemoveUntil(const HomeNavigationScreen());
              return;
            }
            context.pop();
          },
        )
      ],
    );
  }

  List<Widget> getFeelingsWidget(Function(FeelingEntity) onPress,
      {Emotions? emotion}) {
    return getFeelings()
        .map((e) => GestureDetector(
              onTap: () => onPress(e),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: emotion!=e.emotion
                        ? null
                        : const ShapeDecoration(
                            shape: CircleBorder(), color: AppColors.white),
                    padding: const EdgeInsets.all(10),
                    child: PulseAnimation(
                      durationMilliseconds: 1200,
                      child: Image.asset(e.asset),
                      animateType: AnimateType.loop,
                    ),
                  ),
                  3.height,
                  Text(e.title)
                ],
              ),
            ))
        .toList();
  }
}

List<FeelingEntity> getFeelings() => const [
      FeelingEntity(
          title: "Happy", asset: Assets.imagesHappy, emotion: Emotions.happy),
      FeelingEntity(
          title: "Sad", asset: Assets.imagesSad, emotion: Emotions.sad),
      FeelingEntity(
          title: "Angry", asset: Assets.imagesAngry, emotion: Emotions.angry),
      FeelingEntity(
          title: "Fear", asset: Assets.imagesFear, emotion: Emotions.fear),
      FeelingEntity(
          title: "Loved", asset: Assets.imagesLoved, emotion: Emotions.love),
      FeelingEntity(
          title: "Shame", asset: Assets.imagesShame, emotion: Emotions.shame),
      FeelingEntity(
          title: "Confusion",
          asset: Assets.imagesConfusion,
          emotion: Emotions.confusion),
      FeelingEntity(
          title: "Anxiety",
          asset: Assets.imagesAnxiety,
          emotion: Emotions.anxiety),
    ];
