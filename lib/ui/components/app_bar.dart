import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:reentry/core/extensions.dart';
import 'dart:html' as html;
import '../../core/theme/colors.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar(
      {super.key,
      this.backIcon,
      this.showBack = true,
      this.actions = const [],
      this.title = 'Sainte'});

  final String? title;
  final List<Widget> actions;
  final bool showBack;
  final IconData? backIcon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return AppBar(
      actions: actions,
      automaticallyImplyLeading: false,
      leading: showBack
          ? InkWell(
              onTap: () {
                if (kIsWeb) {
                  _handleWebBack();
                } else {
                  context.pop();
                }
              },
              child: Icon(
                backIcon ?? Icons.keyboard_arrow_left,
                color: AppColors.white,
              ),
            )
          : null,
      title: title != null
          ? Text(
              title!,
              style: theme.titleSmall?.copyWith(color: AppColors.primary),
            )
          : null,
    );
  }

  void _handleWebBack() {
    html.window.history.back();
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size(double.infinity, 50);
}
