import 'package:flutter/cupertino.dart';
import 'package:reentry/core/util/graph_data.dart';
import 'package:reentry/ui/modules/activities/chart/chart_component.dart';

class GraphComponent extends StatelessWidget {
  const GraphComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final generatedData = GraphData().generateWeeklyDataForYAxis(
        GraphData.randomDates);
    final minMax = minOrMaxArray(generatedData);
    final scaleMax = minMax[1]+2;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: generatedData.map((e) {
        final percentage = e*100/scaleMax;
        return  ChartComponent(percentage: percentage.toInt(),);
      }).toList(),
    );
  }

  List<int> minOrMaxArray(List<int> data, {bool max = true}) {
    if(data.isEmpty){
      return [0,0];
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
}
