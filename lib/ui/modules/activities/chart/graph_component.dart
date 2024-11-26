import 'package:flutter/cupertino.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/core/util/graph_data.dart';
import 'package:reentry/core/util/util.dart';
import 'package:reentry/ui/modules/activities/chart/chart_component.dart';

class GraphComponent extends StatelessWidget {
  const GraphComponent({super.key, required this.timeLines});

  final List<int> timeLines;

  @override
  Widget build(BuildContext context) {
    final generatedData = timeLines;
    final minMax = minOrMaxArray(generatedData);
    final scaleMax = minMax[1] + 2;
    final List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return SizedBox(
      height: 130,
      child:
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: Utility()
                      .scale(timeLines).reversed
                      .map((e) => Padding(padding: EdgeInsets.symmetric(vertical: .5),child: Text(e.toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.white,
                      ))))
                      .toList()),

             Expanded(child:  SingleChildScrollView(
               scrollDirection: Axis.horizontal,
               child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceAround,
                   children: [
                     ...List.generate(generatedData.length, (e) => e).map((index) {
                       final e = generatedData[index];
                       final label = months[index];
                       final percentage = e * 100 / scaleMax;
                       return Column(
                         crossAxisAlignment: CrossAxisAlignment.center,
                         mainAxisAlignment: MainAxisAlignment.end,
                         children: [
                           ChartComponent(
                             percentage: percentage.toInt(),
                           ),
                           Text(
                             label,
                             style: const TextStyle(fontSize: 10),
                           )
                         ],
                       );
                     }).toList()
                   ]),
             )),
            ],
          )

    );
  }
}

List<int> minOrMaxArray(List<int> data) {
  if (data.isEmpty) {
    return [0, 0];
  }
  int result = data.first;
  int maxResult = result;
  for (var i in data) {
    if (i > maxResult) {
      maxResult = i;
    }
    if (i < result) {
      result = i;
    }
  }
  return [result, maxResult];
}
