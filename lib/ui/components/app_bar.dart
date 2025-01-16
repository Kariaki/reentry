import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:reentry/core/extensions.dart';
import '../../core/theme/colors.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar(
      {super.key,
      this.backIcon,
      this.showBack = true,
        this.onBackPress,
      this.actions = const [],
      this.title = 'Sainte'});

  final String? title;
  final List<Widget> actions;
  final Function()?onBackPress;
  final bool showBack;
  final IconData? backIcon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return AppBar(
      actions: actions,
      automaticallyImplyLeading: false,
      backgroundColor: kIsWeb ? AppColors.greyDark : AppColors.black,
      leading: (showBack
          ? InkWell(
              onTap:onBackPress?? () {
                if (kIsWeb) {
                  _handleWebBack();
                } else {
                  context.popRoute();
                }
              },
              child: Icon(
             kIsWeb?Icons.close:   backIcon ?? Icons.keyboard_arrow_left,
                color: AppColors.white,
              ),
            )
          : null),
      title: title != null
          ? Text(
              title!,
              style: theme.titleSmall?.copyWith(color: AppColors.primary),
            )
          : null,
    );
  }

  void _handleWebBack() {
  // html.window.history.back();
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size(double.infinity, 50);
}
