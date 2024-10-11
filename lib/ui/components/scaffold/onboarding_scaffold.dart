import 'package:flutter/cupertino.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/ui/components/app_bar.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import '../../../core/theme/style/app_styles.dart';

class OnboardingScaffold extends StatelessWidget {
  final List<Widget> children;
  final String? title;
  final String? description;
  final bool showBack;

  const OnboardingScaffold(
      {super.key, required this.children, this.title, this.description,this.showBack=true});

  @override
  Widget build(BuildContext context) {
    final theme = AppStyles.textTheme(context);
    return BaseScaffold(
        appBar:  CustomAppbar(showBack: showBack,),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null) ...[
                Text(
                  title??'',
                  style: theme.titleSmall,
                ),
              ],
              if (description != null) ...[
                10.height,
                Text(
                  description!,
                  style: theme.bodyLarge,
                )
              ],
              ...children
            ],
          ),
        ));
  }
}
