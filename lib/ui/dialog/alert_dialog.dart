import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';

class AppAlertDialog extends StatelessWidget {
  final String title;
  final String action;
  final void Function() onClickAction;
  final String description;
  final double? dialogWidth;

  static Future<void> show(BuildContext context,
      {required String title,
      required String description,
      required String action,
      required void Function() onClickAction,
      double? dialogWidth}) async {
    context.displayDialog(AppAlertDialog(
      title: title,
      description: description,
      action: action,
      onClickAction: onClickAction,
      dialogWidth: dialogWidth,
    ));
  }

  const AppAlertDialog(
      {super.key,
      required this.title,
      required this.description,
      required this.action,
      required this.onClickAction,
      this.dialogWidth});

  @override
  Widget build(BuildContext context) {
    final textStyle = context.textTheme;
    final buttonStyle = textStyle.bodyMedium
        ?.copyWith(fontWeight: FontWeight.bold, color: AppColors.greyWhite);

    return Container(
      width:kIsWeb?400: dialogWidth,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title,
              style: textStyle.bodyLarge?.copyWith(
                  color: AppColors.white, fontWeight: FontWeight.bold)),
          10.height,
          Text(
            description,
            style: buttonStyle?.copyWith(fontWeight: FontWeight.w600),
          ),
          20.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () {
                    context.popBack();
                  },
                  child: Text(
                    'Cancel',
                    style: buttonStyle,
                  )),
              TextButton(
                  onPressed: () {
                    context.popBack();
                    onClickAction();
                  },
                  child: Text(
                    action,
                    style: buttonStyle,
                  ))
            ],
          )
        ],
      ),
    );
  }
}
