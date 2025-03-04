import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/ui/components/buttons/primary_button.dart';
import '../../core/extensions.dart';

class ErrorComponent extends StatelessWidget {
  final String? title;
  final String? description;
  final VoidCallback? onActionButtonClick;
  final String? actionButtonText;
  final bool showButton;

  const ErrorComponent(
      {super.key,
      this.showButton = true,
      this.title,
      this.description,
      this.actionButtonText,
      this.onActionButtonClick});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title ?? 'Something went wrong',
              style: textTheme.bodyLarge?.copyWith(fontSize: 18),
            ),
            if (description != null) ...[
              5.height,
              Text(

                description!,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(color: AppColors.gray2),
              )
            ],
            20.height,
            if (showButton)
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth:kIsWeb? (MediaQuery.of(context).size.width.toDouble()/2.5):MediaQuery.of(context).size.width/2
                ),
                child: PrimaryButton(
                  text: actionButtonText ?? 'Retry',
                  onPress: onActionButtonClick,

                  minWidth: 200,
                ),
              )
          ],
        ),
      ),
    );
  }
}
