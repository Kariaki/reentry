import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:reentry/ui/components/LoadingOverlay.dart';

import '../../../core/theme/colors.dart';

class BaseScaffold extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;
  final bool isLoading;
  final double? horizontalPadding;

  const BaseScaffold(
      {super.key,
      required this.child,
      this.appBar,
      this.isLoading = false,
      this.horizontalPadding});

  @override
  Widget build(BuildContext context) {
    print('width ${MediaQuery.of(context).size.width}');
    final width = MediaQuery.of(context).size.width;
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
          backgroundColor: kIsWeb ? AppColors.greyDark : AppColors.black,
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: horizontalPadding ?? 20),
              child: child,
              // child: width < 840
              //     ? child
              //     : ConstrainedBox(
              //   constraints: BoxConstraints(
              //       maxWidth: width >= 1024
              //           ? MediaQuery.of(context).size.width / (1.5)
              //           : double.infinity),
              //   child: ,
              // ),
            ),
          ),
        ));
  }
}
