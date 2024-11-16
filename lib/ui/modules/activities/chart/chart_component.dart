import 'package:flutter/cupertino.dart';
import 'package:reentry/core/theme/colors.dart';

class ChartComponent extends StatelessWidget {
  final int percentage;

  const ChartComponent({super.key, this.percentage = 30});

  @override
  Widget build(BuildContext context) {
    const maxHeight = 85;
    final actualPercentage = percentage<5?5:percentage;
    final height = (actualPercentage*maxHeight)/100;
    print('$height -> $actualPercentage');
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 10,
      height:height ,
      decoration: ShapeDecoration(shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),color: AppColors.primary),
    );
  }
}
