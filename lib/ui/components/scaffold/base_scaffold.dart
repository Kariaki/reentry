import 'package:flutter/material.dart';
import 'package:reentry/ui/components/LoadingOverlay.dart';

import '../../../core/theme/colors.dart';

class BaseScaffold extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;
  final bool isLoading;

  const BaseScaffold(
      {super.key, required this.child, this.appBar, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
        color: AppColors.black.withOpacity(.5),
        isLoading: isLoading,
        progressIndicator: const SizedBox(
          width: 30,
          height: 30,
          child: CircularProgressIndicator(
            color: AppColors.white,
          ),
        ),
        child: Scaffold(
          appBar: appBar,
          backgroundColor: AppColors.black,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: child,
          ),
        ));
  }
}
