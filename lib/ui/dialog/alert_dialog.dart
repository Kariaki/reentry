import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';

class AppAlertDialog extends StatelessWidget {
  final String title;
  final String action;
  final void Function() onClickAction;
  final String description;

  static Future<void> show(BuildContext context,
      {required String title,
      required String description,
      required String action,
      required void Function() onClickAction}) async {
    context.displayDialog(AppAlertDialog(
        title: title,
        description: description,
        action: action,
        onClickAction: onClickAction));
  }

  const AppAlertDialog(
      {super.key,
      required this.title,
      required this.description,
      required this.action,
      required this.onClickAction});

  @override
  Widget build(BuildContext context) {
    final textStyle = context.textTheme;
    final buttonStyle = textStyle.bodyMedium
        ?.copyWith(fontWeight: FontWeight.bold, color: AppColors.greyWhite);
    return Container(
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
                    context.pop();
                  },
                  child: Text(
                    'Cancel',
                    style: buttonStyle,
                  )),
              TextButton(
                  onPressed: () {
                    onClickAction();
                    context.pop();
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
