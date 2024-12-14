import 'package:flutter/material.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import '../feeling_screen.dart';

class ChangeFeelingCardComponent extends StatelessWidget {
  const ChangeFeelingCardComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = context.textTheme;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: ShapeDecoration(shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15)
      ),
      color: AppColors.primary.withOpacity(.75)),
      child:Row(
        children: [
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('How are you feeling today?'),
              10.height,
              Text("Take a moment to add your current mood")
            ],
          )),
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: (){
              context.pushRoute(const FeelingScreen(
                onboarding: false,
              ));
            },
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: ShapeDecoration(
                shape: CircleBorder(),
                color: AppColors.white,
              ),
              child: Container(
                decoration: ShapeDecoration(
                  shape: CircleBorder(),
                  color: AppColors.black,
                ),
                padding: const EdgeInsets.all(3),
                child: const Icon(Icons.add,color: AppColors.white,size: 18,),
              ),
            ),
          )
        ],
      ) ,
    );
  }
}
