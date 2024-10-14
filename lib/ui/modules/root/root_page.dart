import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/ui/components/app_bar.dart';
import 'package:reentry/ui/modules/root/navigations/home_navigation_screen.dart';
import '../../../generated/assets.dart';
import 'navigations/messages_navigation_screen.dart';

class RootPage extends HookWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    const screens =  [
      HomeNavigationScreen(),
      MessagesNavigationScreen(),
      SizedBox(),
      SizedBox()
    ];
    final currentIndex = useState(0);
    return Scaffold(
        appBar: CustomAppbar(
          showBack: false,
          actions: [
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(Assets.svgPulse),
                5.width,
                Text('5',style: context.textTheme.displaySmall,),
                15.width,
              ],
            )
          ],
        ),
        body: screens[currentIndex.value].animate().slide(
            duration: Duration(milliseconds: 70),begin: Offset(1, 1)),
        backgroundColor: AppColors.black,
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
              height: 55,
              backgroundColor: Colors.black,
              indicatorColor: Colors.transparent,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              labelTextStyle:
                  MaterialStateProperty.resolveWith<TextStyle>((states) {
                if (states.contains(MaterialState.selected)) {
                  return const TextStyle(
                    color: AppColors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  );
                }
                return  TextStyle(
                  color: AppColors.white.withOpacity(.85),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                );
              })),
          child: Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: NavigationBar(
                selectedIndex: currentIndex.value,
                onDestinationSelected: (index) {
                  currentIndex.value = index;
                },
                destinations: [
                  NavigationDestination(
                      icon: SvgPicture.asset(Assets.svgVector0),
                      selectedIcon: SvgPicture.asset(Assets.svgVector1),
                      label: "Home"),
                  NavigationDestination(
                      icon: SvgPicture.asset(Assets.svgVector2),
                      selectedIcon: SvgPicture.asset(Assets.svgVector5),
                      label: "Messages"),
                  NavigationDestination(
                      icon: SvgPicture.asset(Assets.svgVector3),
                      selectedIcon: SvgPicture.asset(Assets.svgVector3),
                      label: "Resources"),
                  NavigationDestination(
                      icon: SvgPicture.asset(Assets.svgVector4),
                      selectedIcon: SvgPicture.asset(Assets.svgVector4),
                      label: "Settings"),
                ],
              )),
        ));
  }
}
