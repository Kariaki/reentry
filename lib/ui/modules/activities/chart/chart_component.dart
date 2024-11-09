import 'package:flutter/cupertino.dart';
import 'package:reentry/core/theme/colors.dart';

class ChartComponent extends StatelessWidget {
  final int percentage;

  const ChartComponent({super.key, this.percentage = 30});

  @override
  Widget build(BuildContext context) {
    const maxHeight = 100;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      width: 12,
      height: percentage*100/maxHeight,
      decoration: ShapeDecoration(shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),color: AppColors.primary),
    );
  }
}
