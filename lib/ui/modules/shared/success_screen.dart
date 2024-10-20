import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/components/success_screen_component.dart';

class SuccessScreen extends HookWidget {
  final String title;
  final String? description;
  final VoidCallback callback;

  const SuccessScreen(
      {super.key,
      required this.callback,
      required this.title,
      this.description});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        child: SuccessScreenComponent(
      title: title,
      subtitle: description,
          callback: callback,
    ));
  }
}
