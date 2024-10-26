import 'package:flutter/cupertino.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/ui/components/buttons/primary_button.dart';
import '../../core/extensions.dart';
class ErrorComponent extends StatelessWidget {
  final String? title;
  final String? description;
  final VoidCallback? onActionButtonClick;
  final String? actionButtonText;

  const ErrorComponent({super.key, this.title,this.description,this.actionButtonText,this.onActionButtonClick});


  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    return Center(
      child: Padding(padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title??'Something went wrong',style: textTheme.bodyLarge?.copyWith(fontSize: 18),),
          if(description!=null)
            ...[
              5.height,
              Text(description!,style: textTheme.bodyMedium?.copyWith(color: AppColors.white),)
            ],
          20.height,
          PrimaryButton(text: actionButtonText??'Retry',onPress: onActionButtonClick,minWidth: 200,)
        ],
      ),),
    );
  }
}
