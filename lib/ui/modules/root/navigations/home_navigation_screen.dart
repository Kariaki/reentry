import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/routes/routes.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/data/enum/account_type.dart';
import 'package:reentry/ui/components/buttons/app_button.dart';
import 'package:reentry/ui/components/container/box_container.dart';
import 'package:reentry/ui/components/container/outline_container.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/modules/appointment/view_appointments_screen.dart';
import 'package:reentry/ui/modules/authentication/bloc/account_cubit.dart';
import 'package:reentry/ui/modules/mentor/request_mentor_screen.dart';
import 'package:reentry/ui/modules/root/feeling_screen.dart';
import '../../../../generated/assets.dart';
import '../../appointment/select_appointment_user.dart';

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
final items = [
  const AppointmentFilterEntity(
      title: 'Upcoming\t',
      asset: Icon(
        Icons.access_time_rounded,
        color: AppColors.black,
        size: 18,
      )),
  const AppointmentFilterEntity(
    title: 'Missed\t',
    asset: Icon(
      Icons.watch_rounded,
      color: Colors.red,
      size: 18,
    ),
  ),
  AppointmentFilterEntity(
      title: 'Done\t',
      asset: SvgPicture.asset(
        Assets.svgGreenCheck,
        width: 18,
      )),
];
class _HomeNavigationScreenState extends State<HomeNavigationScreen> {
  @override
  Widget build(BuildContext context) {

    final textTheme = context.textTheme;
    //account cubit
    final accountCubit = context
        .watch<AccountCubit>()
        .state;
    return BaseScaffold(
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
                  const SizedBox(
                    height: 44,
                    width: 44,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(''),
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
                      Text(
                        '23rd Oct, 2024',
                        style: textTheme.displaySmall,
                      )
                    ],
                  )
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    getFeelings()
                            .where((e) => e.emotion == accountCubit?.emotion)
                            .firstOrNull
                            ?.asset ??
                        Assets.imagesLoved,
                    width: 21,
                  ),
                  10.width,
                  AppOutlineButton(
                    title: 'Change',
                    onPress: () {
                      context.push(FeelingScreen(
                        onboarding: false,
                      ));
                    },
                    verticalPadding: 3,
                    horizontalPadding: 7,
                  )
                ],
              )
            ],
          ),
          10.height,
          const Divider(
            color: AppColors.gray1,
            height: .4,
          ),
          30.height,
          label('Appointments'),
          15.height,
          BoxContainer(
              verticalPadding: 10,
              horizontalPadding: 10,
              radius: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: HookBuilder(builder: (context) {
                      final selectedTab = useState(0);
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(items.length, (index) {
                          final item = items[index];
                          return tabComponent(
                              item, index, selectedTab.value == index,
                              onPress: () {
                            selectedTab.value = index;
                          });
                        }),
                      );
                    }),
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 2,
                    separatorBuilder: (context, index) => 0.height,
                    itemBuilder: (context, index) {
                      return appointmentComponent();
                    },
                  )
                ],
              )),
          10.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppOutlineButton(
                  title: 'Create new',
                  onPress: () {
                    context.push(AppointmentUserList());
                  }),
              10.width,
              AppOutlineButton(title: 'View All', onPress: () {

                context.push(ViewAppointmentsScreen());
              }),
            ],
          ),
          20.height,
          label('Habit Tracker'),
          20.height,
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                mainAxisExtent: 130),
            itemCount: accountCubit?.accountType == AccountType.citizen
                ? _habitOptions.length
                : _habitOptionForNonCitizens.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final items = accountCubit?.accountType == AccountType.citizen
                  ? _habitOptions
                  : _habitOptionForNonCitizens;
              final e = items[index];
              return buildBoxContainer(e, onPress: () {
                final route = AppRoutes.routes[e.route];
                if (route == null) {
                  return;
                }
                context.push(route);
              });
            },
          ),
          if (accountCubit?.accountType == AccountType.citizen) ...[
            30.height,
            label('Request a mentor'),
            15.height,
            BoxContainer(
                verticalPadding: 10,
                horizontalPadding: 10,
                radius: 15,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  leading: Image.asset(Assets.imagesGetMentor),
                  title: Text(
                    'Get a new mentor',
                    style: textTheme.titleSmall,
                  ),
                  subtitle: Text(
                    'A mentor will guide you to become the best of yourself',
                    style: textTheme.displaySmall?.copyWith(fontSize: 10),
                  ),
                  trailing: AppOutlineButton(
                      title: 'Send request',
                      onPress: () {
                        context.push(RequestMentorScreen());
                      }),
                ))
          ],
          50.height
        ],
      ),
    ));
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
          10.height,
          Text(
            e.title,
            style: theme.bodyMedium?.copyWith(fontFamily: 'InterBold'),
          ),
          10.height,
          Text(
            e.description,
            style: theme.displaySmall,
          )
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
            title: 'Progress',
            description: 'Track your growth',
            route: AppRoutes.progress,
            assets: Assets.imagesGrowth),
        HabitTrackerEntity(
            title: 'Daily actions',
            description: 'View your daily steps',
            route: AppRoutes.dailyActions,
            assets: Assets.imagesDailyAction),
        HabitTrackerEntity(
            title: 'Calender',
            description: 'View all your activities',
            route: AppRoutes.calender,
            assets: Assets.imagesCalender),
      ];

  List<HabitTrackerEntity> get _habitOptionForNonCitizens => const [
        HabitTrackerEntity(
            title: 'Clients',
            description: 'View your clients',
            route: AppRoutes.clients,
            assets: Assets.imagesGoals),
        HabitTrackerEntity(
            title: 'Calender',
            description: 'View all your activities',
            route: AppRoutes.calender,
            assets: Assets.imagesCalender),
      ];
}

Widget tabComponent(AppointmentFilterEntity data, int index, bool selected,
    {required VoidCallback onPress}) {
  return Builder(builder: (context){
    final textTheme = context.textTheme;
    final textStyle = textTheme.displaySmall?.copyWith(
      color: selected ? AppColors.black : null,
      fontWeight: FontWeight.bold,
    );
    final child = Row(
      children: [
        if (!selected && index == 0)
          const Icon(
            Icons.access_time_rounded,
            color: AppColors.white,
            size: 18,
          )
        else
          data.asset,
        5.width,
        Text(
          data.title,
          style: textStyle,
        )
      ],
    );
    if (selected) {
      return BoxContainer(
        onPress: onPress,
        horizontalPadding: 10,
        color: AppColors.white,
        verticalPadding: 5,
        child: child,
      );
    }
    return OutlineContainer(
        onPress: onPress,
        verticalPadding: 5,
        horizontalPadding: 10,
        child: child);
  });
}

Widget label(String text) {
  return Builder(builder: (context){
    final textTheme = context.textTheme;
    return Text(
      text,
      style: textTheme.titleSmall,
    );
  });
}

Widget appointmentComponent() {
  return Builder(builder: (context){
    final theme = context.textTheme;
    return ListTile(
      leading: const SizedBox(
        height: 40,
        width: 40,
        child: CircleAvatar(
          backgroundImage: NetworkImage('url'),
        ),
      ),
      contentPadding: const EdgeInsets.all(0),
      title: Text(
        'Jillian Jacob',
        style: theme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        'Peer Mentor',
        style: theme.bodyMedium?.copyWith(fontWeight: FontWeight.w400),
      ),
      trailing: Text('10:30am',
          style: theme.bodyMedium?.copyWith(fontWeight: FontWeight.w400)),
    );
  });
}