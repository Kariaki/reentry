import 'package:flutter/material.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/core/theme/style/text_style.dart';

class PrimaryButton extends StatelessWidget {
  final bool loading;
  final String text;
  final VoidCallback? onPress;
  final bool enable;
  final Widget? startIcon;
  final Color? color;
  final Color? textColor;
  final double? minWidth;

  const PrimaryButton(
      {super.key,
      this.enable = true,
      this.color,
      this.textColor,
        this.minWidth,
      this.startIcon,
      this.loading = false,
      required this.text,
      this.onPress});

  static PrimaryButton dark(
      {required String text,
      bool loading = false,
        bool enable=true,
      VoidCallback? onPress,
      Widget? startIcon}) {
    return PrimaryButton(
      text: text,
      onPress: onPress,
      enable: enable,

      startIcon: startIcon,
      loading: loading,
      color: AppColors.gray1,
      textColor: AppColors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: color ?? AppColors.white,
      onPressed: () {
        if(!enable){
          return;
        }
        onPress?.call();
        FocusScope.of(context).unfocus();
      },
      height: 50,
      minWidth:minWidth?? double.infinity,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      disabledColor: (color ?? AppColors.white).withOpacity(.6),
      child: loading
          ? SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: textColor ?? AppColors.black,
              ),
            )
          : Row(
              mainAxisAlignment: startIcon == null
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.spaceBetween,
              children: [
                if (startIcon != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: startIcon,
                  ),
                Text(
                  text,
                  style: AppTextStyle.buttonText.copyWith(
                      color: textColor ?? AppColors.black,
                      fontWeight: FontWeight.bold),
                ),
                if (startIcon != null) 0.height,
              ],
            ),
    );
  }
}
