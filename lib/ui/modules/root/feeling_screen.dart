import 'package:beamer/beamer.dart';
import 'package:easy_animate/animation/pulse_animation.dart';
import 'package:easy_animate/animation/shake_animation.dart';
import 'package:easy_animate/enum/animate_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/routes/routes.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/data/enum/emotions.dart';
import 'package:reentry/ui/components/buttons/primary_button.dart';
import 'package:reentry/ui/components/scaffold/onboarding_scaffold.dart';
import 'package:reentry/ui/modules/authentication/bloc/account_cubit.dart';
import 'package:reentry/ui/modules/root/cubit/feelings_cubit.dart';
import 'package:reentry/ui/modules/root/navigations/home_navigation_screen.dart';
import 'package:reentry/ui/modules/root/root_page.dart';

import '../../../generated/assets.dart';
import 'mobile_root.dart';

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
    // final accountCubit = context
    //     .watch<AccountCubit>()
    //     .state;
    return OnboardingScaffold(
      title: "Hello, Welcome!",
      description: "How are you feeling today?",
      showBack: !onboarding,
      children: [
        Container(
          width: double.infinity,
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
                children: getFeelingsWidget(
                    emotion: selectedFeeling.value?.emotion, (result) {
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
            context.read<FeelingsCubit>().setFeeling();
            context
                .read<AccountCubit>()
                .updateFeeling(selectedFeeling.value!.emotion);
            if (onboarding) {
              if (kIsWeb) {
                context.popRoute();
              } else {
                context.pushRemoveUntil(const MobileRootPage());
              }

              return;
            }
            context.popRoute();
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
                    decoration: emotion != e.emotion
                        ? null
                        : const ShapeDecoration(
                            shape: CircleBorder(), color: AppColors.white),
                    padding: const EdgeInsets.all(8),
                    child: PulseAnimation(
                      durationMilliseconds: 1200,
                      animateType: AnimateType.loop,
                      child: Image.asset(e.asset),
                    ),
                  ),
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
          title: "Depressed",
          asset: Assets.imagesAngry,
          emotion: Emotions.angry),
      FeelingEntity(
          title: "Joyful", asset: Assets.imagesLoved, emotion: Emotions.love),
      FeelingEntity(
          title: "Neutral",
          asset: Assets.imagesConfusion,
          emotion: Emotions.confusion),
    ];
