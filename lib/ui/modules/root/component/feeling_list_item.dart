import 'package:flutter/cupertino.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/data/model/user_dto.dart';
import '../feeling_screen.dart';

class FeelingListItem extends StatelessWidget {
  final FeelingDto feelingDto;

  const FeelingListItem({super.key, required this.feelingDto});

  @override
  Widget build(BuildContext context) {
    final textStyle = context.textTheme;
    final feeling =
        getFeelings().where((e) => e.emotion == feelingDto.emotion).first;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      height: 40,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            side: const BorderSide(color: AppColors.greyWhite)),
      ),
      child: Row(
        children: [
          Expanded(
              child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(feeling.asset),
              10.width,
              Text(
                feeling.title,
                style: const TextStyle(fontWeight: FontWeight.w400),
              )
            ],
          )),
          Text(
            feelingDto.date.formatDate(),
            style: textStyle.bodySmall?.copyWith(color: AppColors.gray2),
          )
        ],
      ),
    );
  }
}
