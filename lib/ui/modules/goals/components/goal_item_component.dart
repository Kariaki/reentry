import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/data/model/goal_dto.dart';
import 'package:reentry/ui/modules/goals/goal_progress_screen.dart';

import '../../../../generated/assets.dart';

class GoalItemComponent extends StatelessWidget {
  final GoalDto goal;

  const GoalItemComponent({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    final theme = context.textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Row(
        children: [
          Expanded(
              child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(Assets.svgGoal),
              3.width,
              Expanded(
                  child: Text(
                goal.title,
                style: theme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
                  value: goal.progress / 100,
                  borderRadius: BorderRadius.circular(50),
                  color: goal.progress == 100 ? Colors.green : Colors.grey,
                ),
              ),
              5.width,
              Text(
                '${goal.progress}%',
                style: theme.bodySmall,
              ),
              if (goal.progress < 100) ...[
                5.width,
                IconButton(
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    onPressed: () {
                      context.pushRoute(GoalProgressScreen(
                        goal: goal,
                      ));
                    },
                    icon: const Icon(
                      Icons.edit,
                      color: AppColors.white,
                      size: 18,
                    ))
              ]
            ],
          )
        ],
      ),
    );
  }
}
