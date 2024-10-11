import 'package:flutter/material.dart';

import '../../../core/theme/colors.dart';

class BaseScaffold extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;
  const BaseScaffold({super.key,required this.child,this.appBar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: AppColors.black,
      body: Padding(padding: const EdgeInsets.symmetric(horizontal: 20),child: child,),
    );
  }
}
