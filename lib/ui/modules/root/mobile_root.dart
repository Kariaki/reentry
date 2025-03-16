import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/data/enum/account_type.dart';
import 'package:reentry/data/shared/share_preference.dart';
import 'package:reentry/ui/components/app_bar.dart';
import 'package:reentry/ui/dialog/alert_dialog.dart';
import 'package:reentry/ui/modules/activities/bloc/activity_cubit.dart';
import 'package:reentry/ui/modules/appointment/bloc/appointment_cubit.dart';
import 'package:reentry/ui/modules/authentication/bloc/account_cubit.dart';
import 'package:reentry/ui/modules/clients/bloc/client_cubit.dart';
import 'package:reentry/ui/modules/profile/bloc/profile_cubit.dart';
import 'package:reentry/ui/modules/root/navigations/home_navigation_screen.dart';
import '../../../data/model/user_dto.dart';
import '../../../generated/assets.dart';
import '../activities/dialog/create_activity_dialog.dart';
import '../clients/bloc/client_state.dart';
import '../goals/bloc/goals_cubit.dart';
import '../messaging/bloc/conversation_cubit.dart';
import '../messaging/bloc/state.dart';
import '../messaging/start_conversation_screen.dart';
import '../organizations/organization_screen_mobile.dart';
import '../verification/bloc/submit_verification_question_cubit.dart';
import '../verification/dialog/verification_form_dialog.dart';
import 'navigations/messages_navigation_screen.dart';
import 'navigations/resource_navigation_screen.dart';
import 'navigations/settings_navigation_screen.dart';

class MobileRootPage extends StatefulWidget {
  const MobileRootPage({super.key});

  @override
  State<MobileRootPage> createState() => _MobileRootPageState();
}

class _MobileRootPageState extends State<MobileRootPage> {
  int currentIndex = 0;

  @override
  void initState() {
    context.read<AccountCubit>().init();
    super.initState();
    final currentUser = context.read<AccountCubit>().state;
    context.read<AccountCubit>()
      ..readFromLocalStorage()
      ..loadFromCloud();
    context.read<SubmitVerificationQuestionCubit>().fetchQuestions();
    context.read<AppointmentCubit>()
      ..fetchAppointmentInvitations(currentUser?.userId ?? '')
      ..fetchAppointments();
    context.read<ProfileCubit>().registerPushNotificationToken();
    if (currentUser?.accountType != AccountType.citizen) {
      context.read<ClientCubit>().fetchClients();
    }

    PersistentStorage.showActivity().then((value) {
      if (value) {
        context.displayDialog(const CreateActivityDialog());
      }
    });

    context.read<GoalCubit>()
      ..fetchGoals()
      ..fetchHistory();
    context.read<ActivityCubit>()
      ..fetchActivities()
      ..fetchHistory();
    context.read<ConversationCubit>()
      ..cancel()
      ..listenForConversationsUpdate()
      ..onNewMessage(context);
  }

  @override
  Widget build(BuildContext context) {
    final account = context.watch<AccountCubit>().state;

    final screens = [
      const HomeNavigationScreen(),
      const ConversationNavigation(),
      if (account?.accountType == AccountType.citizen)
        const ResourcesNavigationScreen()
      else
        const OrganizationScreenMobile(),
      const SettingsNavigationScreen()
    ];

    final width = MediaQuery.of(context).size.width;
    return BlocListener<AccountCubit, UserDto?>(
      listenWhen: (prev, current) =>
          prev?.verificationStatus != current?.verificationStatus,
      listener: (_, state) {
        print('kebilate -> user result');
        if (state?.accountType == AccountType.citizen) {
          if (state?.verificationStatus == null ||
              state?.verificationStatus == VerificationStatus.rejected.name ||
              state?.verificationStatus == VerificationStatus.none.name) {
            //todo show verification dialog
            print('kebilate -> show verification dialog');
            if (state?.verificationStatus == VerificationStatus.rejected.name) {
              final verification = state?.verification;
              context
                  .read<SubmitVerificationQuestionCubit>()
                  .seResponse(verification?.form ?? {});
              AppAlertDialog.show(context,
                  title: 'Rejected verification',
                  description:
                      'Your verification was rejected\n${verification?.rejectionReason ?? ''}\n please proceed to resubmit',
                  action: 'Resubmit', onClickAction: () {
                context.displayDialog(VerificationFormDialog());
              });
              return;
            }
            AppAlertDialog.show(context,
                title: 'Verification form',
                description: 'Please fill and submit the verification form.',
                action: 'Proceed', onClickAction: () {
              context.displayDialog(VerificationFormDialog());
            });
            //todo show modal for new verification
          }
        }
      },
      child: BlocBuilder<ConversationCubit, MessagingState>(
          builder: (context, state) {
        return PopScope(
            onPopInvokedWithResult: (result, s) {
              if (currentIndex != 0) {
                currentIndex = 0;
                return;
              }
              context.popRoute();
            },
            child: Scaffold(
                appBar: const CustomAppbar(
                  showBack: false,
                  actions: [],
                ),
                floatingActionButton: BlocBuilder<AccountCubit, UserDto?>(
                    builder: (context, state) {
                  final account = state;
                  if (account?.accountType != AccountType.citizen) {
                    return FloatingActionButton.extended(
                        onPressed: () {
                          context.pushRoute(const StartConversationScreen(
                            showBack: true,
                          ));
                        },
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.people),
                            5.width,
                            const Text(
                              'Your clients',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ));
                  }
                  return SizedBox();
                }),
                body: IndexedStack(
                  index: currentIndex,
                  children: screens,
                ),
                backgroundColor: AppColors.black,
                bottomNavigationBar: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: width >= 1024
                          ? MediaQuery.of(context).size.width / (1.5)
                          : double.infinity),
                  child: NavigationBarTheme(
                    data: NavigationBarThemeData(
                        height: 55,
                        backgroundColor: Colors.black,
                        indicatorColor: Colors.transparent,
                        labelBehavior:
                            NavigationDestinationLabelBehavior.alwaysShow,
                        labelTextStyle:
                            MaterialStateProperty.resolveWith<TextStyle>(
                                (states) {
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
                        padding: const EdgeInsets.only(bottom: 5),
                        child: NavigationBar(
                          selectedIndex: currentIndex,
                          onDestinationSelected: (index) {
                            setState(() {
                              currentIndex = index;
                            });
                          },
                          destinations: [
                            NavigationDestination(
                                icon: SvgPicture.asset(Assets.svgVector0),
                                selectedIcon:
                                    SvgPicture.asset(Assets.svgVector1),
                                label: "Home"),
                            BlocBuilder<ConversationCubit, MessagingState>(
                                builder: (context, state) {
                              int missedMessage = 0;
                              if (state is ConversationSuccessState) {
                                missedMessage = state.data.where((e) {
                                  return e.lastMessageSenderId !=
                                          account?.userId &&
                                      e.seen == false;
                                }).length;
                              }
                              return NavigationDestination(
                                  icon: BadgeComponent(
                                      icon: SvgPicture.asset(Assets.svgVector2),
                                      count: missedMessage),
                                  selectedIcon: BadgeComponent(
                                      icon: SvgPicture.asset(Assets.svgVector5),
                                      count: missedMessage),
                                  label: "Messages");
                            }),
                            if (account?.accountType == AccountType.citizen)
                              NavigationDestination(
                                  icon: SvgPicture.asset(Assets.svgVector3),
                                  selectedIcon: SvgPicture.asset(
                                      Assets.svgResourceChecked),
                                  label: "Resources")
                            else
                              BlocBuilder<RecommendedClientCubit, ClientState>(
                                builder: (context, state) {
                                  int count = 0;
                                  if (state is ClientDataSuccess) {
                                    count = state.data.length;
                                  }
                                  return NavigationDestination(
                                      icon: BadgeComponent(
                                          icon: SvgPicture.asset(
                                              Assets.svgVector3),
                                          count: count),
                                      selectedIcon: BadgeComponent(
                                          icon: SvgPicture.asset(
                                              Assets.svgResourceChecked),
                                          count: count),
                                      label: "Organizations");
                                },
                              ),
                            NavigationDestination(
                                icon: SvgPicture.asset(Assets.svgVector4),
                                selectedIcon:
                                    SvgPicture.asset(Assets.svgSettingsChecked),
                                label: "Settings"),
                          ],
                        )),
                  ),
                )));
      }),
    );
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
    {bool red = true,
    double? height,
    double? fontSize,
    required String badgeText}) {
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
      style: TextStyle(
        color: Colors.white,
        fontSize: fontSize ?? 12,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
