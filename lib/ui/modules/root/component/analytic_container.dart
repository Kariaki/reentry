import 'package:flutter/cupertino.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';

class AnalyticContainer extends StatelessWidget {
  const AnalyticContainer(
      {super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        20.height,
        Text(title),
        20.height,
        Container(
          padding: const EdgeInsets.all(20),
          decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(color: AppColors.greyWhite))),
          child: child,
        )
      ],
    );
  }
}
