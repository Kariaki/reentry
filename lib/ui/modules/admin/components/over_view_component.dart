import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/ui/components/container/box_container.dart';
import 'package:reentry/ui/modules/admin/admin_stat_state.dart';

class OverViewEntity {
  final String title;
  final String value;
  final bool line;

  const OverViewEntity(
      {required this.value, required this.title, this.line = false});
}

class OverViewComponent extends StatelessWidget {
  final AdminStatEntity entity;

  const OverViewComponent({super.key, required this.entity});

  @override
  Widget build(BuildContext context) {
    final data = [
      OverViewEntity(
          value: entity.totalCitizens.toString(), title: 'Total citizens'),
      OverViewEntity(
          value: entity.careTeam.toString(), title: 'Line', line: true),
      OverViewEntity(value: entity.careTeam.toString(), title: 'Care team'),
      OverViewEntity(
          value: entity.careTeam.toString(), title: 'Line', line: true),
      OverViewEntity(
          value: entity.appointments.toString(), title: 'Appointments')
    ];

    final textTheme = context.textTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 600;

        return BoxContainer(
          width: double.infinity,
          radius: 8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Overview',
                style: textTheme.titleSmall,
              ),
              20.height,
              isMobile
                  ? Wrap(
                      alignment: WrapAlignment.start,
                      spacing: 10,
                      runSpacing: 10,
                      children: data
                          .map((e) =>
                              overViewDataComponent(context, e, isMobile))
                          .toList(),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: data
                          .map((e) =>
                              overViewDataComponent(context, e, isMobile))
                          .toList(),
                    ),
            ],
          ),
        );
      },
    );
  }

  Widget overViewDataComponent(
      BuildContext context, OverViewEntity entity, bool isMobile) {
    final textTheme = context.textTheme;
    var formatter = NumberFormat.decimalPattern();
    final value = formatter.format(int.tryParse(entity.value) ?? '1');

    if (entity.line) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: isMobile ? 5 : 10),
        height: isMobile ? 30 : 50,
        width: 1.5,
        color: AppColors.white.withOpacity(.75),
      );
    }

    return Container(
      width: isMobile ? 120 : null,
      margin: EdgeInsets.symmetric(horizontal: isMobile ? 10 : 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            entity.title,
            style: TextStyle(color: AppColors.white.withOpacity(.75)),
          ),
          10.height,
          Text(
            value,
            style: textTheme.headlineLarge?.copyWith(
              color: AppColors.white,
              fontSize: isMobile ? 18 : null,
            ),
          ),
        ],
      ),
    );
  }
}
