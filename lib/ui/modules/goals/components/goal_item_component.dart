import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';

import '../../../../generated/assets.dart';

class GoalItemComponent extends StatelessWidget {
  final String title;
  final int progress;

  const GoalItemComponent({super.key, required this.title,this.progress=0});

  @override
  Widget build(BuildContext context) {
    final theme = context.textTheme;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child:  Row(
        children: [
          Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(Assets.svgGoal),
                  3.width,
                 Expanded(child:  Text(
                   title,
                   style: theme.bodySmall,
                 ))
                ],
              )),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 8,
                width: 54,
                child: LinearProgressIndicator(
                  value: progress/100,
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.green,
                ),
              ),
              5.width,
              Text(
                '$progress%',
                style: theme.bodySmall,
              )
            ],
          )
        ],
      ),
    );
  }
}
