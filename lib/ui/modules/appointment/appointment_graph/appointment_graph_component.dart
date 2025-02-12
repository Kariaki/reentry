import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/ui/components/line_chart.dart';
import 'package:reentry/ui/modules/appointment/appointment_graph/appointment_graph_cubit.dart';
import 'package:reentry/ui/modules/appointment/appointment_graph/appointment_graph_state.dart';
import '../../../../core/theme/colors.dart';
import '../../../components/container/box_container.dart';
import '../../activities/chart/graph_component.dart';

class AppointmentGraphComponent extends StatelessWidget {
  final String? userId;

  const AppointmentGraphComponent({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AppointmentGraphCubit()..appointmentGraphData(userId: userId),
      child: BlocBuilder<AppointmentGraphCubit, AppointmentGraphState>(
          builder: (context, state) {
        if (state is AppointmentGraphSuccess) {
          print('kariaki -> ${state.data}');
          return Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Appointments',
                    style: context.textTheme.bodySmall,
                  ),
                  10.height,
                  AppointmentLineChart(
                    appointmentOverTheYear: state.data,
                  ),
                  20.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 20,
                        color: AppColors.primary,
                        height: 5,
                      ),
                      5.width,
                      Text(
                        'Appointment history',
                        style: context.textTheme.bodySmall,
                      ),
                    ],
                  ),
                  30.height,
                ],
              ));
        }
        return const SizedBox();
      }),
    );
  }
}
