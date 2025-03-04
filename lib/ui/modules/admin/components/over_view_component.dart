import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/data/enum/account_type.dart';
import 'package:reentry/ui/components/container/box_container.dart';
import 'package:reentry/ui/modules/admin/admin_stat_state.dart';
import 'package:reentry/ui/modules/authentication/bloc/account_cubit.dart';

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
    final currentUser = context.read<AccountCubit>().state;
    final data = [
      OverViewEntity(
          value: (entity.totalCitizens + entity.careTeam).toString(),
          title: 'Total users'),
      OverViewEntity(
          value: entity.careTeam.toString(), title: 'Line', line: true),
      OverViewEntity(
          value: entity.totalCitizens.toString(), title: 'Total citizens'),
      OverViewEntity(
          value: entity.careTeam.toString(), title: 'Line', line: true),
      OverViewEntity(value: entity.careTeam.toString(), title: 'Care team'),
      if (currentUser?.accountType == AccountType.admin) ...[
        OverViewEntity(
            value: entity.careTeam.toString(), title: 'Line', line: true),
        OverViewEntity(
            value: entity.appointments.toString(), title: 'Appointments')
      ]
    ];
    final textTheme = context.textTheme;
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: ShapeDecoration(
            shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(color: AppColors.white, width: .7))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Overview',
              style: textTheme.titleSmall,
            ),
            20.height,
            Row(
              children:
                  data.map((e) => overViewDataComponent(context, e)).toList(),
            ),
          ],
        ));
  }

  Widget overViewDataComponent(BuildContext context, OverViewEntity entity) {
    final textTheme = context.textTheme;
    var formatter = NumberFormat.decimalPattern();

    final value = formatter.format(int.tryParse(entity.value) ?? '1');
    if (entity.line) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        height: 50,
        width: 1.5,
        color: AppColors.white.withOpacity(.75),
      );
    }
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(entity.title,
              style: TextStyle(
                color: AppColors.white.withOpacity(.75),
              )),
          10.height,
          Text(
            value,
            style: textTheme.headlineLarge?.copyWith(color: AppColors.white),
          )
        ],
      ),
    );
  }
}

class CitizenOverViewComponent extends StatelessWidget {
  final int? totalGoals;
  final int totalAppointments;
  final int? citizens;
  final bool careTeam;

  const CitizenOverViewComponent(
      {super.key,
      required this.totalAppointments,
      this.totalGoals,
      this.citizens,
      this.careTeam = false});

  @override
  Widget build(BuildContext context) {
    final data = [
      OverViewEntity(
          value: careTeam
              ? (citizens?.toString() ?? '0')
              : (totalGoals?.toString() ?? '0'),
          title: !careTeam ? 'Total goals' : 'Citizens'),
      const OverViewEntity(value: '0', title: 'Line', line: true),
      OverViewEntity(value: totalAppointments.toString(), title: 'Appointments')
    ];
    final textTheme = context.textTheme;
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: ShapeDecoration(
            shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(color: AppColors.greyWhite, width: .7))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Overview',
              style: textTheme.titleSmall,
            ),
            20.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children:
                  data.map((e) => overViewDataComponent(context, e)).toList(),
            )
          ],
        ));
  }

  Widget overViewDataComponent(BuildContext context, OverViewEntity entity) {
    final textTheme = context.textTheme;
    var formatter = NumberFormat.decimalPattern();

    final value = formatter.format(int.tryParse(entity.value) ?? '1');
    if (entity.line) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        height: 50,
        width: 1.5,
        color: AppColors.white.withOpacity(.75),
      );
    }
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(entity.title,
              style: TextStyle(
                color: AppColors.white.withOpacity(.75),
              )),
          10.height,
          Text(
            value,
            style: textTheme.headlineLarge?.copyWith(color: AppColors.white),
          )
        ],
      ),
    );
  }
}
