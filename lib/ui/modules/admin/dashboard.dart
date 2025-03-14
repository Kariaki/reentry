import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/data/enum/account_type.dart';
import 'package:reentry/data/model/user_dto.dart';
import 'package:reentry/ui/components/error_component.dart';
import 'package:reentry/ui/components/loading_component.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/modules/admin/admin_stat_cubit.dart';
import 'package:reentry/ui/modules/admin/components/over_view_component.dart';
import 'package:reentry/ui/modules/appointment/appointment_graph/appointment_graph_component.dart';
import 'package:reentry/ui/modules/appointment/bloc/appointment_cubit.dart';
import 'package:reentry/ui/modules/appointment/bloc/appointment_state.dart';
import 'package:reentry/ui/modules/appointment/web/appointment_screen.dart';
import 'package:reentry/ui/modules/authentication/bloc/account_cubit.dart';
import 'package:reentry/ui/modules/goals/bloc/goals_cubit.dart';
import 'package:reentry/ui/modules/shared/cubit/admin_cubit.dart';
import '../goals/bloc/goals_state.dart';
import 'admin_stat_state.dart';

class DashboardPage extends HookWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final account = context.read<AccountCubit>().state;
    useEffect(() {
      context.read<AdminStatCubit>().fetchStats();
      if (account?.accountType == AccountType.citizen) {
        context.read<GoalCubit>().fetchGoals();
        context
            .read<AppointmentCubit>()
            .fetchAppointments(userId: account?.userId);
      }
    }, []);
    return BlocProvider(
      create: (context) => AdminUserCubitNew()..fetchCitizens(account: account),
      child: BlocBuilder<AdminUserCubitNew, MentorDataState>(
          builder: (context, adminUserCubitState) {
        return BaseScaffold(child:
            BlocBuilder<AdminStatCubit, AdminStatCubitState>(
                builder: (context, state) {
          if (state is AdminStatLoading) {
            return const LoadingComponent();
          }
          if (state is AdminStatError) {
            return ErrorComponent(
              description: state.error,
              title: 'Something went wrong!',
              onActionButtonClick: () {
                context.read<AdminStatCubit>().fetchStats();
              },
            );
          }
          if (state is AdminStatSuccess) {
            return SingleChildScrollView(child:
                BlocBuilder<AccountCubit, UserDto?>(
                    builder: (context, accountState) {
              if (accountState?.accountType != AccountType.admin &&
                  accountState?.accountType != AccountType.reentry_orgs) {
                final citizenCount = adminUserCubitState.data.length;
                return citizenDashboard(state, citizenCount);
              }
              return adminDashboard(state);
            }));
          }
          return ErrorComponent(
            onActionButtonClick: () {
              context.read<AdminStatCubit>().fetchStats();
            },
          );
        }));
      }),
    );
  }

  Widget citizenDashboard(AdminStatSuccess state, int citizenCount) {
    return BlocBuilder<AccountCubit, UserDto?>(builder: (context, account) {
      return Builder(builder: (context) {
        if (account?.accountType == AccountType.citizen) {
        } else {}
        return BlocBuilder<GoalCubit, GoalCubitState>(
          builder: (context, goalState) {
            int goalCount = goalState.all.length;
            print('kebilate -> $goalCount');
            return BlocBuilder<AppointmentCubit, AppointmentCubitState>(
              builder: (context, state) {
                int appointments = state.data.length;
                return Column(
                  children: [
                    50.height,
                    CitizenOverViewComponent(
                      totalAppointments: appointments,
                      careTeam: account?.accountType != AccountType.citizen,
                      totalGoals: goalCount == 0 ? null : goalCount,
                      citizens: citizenCount,
                    ),
                    50.height,
                    AppointmentGraphComponent(userId: account?.userId ?? ''),
                    50.height,
                     AppointmentHistoryTable(
                      dashboard: true,
                      data: state.data,
                    ),
                    50.height,
                  ],
                );
              },
            );
          },
        );
      });
    });
  }

  Widget adminDashboard(AdminStatSuccess state) {
    return Column(
      children: [
        50.height,
        OverViewComponent(
          entity: state.data,
        ),
        50.height,
        BlocBuilder<AccountCubit, UserDto?>(builder: (context, state) {
          return AppointmentGraphComponent(
            userId: state?.accountType == AccountType.reentry_orgs
                ? state?.userId ?? ''
                : null,
          );
        }),
        50.height,
      ],
    );
  }
}
