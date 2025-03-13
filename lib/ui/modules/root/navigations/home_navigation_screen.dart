import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:reentry/core/const/app_constants.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/routes/routes.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/data/enum/account_type.dart';
import 'package:reentry/data/enum/emotions.dart';
import 'package:reentry/data/model/user_dto.dart';
import 'package:reentry/ui/components/buttons/app_button.dart';
import 'package:reentry/ui/components/container/box_container.dart';
import 'package:reentry/ui/components/container/outline_container.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/modules/activities/activity_screen.dart';
import 'package:reentry/ui/modules/appointment/bloc/appointment_cubit.dart';
import 'package:reentry/ui/modules/appointment/select_appointment_user_screen_non_client.dart';
import 'package:reentry/ui/modules/appointment/view_appointments_screen.dart';
import 'package:reentry/ui/modules/authentication/account_type_screen.dart';
import 'package:reentry/ui/modules/authentication/bloc/account_cubit.dart';
import 'package:reentry/ui/modules/careTeam/request_mentor_screen.dart';
import 'package:reentry/ui/modules/root/component/activity_progress_component.dart';
import 'package:reentry/ui/modules/root/component/analytic_container.dart';
import 'package:reentry/ui/modules/root/component/change_feeling_card_component.dart';
import 'package:reentry/ui/modules/root/component/feeling_list_item.dart';
import 'package:reentry/ui/modules/root/feeling_screen.dart';
import 'package:reentry/ui/modules/shared/cubit/admin_cubit.dart';
import 'package:reentry/ui/modules/verification/bloc/submit_verification_question_cubit.dart';
import 'package:reentry/ui/modules/verification/dialog/verification_form_review_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../generated/assets.dart';
import '../../../components/add_button.dart';
import '../../../components/error_component.dart';
import '../../../components/loading_component.dart';
import '../../activities/bloc/activity_cubit.dart';
import '../../activities/bloc/activity_state.dart';
import '../../activities/components/activity_component.dart';
import '../../activities/create_activity_screen.dart';
import '../../activities/dialog/create_activity_dialog.dart';
import '../../admin/admin_stat_cubit.dart';
import '../../admin/admin_stat_state.dart';
import '../../appointment/component/appointment_component.dart';
import '../../appointment/select_appointment_user.dart';
import '../../profile/profile_screen.dart';
import '../../verification/dialog/verification_form_dialog.dart';

class HabitTrackerEntity {
  final String title;
  final String assets;
  final String route;
  final String description;

  const HabitTrackerEntity(
      {required this.title,
      required this.description,
      required this.assets,
      required this.route});
}

class AppointmentFilterEntity {
  final String title;
  final Widget asset;

  const AppointmentFilterEntity({required this.title, required this.asset});
}

class HomeNavigationScreen extends StatefulWidget {
  const HomeNavigationScreen({super.key});

  @override
  State<HomeNavigationScreen> createState() => _HomeNavigationScreenState();
}

class _HomeNavigationScreenState extends State<HomeNavigationScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final account = context.read<AccountCubit>().state;
    if (account?.accountType != AccountType.citizen) {
      context.read<AdminStatCubit>().fetchStats();
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    //account cubit
    final accountCubit = context.watch<AccountCubit>().state;
    final feelingTimeLine = accountCubit?.feelingTimeLine ?? [];
    return BaseScaffold(
        child: RefreshIndicator(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  15.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              context.pushRoute(ProfileScreen());
                            },
                            child: SizedBox(
                              height: 44,
                              width: 44,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    accountCubit?.avatar ??
                                        AppConstants.avatar),
                              ),
                            ),
                          ),
                          10.width,
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Hello, ${accountCubit?.name.split(' ')[0]}!",
                                style: textTheme.titleSmall,
                              ),
                              5.height,
                              if (accountCubit?.verificationStatus != null &&
                                  accountCubit?.verificationStatus !=
                                      VerificationStatus.none.name)
                                Builder(builder: (context) {
                                  String text = 'Verification Pending';
                                  Color color = Colors.orange;
                                  IconData icon = Icons.pending;
                                  if (accountCubit?.verificationStatus ==
                                      VerificationStatus.rejected.name) {
                                    text = 'Verification Rejected';
                                    icon = Icons.cancel;
                                    color = Colors.red;
                                  }
                                  if (accountCubit?.verificationStatus ==
                                      VerificationStatus.verified.name) {
                                    text = 'Verified';
                                    icon = Icons.verified;
                                    color = Colors.green;
                                  }

                                  return Row(
                                    children: [
                                      Icon(
                                        icon,
                                        color: color,
                                      ),
                                      5.width,
                                      InkWell(
                                        onTap: () {
                                          context
                                              .read<
                                                  SubmitVerificationQuestionCubit>()
                                              .seResponse(accountCubit
                                                      ?.verification?.form ??
                                                  {});
                                          if (accountCubit
                                                      ?.verificationStatus ==
                                                  VerificationStatus
                                                      .pending.name ||
                                              accountCubit
                                                      ?.verificationStatus ==
                                                  VerificationStatus
                                                      .rejected.name) {
                                            context.displayDialog(
                                                VerificationFormDialog());
                                            return;
                                          }
                                          if (accountCubit
                                                  ?.verificationStatus ==
                                              VerificationStatus
                                                  .verified.name) {
                                            context.displayDialog(
                                                VerificationFormReviewDialog(
                                              form: accountCubit
                                                      ?.verification?.form ??
                                                  {},
                                              user: accountCubit,
                                            ));
                                            return;
                                          }
                                        },
                                        child: Text(
                                          text,
                                          style: textTheme.displaySmall
                                              ?.copyWith(
                                                  color: color,
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    ],
                                  );
                                })
                              else
                                Text(
                                  DateTime.now().formatDate(),
                                  style: textTheme.displaySmall,
                                )
                            ],
                          )
                        ],
                      ),
                      if (accountCubit?.accountType == AccountType.citizen)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              getFeelings()
                                      .where((e) =>
                                          e.emotion == accountCubit?.emotion)
                                      .firstOrNull
                                      ?.asset ??
                                  Assets.imagesLoved,
                              width: 30,
                            ),
                          ],
                        )
                    ],
                  ),
                  10.height,
                  const Divider(
                    color: AppColors.gray1,
                    height: .4,
                  ),
                  if (accountCubit?.accountType == AccountType.citizen) ...[
                    20.height,
                    const ChangeFeelingCardComponent(),
                    20.height
                  ],
                  if (feelingTimeLine.isNotEmpty &&
                      accountCubit?.accountType == AccountType.citizen)
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        label('Track your feelings'),
                        10.height,
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final item = feelingTimeLine[index];
                            return FeelingListItem(
                                feelingDto: FeelingDto(
                                    date: item.date, emotion: item.emotion));
                          },
                          itemCount: feelingTimeLine.length > 3
                              ? 3
                              : feelingTimeLine.length,
                        ),
                        if (feelingTimeLine.length > 3)
                          Align(
                            alignment: Alignment.centerRight,
                            child: AppFilledButton(
                                title: 'View All',
                                onPress: () {
                                  context.pushRoute(const FeelingScreen());
                                }),
                          ),
                        30.height,
                      ],
                    ),
                  if (accountCubit?.accountType == AccountType.citizen) ...[
                    BlocBuilder<ActivityCubit, ActivityCubitState>(
                        builder: (context, state) {
                      return BoxContainer(
                          horizontalPadding: 10,
                          verticalPadding: 10,
                          filled: false,
                          constraints: const BoxConstraints(
                              minHeight: 150, minWidth: double.infinity),
                          radius: 10,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  label('Daily activities'),
                                  AddButton(onTap: () {
                                    context.pushRoute(
                                        const CreateActivityScreen());
                                  })
                                ],
                              ),
                              5.height,
                              Builder(builder: (context) {
                                if (state is ActivityLoading) {
                                  return const LoadingComponent();
                                }
                                if (state.state is ActivitySuccess) {
                                  if (state.activity.isEmpty) {
                                    return ErrorComponent(
                                        showButton: true,
                                        title: "Oops!",
                                        description:
                                            "You do not have any saved activities yet",
                                        actionButtonText:
                                            'Create new activities',
                                        onActionButtonClick: () {
                                          context.pushRoute(
                                              const CreateActivityScreen());
                                        });
                                  }
                                  return Column(
                                    children: [
                                      ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: (state.activity.length > 3
                                            ? 3
                                            : state.activity.length),
                                        itemBuilder: (context, index) {
                                          final activity =
                                              state.activity[index];
                                          return ActivityComponent(
                                              activity: activity);
                                        },
                                      ),
                                      if (state.activity.length > 3)
                                        Align(
                                          alignment: Alignment.center,
                                          child: InkWell(
                                            onTap: () {
                                              context.pushRoute(
                                                  const ActivityScreen());
                                            },
                                            child: const Text(
                                              "View All",
                                              style: TextStyle(
                                                  decoration:
                                                      TextDecoration.underline),
                                            ),
                                          ),
                                        )
                                    ],
                                  );
                                }

                                return ErrorComponent(
                                    showButton: false,
                                    title: "Something went wrong",
                                    description: "Please try again!",
                                    onActionButtonClick: () {
                                      context
                                          .read<ActivityCubit>()
                                          .fetchActivities();
                                    });
                              })
                            ],
                          ));
                    }),
                    10.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AppFilledButton(
                            title: 'View All',
                            onPress: () {
                              context.pushRoute(const ActivityScreen());
                            }),
                      ],
                    ),
                    30.height
                  ],
                  if (accountCubit?.accountType != AccountType.citizen) ...[
                    30.height,
                    Text(
                      'Overview',
                      style: textTheme.titleSmall,
                    ),
                    10.height,
                    BlocBuilder<AdminStatCubit, AdminStatCubitState>(
                        builder: (context, state) {
                      AdminStatEntity data = const AdminStatEntity(
                          appointments: 0, careTeam: 0, totalCitizens: 0);
                      if (state is AdminStatSuccess) {
                        data = state.data;
                      }
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 20),
                        decoration: ShapeDecoration(
                            shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                    color: AppColors.greyWhite, width: .7))),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            careTeamDashboardData(
                                'Total citizens', data.totalCitizens),
                            10.width,
                            Container(
                              height: 50,
                              color: Colors.white,
                              width: .5,
                            ),
                            10.width,
                            careTeamDashboardData(
                                'Appointments', data.appointments)
                          ],
                        ),
                      );
                    }),
                    30.height,
                  ],
                  const AppointmentComponent(showAll: false),
                  10.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AppFilledButton(
                          title: 'View All',
                          onPress: () {
                            context.pushRoute(const ViewAppointmentsScreen());
                          }),
                    ],
                  ),
                  if (accountCubit?.accountType == AccountType.citizen) ...[
                    20.height,
                    label('Habit Tracker'),
                    20.height,
                    GridView.builder(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                              mainAxisExtent: 140),
                      itemCount:
                          accountCubit?.accountType == AccountType.citizen
                              ? _habitOptions.length
                              : _habitOptionForNonCitizens.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final items =
                            accountCubit?.accountType == AccountType.citizen
                                ? _habitOptions
                                : _habitOptionForNonCitizens;
                        final e = items[index];
                        return buildBoxContainer(e, onPress: () {
                          final route = AppRoutes.routes[e.route];
                          if (route == null) {
                            return;
                          }
                          context.pushRoute(route);
                        });
                      },
                    )
                  ],
                  // if (accountCubit?.accountType == AccountType.citizen) ...[
                  //   30.height,
                  //   label('Request a mentor'),
                  //   15.height,
                  //   BoxContainer(
                  //       verticalPadding: 10,
                  //       horizontalPadding: 10,
                  //       radius: 15,
                  //       child: ListTile(
                  //         contentPadding: const EdgeInsets.all(0),
                  //         leading: Image.asset(Assets.imagesGetMentor),
                  //         // title: Text(
                  //         //   'Get a new mentor',
                  //         //   style: textTheme.titleSmall,
                  //         // ),
                  //         title: Text(
                  //           'Change can be overwhelming, and you don’t have to do it alone. Request professional guidance?',
                  //           style: textTheme.displaySmall?.copyWith(fontSize: 11),
                  //         ),
                  //         trailing: AppOutlineButton(
                  //             title: 'Send request',
                  //             onPress: () {
                  //               context.pushRoute(const RequestMentorScreen());
                  //             }),
                  //       ))
                  // ],
                  50.height
                ],
              ),
            ),
            onRefresh: () async {
              await context.read<AccountCubit>().loadFromCloud();
            }));
  }

  Widget careTeamDashboardData(String title, int value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: context.textTheme.bodyMedium?.copyWith(fontSize: 16),
        ),
        10.height,
        Text(
          NumberFormat().format(value),
          style: context.textTheme.bodyMedium
              ?.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
        )
      ],
    );
  }

  Widget buildBoxContainer(HabitTrackerEntity e,
      {required VoidCallback onPress}) {
    final theme = context.textTheme;
    return BoxContainer(
      onPress: onPress,
      radius: 10,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(e.assets),
          8.height,
          Text(
            e.title,
            style: theme.bodyMedium?.copyWith(fontFamily: 'InterBold'),
          ),
          8.height,
          Expanded(
              child: Text(
            e.description,
            style: theme.displaySmall,
          ))
        ],
      ),
    );
  }

  List<HabitTrackerEntity> get _habitOptions => const [
        HabitTrackerEntity(
            title: 'Goals',
            description: 'View your goals',
            route: AppRoutes.goals,
            assets: Assets.imagesGoals),
        HabitTrackerEntity(
            title: 'Personal growth',
            description: 'View your personal vision',
            route: AppRoutes.progress,
            assets: Assets.imagesGrowth),
        HabitTrackerEntity(
            title: 'Daily actions',
            description: 'View your daily progress',
            route: AppRoutes.dailyActions,
            assets: Assets.imagesDailyAction),
      ];

  List<HabitTrackerEntity> get _habitOptionForNonCitizens => const [
        // HabitTrackerEntity(
        //     title: 'Clients',
        //     description: 'View your clients',
        //     route: AppRoutes.clients,
        //     assets: Assets.imagesGoals),
        // HabitTrackerEntity(
        //     title: 'Calendar',
        //     description: 'View all your activities',
        //     route: AppRoutes.calender,
        //     assets: Assets.imagesCalender),
      ];
}

Widget label(String text) {
  return Builder(builder: (context) {
    final textTheme = context.textTheme;
    return Text(
      text,
      style: textTheme.titleSmall?.copyWith(fontSize: 16),
    );
  });
}

Event buildEvent() {
  return Event(
    title: 'Team Meeting',
    description: 'Discuss project updates',
    location: 'Office',
    startDate: DateTime(2024, 1, 1, 10, 0),
    // Local time
    endDate: DateTime(2024, 1, 1, 11, 0),
    allDay: false,
  );
}

Future<void> createGoogleCalendarEvent() async {
  Add2Calendar.addEvent2Cal(buildEvent());
}
