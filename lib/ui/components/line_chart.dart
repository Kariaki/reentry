//import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/ui/modules/activities/chart/graph_component.dart';

class LineChartSample2 extends StatefulWidget {
  final List<int> appointmentOverTheYear;

  const LineChartSample2({super.key, required this.appointmentOverTheYear});

  @override
  State<LineChartSample2> createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample2> {
  List<Color> gradientColors = [
    AppColors.primary,
    AppColors.greyDark,
  ];

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox();
  }



  // @override
  // Widget build(BuildContext context) {
  //   return Stack(
  //     children: <Widget>[
  //       AspectRatio(
  //         aspectRatio: 3.1,
  //         child: Padding(
  //           padding: const EdgeInsets.only(
  //             right: 18,
  //             left: 12,
  //             top: 24,
  //             bottom: 12,
  //           ),
  //           child: LineChart(
  //             mainData(),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }
  //
  // Widget bottomTitleWidgets(double value, TitleMeta meta) {
  //   List<String> months = [
  //     "jan",
  //     "feb",
  //     "mar",
  //     "apr",
  //     "may",
  //     "jun",
  //     "jul",
  //     "aug",
  //     "sep",
  //     "oct",
  //     "nov",
  //     "dec"
  //   ];
  //   const style = TextStyle(
  //     fontWeight: FontWeight.bold,
  //     fontSize: 16,
  //   );
  //   Widget text;
  //
  //   for (var i = 0; i < 12; i++) {
  //     if (i == value.toInt()) {
  //       text = Text(months[i].capitalizeFirst(), style: style);
  //       return SideTitleWidget(
  //         meta: meta,
  //         child: text,
  //       );
  //     }
  //   }
  //
  //   return SizedBox();
  // }
  //
  // Widget leftTitleWidgets(double value, TitleMeta meta) {
  //   const style = TextStyle(
  //     fontWeight: FontWeight.bold,
  //     fontSize: 15,
  //   );
  //   final max =
  //       ((minOrMaxArray(widget.appointmentOverTheYear)[0]).toDouble() / 3)
  //           .floor();
  //   final String text;
  //   switch (value.toInt()) {
  //     case 1:
  //       text = '${max * 1}';
  //       break;
  //     case 3:
  //       text = '${max + 2}';
  //       break;
  //     case 5:
  //       text = '${max * 3}';
  //       break;
  //     default:
  //       return Container();
  //   }
  //
  //   return Text(text, style: style, textAlign: TextAlign.left);
  // }
  //
  // LineChartData mainData() {
  //   return LineChartData(
  //     gridData: FlGridData(
  //       show: true,
  //       drawVerticalLine: false,
  //       horizontalInterval: 1,
  //       getDrawingHorizontalLine: (value) {
  //         return const FlLine(
  //             color: AppColors.greyWhite, strokeWidth: 1, dashArray: [5]);
  //       },
  //     ),
  //     titlesData: FlTitlesData(
  //       show: true,
  //       rightTitles: const AxisTitles(
  //         sideTitles: SideTitles(showTitles: false),
  //       ),
  //       topTitles: const AxisTitles(
  //         sideTitles: SideTitles(showTitles: false),
  //       ),
  //       bottomTitles: AxisTitles(
  //         sideTitles: SideTitles(
  //           showTitles: true,
  //           reservedSize: 30,
  //           interval: 1,
  //           getTitlesWidget: bottomTitleWidgets,
  //         ),
  //       ),
  //       leftTitles: AxisTitles(
  //         sideTitles: SideTitles(
  //           showTitles: true,
  //           interval: 1,
  //           getTitlesWidget: leftTitleWidgets,
  //           reservedSize: 42,
  //         ),
  //       ),
  //     ),
  //     borderData: FlBorderData(
  //       show: true,
  //       border: Border.all(color: const Color(0xff37434d)),
  //     ),
  //     minX: 0,
  //     maxX: 11,
  //     minY: 0,
  //     maxY: 5,
  //     lineBarsData: [
  //       LineChartBarData(
  //         spots: List.generate(widget.appointmentOverTheYear.length, (value) {
  //           /*
  //              FlSpot(0, 0),
  //           FlSpot(2.6, 2),
  //           FlSpot(4.9, 5),
  //           FlSpot(6.8, 3.1),
  //           FlSpot(8, 4),
  //           FlSpot(9.5, 3),
  //           FlSpot(11, 4),
  //            */
  //           return FlSpot(
  //               value.toDouble(), widget.appointmentOverTheYear[value] / 6);
  //         }).toList(),
  //         isCurved: true,
  //         gradient: LinearGradient(
  //           colors: gradientColors,
  //         ),
  //         barWidth: 5,
  //         isStrokeCapRound: true,
  //         dotData: const FlDotData(
  //           show: false,
  //         ),
  //         belowBarData: BarAreaData(
  //           show: true,
  //           gradient: LinearGradient(
  //             colors:
  //                 gradientColors.map((color) => color.withAlpha(30)).toList(),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
