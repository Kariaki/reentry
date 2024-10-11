import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reentry/core/extensions.dart';

import '../../core/theme/colors.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({super.key, this.showBack = true, this.title = 'Reentry'});

  final String? title;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return AppBar(
      leading:showBack? InkWell(
        onTap: () => context.pop(),
        child:  Icon(Icons.keyboard_arrow_left,color: AppColors.white,),
      ):null,
      title: title != null
          ? Text(
              title!,
              style: theme.titleSmall?.copyWith(color: AppColors.primary),
            )
          : null,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size(double.infinity, 50);
}
