import 'package:flutter/material.dart';

import '../../../core/theme/colors.dart';

class BaseScaffold extends StatelessWidget {
  final Widget child;
  const BaseScaffold({super.key,required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: AppColors.black,
      body: Padding(padding: const EdgeInsets.symmetric(horizontal: 20),child: child,),
    );
  }
}
