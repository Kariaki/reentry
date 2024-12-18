import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reentry/core/const/app_constants.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/data/model/user_dto.dart';
import 'package:reentry/data/repository/auth/auth_repository.dart';
import 'package:reentry/generated/assets.dart';
import 'package:reentry/ui/modules/authentication/bloc/account_cubit.dart';
import 'package:reentry/ui/modules/authentication/bloc/auth_events.dart';
import 'package:reentry/ui/modules/authentication/bloc/authentication_bloc.dart';
import 'package:reentry/ui/modules/authentication/bloc/authentication_state.dart';
import '../../../../beam_locations.dart';
import '../../../../data/enum/account_type.dart';
import '../../../dialog/alert_dialog.dart';
import '../../activities/bloc/activity_cubit.dart';
import '../../activities/web/web_activity_screen.dart';
import '../../admin/dashboard.dart';
import '../../appointment/bloc/appointment_cubit.dart';
import '../../appointment/web/appointment_screen.dart';
import '../../blog/web/blog_screen.dart';
import '../../citizens/citizens_screen.dart';
import '../../goals/bloc/goals_cubit.dart';
import '../../goals/web/web_goals_screen.dart';
import '../../messaging/bloc/conversation_cubit.dart';
import '../../officers/officers_screen.dart';
import '../../profile/bloc/profile_cubit.dart';
import '../../report/web/view_report_screen.dart';
import '../../settings/web/settings_screen.dart';
import '../navigations/messages_navigation_screen.dart';

class Webroot extends StatefulWidget {
  const Webroot({super.key});

  @override
  _WebSideBarLayoutState createState() => _WebSideBarLayoutState();
}

class _WebSideBarLayoutState extends State<Webroot> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedPage = 0;

  @override
  void initState() {
    super.initState();

    final currentUser = context.read<AccountCubit>().state;
    context.read<AccountCubit>().readFromLocalStorage();
    context.read<AppointmentCubit>()
      ..fetchAppointmentInvitations(currentUser?.userId ?? '')
      ..fetchAppointments(currentUser?.userId ?? '');
    context.read<ProfileCubit>().registerPushNotificationToken();
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
    return BlocListener<AuthBloc, AuthState>(listener: (context, state) {
      if (state is LogoutSuccess) {
        context.read<AccountCubit>().logout();
      }
      if (state is AuthError) {
        context.showSnackbarError(state.message);
      }
    }, child: BlocBuilder<AccountCubit, UserDto?>(builder: (context, state) {
      final accountType = state?.accountType;
      List<Widget> pages = [];

      if (accountType == AccountType.citizen) {
        pages = [
          DashboardPage(),
          ...[WebGoalsPage(), AcitivityPage()],
          AppointmentPage(),
          ConversationNavigation(),
          BlogPage(),
          SettingsPage(),
        ];
      }
      if (accountType == AccountType.admin) {
        pages = [
          DashboardPage(),
          CitizensScreen(),
          NoncitizensScreen(accountType: AccountType.mentor),
          NoncitizensScreen(accountType: AccountType.officer),
          ViewReportPage(),
          BlogPage(),
          SettingsPage()
        ];
      }
      if (accountType == AccountType.officer ||
          accountType == AccountType.mentor) {
        pages = [
          DashboardPage(),
          CitizensScreen(),
          AppointmentPage(),
          ConversationNavigation(),
          ViewReportPage(),
          BlogPage(),
          SettingsPage()
        ];
      }
      return Scaffold(
        backgroundColor: AppColors.greyDark,
        key: _scaffoldKey,
        drawer: Drawer(
          backgroundColor: AppColors.greyDark,
          child: _buildSidebar(state),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            bool isDesktop = constraints.maxWidth > 800;
            return Row(
              children: [
                if (isDesktop)
                  Container(
                    width: 250,
                    color: AppColors.greyDark,
                    child: _buildSidebar(state),
                  ),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        color: AppColors.greyDark,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        height: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (!isDesktop)
                              IconButton(
                                icon: const Icon(Icons.menu,
                                    color: AppColors.white),
                                onPressed: () {
                                  _scaffoldKey.currentState?.openDrawer();
                                },
                              ),
                          ],
                        ),
                      ),
                      Expanded(
                          child: IndexedStack(
                        children: pages,
                        index: _selectedPage,
                      )),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      );
    }));
  }

  Widget _buildSidebar(UserDto? state) {
    return BlocBuilder<AccountCubit, UserDto?>(builder: (context, state) {
      if (state == null) {
        return const SizedBox();
      }
      final accountType = state.accountType;

      const title = "CARE TEAM";
      final items = [
        if (accountType == AccountType.citizen) ...[
          (Assets.webDashboard, 'Dashboard'),
          (Assets.svgAppointments, 'Goals'),
          (Assets.svgCalender, 'Daily Activities'),
          (Assets.svgAppointments, 'Appointments'),
          (Assets.svgChatBubble, 'Conversations'),
          (Assets.webBlog, 'Blogs'),
          (Assets.webSettings, 'Settings'),
        ],
        if (accountType == AccountType.admin) ...[
          (Assets.webDashboard, 'Dashboard'),
          (Assets.webCitizens, 'Citizen'),
          (Assets.webPeer, 'Peer mentors'),
          (Assets.webParole, 'Officers'),
          (Assets.webParole, 'Reports'),
          (Assets.webParole, 'Blog'),
          (Assets.svgSettings, 'Settings'),
        ],
        if (accountType == AccountType.officer ||
            accountType == AccountType.mentor) ...[
          (Assets.webDashboard, 'Dashboard'),
          (Assets.webCitizens, 'Clients'),
          (Assets.svgAppointments, 'Appointments'),
          (Assets.svgChatBubble, 'Conversations'),
          (Assets.webCalendar, 'Reports'),
          (Assets.webBlog, 'Blogs'),
          (Assets.webSettings, 'Settings'),
        ],
      ];
      [
        (Assets.webDashboard, 'Dashboard'),
        if (accountType == AccountType.admin) ...[],
        if (accountType == AccountType.citizen) ...[
          (Assets.webCalendar, 'Appointments')
        ],
        if (accountType != AccountType.admin)
          (Assets.webCalendar, 'Appointments'),
        (Assets.webPeer, 'Indicents'),
        (Assets.webPeer, 'Blog'),
        (Assets.webPeer, 'Incidents'),
        (Assets.webSettings, 'Profile'),
        (Assets.webLogout, 'Logout'),
      ];
      final type = state.accountType;
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start, 
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Sainte',
                style: context.textTheme.titleLarge?.copyWith(fontSize: 30),
              ),
            ),
           
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: BlocBuilder<AccountCubit, UserDto?>(
                  builder: (context, state) {
                if (state == null) return const SizedBox();
                // final accountType = state.accountType;
                return Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage:
                          NetworkImage(state.avatar ?? AppConstants.avatar),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(state.name, style: context.textTheme.bodyMedium),
                          Text(
                            state.email ?? 'jane.dow@example.com',
                            style: context.textTheme.bodyMedium!
                                .copyWith(fontSize: 11, color: AppColors.grey1),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
            40.height,
            ...List.generate(items.length, (index) {
              final item = items[index];
              return Column(
                children: [
                  _buildSidebarItem(item.$1, item.$2, '', index,
                      isSelected: index == _selectedPage),
                      15.height,
                ],
              );
                  
            }),
          ],
        ),
      );
    });
  }

  Padding _buildSubGroupTitle(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          title,
          style: context.textTheme.bodySmall!
              .copyWith(fontSize: 11, color: AppColors.grey1),
        ),
      ),
    );
  }

  void closeApp(BuildContext context, void Function() callback) {
    AppAlertDialog.show(context,
        description: "Are you sure you want to logout?",
        title: "Logout?",
        action: "Logout", onClickAction: () {
      callback();
    });
  }

  Widget _buildSidebarItem(String icon, String label, String route, int index,
      {bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          border: isSelected
              ? Border.all(
                  color: AppColors.gray2,
                  width: 1.0,
                )
              : null,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: InkWell(
          onTap: label == "Log Out"
              ? () {
                  closeApp(context, () {
                    context.read<AuthBloc>().add(LogoutEvent());
                  });
                }
              : () {
                  setState(() {
                    _selectedPage = index;
                  });
                },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: SvgPicture.asset(icon),
              ),
              const SizedBox(width: 16),
              Text(
                label,
                style: context.textTheme.bodySmall
                    ?.copyWith(color: AppColors.greyWhite),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
