import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:reentry/core/extensions.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/style/app_styles.dart';
import '../../generated/assets.dart';
import 'buttons/primary_button.dart';

class SuccessScreenComponent extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? callback;

  const SuccessScreenComponent({super.key, required this.title, this.subtitle,this.callback});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(

        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            Assets.svgThumbsUp,
          ),
          30.height,
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppStyles.textTheme(context)
                .titleLarge
                ?.copyWith(color: AppColors.white,fontSize: 32),
          ),
          if (subtitle != null) ...[
            15.height,
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: AppStyles.textTheme(context)
                  .bodyLarge
                  ?.copyWith(color: AppColors.white.withOpacity(.5)),
            )
          ],
          20.height,
          if(callback!=null)
            PrimaryButton(
              text: "Continue",
              onPress: (){
                context.popRoute();
              },
            )
        ],
      ),
    );
  }
}
