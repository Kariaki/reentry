import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/ui/components/error_component.dart';
import 'package:reentry/ui/components/loading_component.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/modules/admin/admin_stat_cubit.dart';
import 'package:reentry/ui/modules/admin/components/over_view_component.dart';
import 'package:reentry/ui/modules/appointment/appointment_graph/appointment_graph_component.dart';

import 'admin_stat_state.dart';

class DashboardPage extends HookWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      context.read<AdminStatCubit>().fetchStats();
    }, []);
    return BaseScaffold(child: BlocBuilder<AdminStatCubit, AdminStatCubitState>(
        builder: (context, state) {
      if (state is AdminStatLoading) {
        return LoadingComponent();
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
        return Column(
          children: [
            50.height,
            OverViewComponent(
              entity: state.data,
            ),
            20.height,
            AppointmentGraphComponent()
          ],
        );
      }
      return ErrorComponent(
        onActionButtonClick: () {
          context.read<AdminStatCubit>().fetchStats();
        },
      );
    }));
  }
}
