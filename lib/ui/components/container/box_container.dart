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
  final bool filled;

  final double? radius;

  const BoxContainer(
      {super.key,
      this.verticalPadding,
      required this.child,
        this.onPress,
        this.radius,
        this.constraints,
        this.filled=true,
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
            color:filled?( color??AppColors.gray1):null,
            shape:OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius??10),
              borderSide:filled?BorderSide(): const BorderSide(color: AppColors.white)
            )),
        child: child,
      ),
    );
  }
}
