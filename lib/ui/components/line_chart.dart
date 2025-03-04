import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/ui/modules/activities/chart/graph_component.dart';

class AppointmentLineChart extends StatefulWidget {
  final List<int> appointmentOverTheYear;

  const AppointmentLineChart({super.key, required this.appointmentOverTheYear});

  @override
  State<AppointmentLineChart> createState() => _AppointmentLineChartState();
}

class _AppointmentLineChartState extends State<AppointmentLineChart> {
  List<Color> gradientColors = [
    AppColors.primary,
    AppColors.greyDark,
  ];

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 3.1,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 18,
              left: 12,
              top: 24,
              bottom: 12,
            ),
            child: LineChart(
              mainData(),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    List<String> months = [
      "jan",
      "feb",
      "mar",
      "apr",
      "may",
      "jun",
      "jul",
      "aug",
      "sep",
      "oct",
      "nov",
      "dec"
    ];
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;

    for (var i = 0; i < 12; i++) {
      if (i == value.toInt()) {
        text = Text(months[i].capitalizeFirst(), style: style);
        return SideTitleWidget(

          axisSide: AxisSide.bottom,
          child: text,
        );
      }
    }

    return SizedBox();
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    final max =
        (minOrMaxArray(widget.appointmentOverTheYear)[1]);
    double usedValue = value;
    if(usedValue==max&&usedValue%2!=0){
      usedValue+=1;
    }
    final String text;
    if (value % 2 == 0) {
      text = usedValue.round().toString();
    } else {
      return const SizedBox();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    final max = ((minOrMaxArray(widget.appointmentOverTheYear)[1])
        .toDouble()); //.floor();
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 1,

        getDrawingHorizontalLine: (value) {
          return const FlLine(
              color: AppColors.greyWhite, strokeWidth: 1, dashArray: [5]);
        },
      ),

      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          drawBelowEverything: false,
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: max+1,
      lineBarsData: [
        LineChartBarData(
          spots: List.generate(widget.appointmentOverTheYear.length, (value) {
            return FlSpot(value.toDouble(),
                widget.appointmentOverTheYear[value].toDouble());
          }).toList(),
          isCurved: false,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withAlpha(0))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
