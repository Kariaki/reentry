import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/ui/components/container/box_container.dart';

class OverViewEntity {
  final String title;
  final String value;

  const OverViewEntity({required this.value, required this.title});
}

class OverViewComponent extends StatelessWidget {
  const OverViewComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final data = [
      OverViewEntity(value: '42000', title: 'Total citizens'),
      OverViewEntity(value: '90000', title: 'Care team'),
      OverViewEntity(value: '30000', title: 'Appointments')
    ];
    final textTheme = context.textTheme;
    return BoxContainer(
      width: double.infinity,
        radius: 8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Overview',style: textTheme.titleSmall,),
        20.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: data.map((e) => overViewDataComponent(context, e)).toList(),
        )
      ],
    ));
  }

  Widget overViewDataComponent(BuildContext context, OverViewEntity entity) {
    final textTheme = context.textTheme;
    var formatter = NumberFormat.decimalPattern();

    final value = formatter.format(int.tryParse(entity.value)??'1');
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(entity.title),
          10.height,
          Text(
           value ,
            style: textTheme.headlineLarge?.copyWith(color: AppColors.white),
          )
        ],
      ),
    );
  }
}
