import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:reentry/core/extensions.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/style/app_styles.dart';
import '../../generated/assets.dart';

class SuccessScreenComponent extends StatelessWidget {
  final String title;
  final String? subtitle;

  const SuccessScreenComponent({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            Assets.svgThumbsUp,
          ),
          30.height,
          Text(
            "You're all set",
            style: AppStyles.textTheme(context)
                .titleLarge
                ?.copyWith(color: AppColors.white),
          ),
          if (subtitle != null) ...[
            30.height,
            Text(
              subtitle!,
              style: AppStyles.textTheme(context)
                  .bodyLarge
                  ?.copyWith(color: AppColors.white.withOpacity(.5)),
            )
          ]
        ],
      ),
    );
  }
}
