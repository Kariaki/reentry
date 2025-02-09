import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/ui/components/app_bar.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import '../../../core/theme/style/app_styles.dart';

class OnboardingScaffold extends StatelessWidget {
  final List<Widget> children;
  final String? title;
  final String? description;
  final bool showBack;
  final bool isLoading;

  final GlobalKey<FormState>? formKey;

  const OnboardingScaffold(
      {super.key,
      this.formKey,
      required this.children,
      this.title,
      this.description,
      this.showBack = true,
      this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    final theme = AppStyles.textTheme(context);
    return BaseScaffold(
        isLoading: isLoading,
        appBar:kIsWeb?null: CustomAppbar(
          showBack: showBack,
        ),
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: kIsWeb ? 500 : double.infinity,
              ),
              child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (title != null) ...[
                        Text(
                          title ?? '',
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
                  )),
            ),
          ),
        ));
  }
}
