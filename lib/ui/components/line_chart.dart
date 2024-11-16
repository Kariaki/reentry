import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:reentry/core/theme/colors.dart';

class LineChartSample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(16.0),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(),
            bottomTitles: AxisTitles(),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.black, width: 1),
          ),
          minX: 0,
          maxX: 7,
          minY: 0,
          maxY: 6,
          lineBarsData: [
            LineChartBarData(
              spots: [
                FlSpot(0, 3),
                FlSpot(1, 1),
                FlSpot(2, 4),
                FlSpot(3, 2),
                FlSpot(4, 5),
                FlSpot(5, 1),
                FlSpot(6, 4),
              ],
              isCurved: true,
              color: AppColors.primary,
              barWidth: 4,
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}
