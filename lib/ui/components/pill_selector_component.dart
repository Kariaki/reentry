import 'package:flutter/cupertino.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/style/text_style.dart';

class PillSelectorComponent extends StatelessWidget {
  final String text;
  final bool selected;

  const PillSelectorComponent(
      {super.key, required this.text, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: ShapeDecoration(
        color: selected?AppColors.white:AppColors.gray1,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      ),
      alignment: Alignment.center,
      child:
      Text(
        text,
        style: AppTextStyle.buttonText
            .copyWith(color: selected?AppColors.black:AppColors.white,fontWeight: FontWeight.bold),
      ),
    );
  }
}
