import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reentry/core/theme/colors.dart';

class OutlineContainer extends StatelessWidget {
  final Widget child;
  final double? verticalPadding;
  final double? horizontalPadding;
  final Color? fillColor;
  final double? radius;
  final VoidCallback? onPress;
  final Color? borderColor;

  const OutlineContainer(
      {super.key,
      required this.child,
        this.radius,
        this.borderColor,
      this.fillColor,
        this.onPress,
      this.horizontalPadding,
      this.verticalPadding});

  @override
  Widget build(BuildContext context) {
    final boxRadius = radius??20;
    return InkWell(
      onTap: onPress,
      radius: boxRadius,
      borderRadius: BorderRadius.circular(boxRadius),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding ?? 10, vertical: verticalPadding ?? 10),
        decoration: ShapeDecoration(
            color: fillColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(boxRadius),
                side:  BorderSide(color: borderColor??AppColors.white))),
        child: child,
      ),
    );
  }
}
