import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/routes/routes.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/ui/components/app_bar.dart';
import 'package:reentry/ui/components/buttons/app_button.dart';
import 'package:reentry/ui/components/container/box_container.dart';
import 'package:reentry/ui/components/container/outline_container.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import '../../../../generated/assets.dart';

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
  Widget build(BuildContext context) {
    final items = [
      const AppointmentFilterEntity(title: 'Upcoming\t', asset: Icon(Icons.access_time_rounded,color: AppColors.black,size: 18,)),
      const AppointmentFilterEntity(title: 'Missed\t', asset: Icon(Icons.watch_rounded,color: Colors
        .red,size: 18,),),
      AppointmentFilterEntity(title: 'Done\t', asset: SvgPicture.asset(Assets.svgGreenCheck,width: 18,)),
    ];
    final textTheme = context.textTheme;
    return BaseScaffold(
        appBar: const CustomAppbar(
          showBack: false,
          actions: [],
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _label('Appointments'),

              15.height,
              BoxContainer(
                  verticalPadding: 10,
                  horizontalPadding: 10,
                  radius: 15,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20,vertical:
                      10),
                      child:   HookBuilder(builder: (context) {
                        final selectedTab = useState(0);
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(items.length, (index) {
                            final item = items[index];
                            return _tabComponent(
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
                        itemCount: 4,
                        separatorBuilder: (context, index) => 1.height,
                        itemBuilder: (context, index) {
                          return _appointmentComponent();
                        },
                      )
                    ],
                  )),
              5.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppOutlineButton(title: 'Create new', onPress: () {}),
                  10.width,
                  AppOutlineButton(title: 'View All', onPress: () {}),
                ],
              ),
              20.height,
              _label('Habit Tracker'),
              20.height,
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    mainAxisExtent: 130),
                itemCount: _habitOptions.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final e = _habitOptions[index];
                  return buildBoxContainer(e, onPress: () {});
                },
              ),
              30.height,
              _label('Request a mentor'),
              15.height,
              BoxContainer(
                  verticalPadding: 10,
                  horizontalPadding: 10,
                  radius: 15,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(0),
                    leading: Image.asset(Assets.imagesGetMentor),
                    title: Text(
                      'Get a new mentor',
                      style: textTheme.titleSmall,
                    ),
                    subtitle: Text(
                      'A mentor will guide you to become the best of yourself',
                      style: textTheme.displaySmall?.copyWith(fontSize: 10),
                    ),
                    trailing:
                        AppOutlineButton(title: 'Send request', onPress: () {}),
                  ))
            ],
          ),
        ));
  }

  Widget _tabComponent(AppointmentFilterEntity data, int index, bool selected,
      {required VoidCallback onPress}) {
    final textTheme = context.textTheme;
    final textStyle = textTheme.displaySmall
        ?.copyWith(color: selected ? AppColors.black : null,fontWeight: FontWeight.bold,);
    final child = Row(
      children: [
        if(!selected&& index==0)
          const Icon(Icons.access_time_rounded,color: AppColors.white,size: 18,)
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
  }

  Widget _label(String text) {
    final textTheme = context.textTheme;
    return Text(
      text,
      style: textTheme.titleSmall,
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

  Widget _appointmentComponent() {
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
}
