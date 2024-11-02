import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/data/enum/account_type.dart';
import 'package:reentry/ui/components/app_bar.dart';
import 'package:reentry/ui/modules/appointment/bloc/appointment_cubit.dart';
import 'package:reentry/ui/modules/authentication/bloc/account_cubit.dart';
import 'package:reentry/ui/modules/clients/bloc/client_cubit.dart';
import 'package:reentry/ui/modules/messaging/bloc/message_cubit.dart';
import 'package:reentry/ui/modules/root/navigations/home_navigation_screen.dart';
import '../../../generated/assets.dart';
import '../mentor/mentor_request_screen.dart';
import '../messaging/bloc/conversation_cubit.dart';
import '../messaging/bloc/state.dart';
import 'navigations/messages_navigation_screen.dart';
import 'navigations/resource_navigation_screen.dart';
import 'navigations/settings_navigation_screen.dart';

class RootPage extends HookWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      context.read<AccountCubit>().readFromLocalStorage();
      context.read<AppointmentCubit>().fetchAppointments();
      context.read<ConversationUsersCubit>().fetchConversationUsers();
    }, []);
    final account = context.watch<AccountCubit>().state;

    final screens = [
      HomeNavigationScreen(),
      ConversationNavigation(),
      if (account?.accountType == AccountType.citizen)
        ResourcesNavigationScreen()
      else
        MentorRequestScreen(),
      SettingsNavigationScreen()
    ];
    final currentIndex = useState(0);
    return BlocBuilder<ConversationCubit, MessagingState>(builder: (context,state){

      return PopScope(
        onPopInvokedWithResult: (result,s){
          if(currentIndex.value!=0){
            currentIndex.value = 0;
            return;
          }
          context.pop();
        },
          child: Scaffold(
          appBar: CustomAppbar(
            showBack: false,
            actions: [
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(Assets.svgPulse),
                  5.width,
                  Text(
                    '5',
                    style: context.textTheme.displaySmall,
                  ),
                  15.width,
                ],
              )
            ],
          ),
          body: screens[currentIndex.value].animate().slide(
              duration: const Duration(milliseconds: 70),
              begin: const Offset(1, 1)),
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
                  return TextStyle(
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
                    BlocBuilder<ConversationCubit, MessagingState>(builder: (context,state){
                      int missedMessage = 0;
                      if(state is ConversationSuccessState){
                        missedMessage = state.data.where((e){
                          return e.lastMessageSenderId!=account?.userId && e.seen==false;
                        }).length;
                      }
                      return  NavigationDestination(
                          icon: BadgeComponent(icon: SvgPicture.asset(Assets.svgVector2), count: missedMessage),
                          selectedIcon:BadgeComponent(icon:  SvgPicture.asset(Assets.svgVector5), count: missedMessage),
                          label: "Messages");
                    }),
                    if (account?.accountType == AccountType.citizen)
                      NavigationDestination(
                          icon: SvgPicture.asset(Assets.svgVector3),
                          selectedIcon:
                          SvgPicture.asset(Assets.svgResourceChecked),
                          label: "Resources")
                    else
                      NavigationDestination(
                          icon: SvgPicture.asset(Assets.svgVector3),
                          selectedIcon:
                          SvgPicture.asset(Assets.svgResourceChecked),
                          label: "Client Request"),
                    NavigationDestination(
                        icon: SvgPicture.asset(Assets.svgVector4),
                        selectedIcon: SvgPicture.asset(Assets.svgSettingsChecked),
                        label: "Settings"),
                  ],
                )),
          )));
    });
  }
}
class BadgeComponent extends StatelessWidget {
  final Widget icon;
  final int count;

  const BadgeComponent({super.key, required this.icon, required this.count});

  @override
  Widget build(BuildContext context) {
    return messageBadge(count);
  }

  Widget messageBadge(int count, {bool red = false}) {
    String badgeText = count.toString();
    if (count > 10) {
      badgeText = '10+';
    }
    // return icon;
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 7, right: 10, left: 10),
          child: icon,
        ),
        if (count > 0)
          Positioned(
            top: 0,
            right: 0,
            child: badgeProvider(badgeText: badgeText),
          )
      ],
    );
  }
}

Widget badgeProvider(
    {bool red = true, double? height,double? fontSize, required String badgeText}) {
  return Container(
    height: height ?? 23,
    constraints: BoxConstraints(minWidth: height ?? 23),
    alignment: Alignment.center,
    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
    decoration: BoxDecoration(
        color: red ? Colors.red : AppColors.white,
        borderRadius: BorderRadius.circular(200)),
    child: Text(
      badgeText,
      textAlign: TextAlign.center,
      style:  TextStyle(
        color: Colors.white,
        fontSize:fontSize?? 12,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}