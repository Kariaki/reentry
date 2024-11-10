import 'package:flutter/cupertino.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/ui/components/container/outline_container.dart';

class AppOutlineButton extends StatelessWidget {
  final String title;
  final double? height;
  final double? width;
  final double? verticalPadding;
  final double? horizontalPadding;
  final VoidCallback onPress;

  const AppOutlineButton(
      {super.key,
      required this.title,
      required this.onPress,
      this.width,
      this.height,
      this.horizontalPadding,
      this.verticalPadding});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    return OutlineContainer(
        onPress: onPress,

        verticalPadding: verticalPadding??5,
        horizontalPadding: horizontalPadding,
        child: Text(
          title,
          style: textTheme.displaySmall,
        ));
  }
}
