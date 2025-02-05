import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/data/shared/share_preference.dart';
import 'package:reentry/ui/modules/authentication/bloc/account_cubit.dart';
import 'package:reentry/ui/modules/root/cubit/feelings_cubit.dart';
import '../../../../data/model/user_dto.dart';
import '../feeling_screen.dart';

class ChangeFeelingCardComponent extends HookWidget {
  const ChangeFeelingCardComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = context.textTheme;

    return BlocBuilder<FeelingsCubit,bool>(builder: (context,state){
      if(state){
        return SizedBox();
      }
      return  FutureBuilder(
          future: PersistentStorage.showFeeling(),
          builder: (context, value) {
            if (!value.hasData) {
              return const SizedBox();
            }
            final show = value.data!;
            if (!show) {
              return SizedBox();
            }
            return Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  color: AppColors.primary.withOpacity(.75)),
              child: Row(
                children: [
                  Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('How are you feeling today?'),
                          10.height,
                          Text("Take a moment to add your current mood")
                        ],
                      )),
                  InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      context.pushRoute(const FeelingScreen(
                        onboarding: false,
                      ));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const ShapeDecoration(
                        shape: CircleBorder(),
                        color: AppColors.white,
                      ),
                      child: Container(
                        decoration: const ShapeDecoration(
                          shape: CircleBorder(),
                          color: AppColors.black,
                        ),
                        padding: const EdgeInsets.all(3),
                        child: const Icon(
                          Icons.add,
                          color: AppColors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          });
    });
  }
}
