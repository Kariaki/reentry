import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reentry/core/theme/colors.dart';

class BoxContainer extends StatelessWidget {
  final double? verticalPadding;
  final double? horizontalPadding;
  final double? height;
  final double? width;
  final VoidCallback? onPress;
  final Color? color;
  final Widget child;
  final BoxConstraints? constraints;

  final double? radius;

  const BoxContainer(
      {super.key,
      this.verticalPadding,
      required this.child,
        this.onPress,
        this.radius,
        this.constraints,
      this.height,
        this.color,
      this.width,
      this.horizontalPadding});

  @override
  Widget build(BuildContext context) {
    final boxRadius = radius??30;
    return InkWell(
      onTap: onPress,
      radius: boxRadius,
      borderRadius: BorderRadius.circular(boxRadius),
      child: Container(
        height: height,
        constraints:constraints ,
        width: width,
        padding: EdgeInsets.symmetric(
            vertical: verticalPadding ?? 20, horizontal: horizontalPadding ?? 20),
        decoration: ShapeDecoration(
            color: color??AppColors.gray1,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(boxRadius))),
        child: child,
      ),
    );
  }
}
