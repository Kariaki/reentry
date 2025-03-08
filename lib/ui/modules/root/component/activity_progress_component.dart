import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:reentry/data/enum/emotions.dart';
import 'package:reentry/data/model/user_dto.dart';
import 'package:reentry/ui/modules/authentication/bloc/account_cubit.dart';
import 'package:reentry/ui/modules/root/component/analytic_container.dart';

class ActivityProgressComponent extends StatelessWidget {
  const ActivityProgressComponent(
      {super.key,
      required this.title,
      required this.analyticTitle,
      required this.name,
      required this.centerText,
      required this.centerTextValue,
      this.isGoals = true,
      required this.value});

  final String title;
  final String name;
  final int value;
  final String centerText;
  final String analyticTitle;
  final bool isGoals;
  final String centerTextValue;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 270,
      ),
      child: AnalyticContainer(
          title: analyticTitle,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(title),
              20.height,
              SizedBox(
                width: 215,
                height: 215,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 215,
                      height: 215,
                      child: CircularProgressIndicator(
                        value: value / 100,
                        strokeCap: StrokeCap.round,
                        color: AppColors.primary,
                        strokeWidth: 15,
                        backgroundColor:
                            isGoals ? AppColors.hintColor : Colors.transparent,
                      ),
                    ),
                    if (!isGoals)
                      const SizedBox(
                        width: 200,
                        height: 200,
                        child: CircularProgressIndicator(
                          value: 0,
                          strokeCap: StrokeCap.round,
                          color: AppColors.primary,
                          strokeWidth: 15,
                          backgroundColor: AppColors.hintColor,
                        ),
                      ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(centerText),
                        5.height,
                        Text(
                          centerTextValue,
                          style: context.textTheme.titleLarge
                              ?.copyWith(color: AppColors.white, fontSize: 30),
                        )
                      ],
                    )
                  ],
                ),
              ),
              20.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.circle,
                    size: 11,
                    color: AppColors.hintColor,
                  ),
                  5.width,
                  Text('Created'),
                  10.width,
                  Icon(
                    size: 11,
                    Icons.circle,
                    color: AppColors.primary,
                  ),
                  10.width,
                  Text('Completed')
                ],
              )
            ],
          )),
    );
  }
}

Widget feelingsChart(BuildContext context, {List<FeelingDto>? data}) {
  final feeling = data??context.read<AccountCubit>().state?.feelingTimeLine ?? [];

  Map<String, double> dataMap = {
    "Depressed": feeling
        .where(
            (e) => e.emotion == Emotions.fear || e.emotion == Emotions.anxiety)
        .length
        .toDouble(),
    "Happy":
        feeling.where((e) => e.emotion == Emotions.happy).length.toDouble(),
    "Joyful":
        feeling.where((e) => e.emotion == Emotions.love).length.toDouble(),
    "Neutral":
        feeling.where((e) => e.emotion == Emotions.shame).length.toDouble(),
    "Sad": feeling.where((e) => e.emotion == Emotions.sad).length.toDouble(),
  };
  print('data result -> ${feeling.map((e)=>e.emotion.name)}');
  return ConstrainedBox(
    constraints: BoxConstraints(maxWidth: 270),
    child: AnalyticContainer(
        title: 'Feeling tracker',
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(''),
              20.height,
              SizedBox(
                width: 215,
                height: 215,
                child: PieChart(
                  dataMap: dataMap,

                  animationDuration: Duration(milliseconds: 800),
                  chartLegendSpacing: 32,
                  chartRadius: MediaQuery.of(context).size.width / 3.2,
                  initialAngleInDegree: 0,
                  chartType: ChartType.ring,
                  ringStrokeWidth: 32,
                  centerText: "",
                  legendOptions: const LegendOptions(
                    showLegendsInRow: false,
                    legendPosition: LegendPosition.right,
                    showLegends: true,
                    legendShape: BoxShape.circle,
                    legendTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  chartValuesOptions: const ChartValuesOptions(
                    showChartValueBackground: false,
                    showChartValues: false,
                    showChartValuesInPercentage: false,
                    showChartValuesOutside: false,
                    decimalPlaces: 1,
                  ),
                  // gradientList: ---To add gradient colors---
                  // emptyColorGradient: ---Empty Color gradient---
                ),
              ),
              32.height,
            ],
          ),
        )),
  );
}
