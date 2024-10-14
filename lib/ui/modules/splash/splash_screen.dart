import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/ui/components/buttons/primary_button.dart';
import 'package:reentry/ui/modules/authentication/signin_options.dart';
import '../../../generated/assets.dart';

class SplashScreen extends HookWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final showButton = useState(false);
    useEffect(() {
      Future.delayed(Duration(seconds: 2)).then((value) {
        showButton.value = true;
      });
    }, []);
    return Scaffold(
        backgroundColor: AppColors.black,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              Image.asset(
                Assets.imagesPeople,
                fit: BoxFit.cover,
              ),
              Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Reentry',
                      style: context.textTheme.titleLarge,
                    ),
                    Text(
                      'For The People\nFor Humanity',
                      style:
                          context.textTheme.bodyLarge?.copyWith(fontSize: 20),
                    ),
                    50.height,
                    if (showButton.value)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: PrimaryButton(
                          text: "Let's get started",
                          onPress: () {
                            context.pushReplace(SignInOptionsScreen());
                          },
                        ),
                      )
                  ],
                ),
              ).animate().fadeIn(
                  duration: Duration(milliseconds: 500),
                  delay: Duration(seconds: 2))
            ],
          ),
        ));
  }
}
