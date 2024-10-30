import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/ui/components/app_bar.dart';
import 'package:reentry/ui/components/buttons/primary_button.dart';
import 'package:reentry/ui/components/input/input_field.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/modules/authentication/bloc/account_cubit.dart';
import 'package:reentry/ui/modules/profile/bloc/profile_cubit.dart';
import 'package:reentry/ui/modules/profile/bloc/profile_state.dart';

import '../../../data/model/user_dto.dart';

class ProfileScreen extends HookWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedFile = useState<XFile?>(null);
    return BlocConsumer<ProfileCubit, ProfileState>(listener: (_, current) {
      if (current is ProfileSuccess) {
        context.read<AccountCubit>().readFromLocalStorage();
      }
    }, builder: (context, state) {
      return BaseScaffold(
          isLoading: state is ProfileLoading,
          appBar: const CustomAppbar(
            title: "Reentry",
          ),
          child: BlocBuilder<AccountCubit, UserDto?>(builder: (context, state) {
            if (state == null) {
              return const Center(
                child: Text("No user found"),
              );
            }
            final user = state;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: Stack(
                        children: [
                          SizedBox(
                            height: 60,
                            width: 60,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(state.avatar ?? ''),
                            ),
                          ),
                          Positioned(
                              right: -1,
                              bottom: 0,
                              child: GestureDetector(
                                onTap: () async {
                                  final result = await pickFile();
                                  selectedFile.value = result;
                                  if (result == null) {
                                    return;
                                  }
                                  context
                                      .read<ProfileCubit>()
                                      .updateProfilePhoto(result);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: ShapeDecoration(
                                    shape: CircleBorder(
                                        side:
                                            BorderSide(color: AppColors.gray1)),
                                    color: AppColors.white,
                                  ),
                                  child: Icon(
                                    Icons.camera_alt,
                                    size: 10,
                                    color: AppColors.black,
                                  ),
                                ),
                              ))
                        ],
                      ),
                    ),
                    10.width,
                    Text(
                      user.name ?? '',
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 18,
                      ),
                    )
                  ],
                ),
                20.height,
                InputField(
                  hint: 'Email',
                  controller: TextEditingController(text: user.email ?? ''),
                  enable: false,
                ),
                if (user.supervisorsName != null) ...[
                  20.height,
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Text("Supervisor name",style: TextStyle(fontSize: 16,color: AppColors.gray2),),
                     Text(user.supervisorsName ?? '',style: TextStyle(fontSize: 16,color: AppColors.white),)
                   ],
                 )
                ],
                if (user.supervisorsEmail != null) ...[
                  15.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Supervisor Email",style: TextStyle(fontSize: 16,color: AppColors.gray2),),
                      Text(user.supervisorsEmail ?? '',style: TextStyle(fontSize: 16,color: AppColors.white),)
                    ],
                  )
                ],
                if (user.organization != null) ...[
                  15.height, Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Organization Name",style: TextStyle(fontSize: 16,color: AppColors.gray2),),
                      Text(user.organization ?? '',style: TextStyle(fontSize: 16,color: AppColors.white),)
                    ],
                  )
                ],
                if (user.organizationAddress != null) ...[
                  15.height,Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Organization address",style: TextStyle(fontSize: 16,color: AppColors.gray2),),
                      Text(user.organizationAddress ?? '',style: TextStyle(fontSize: 16,color: AppColors.white),)
                    ],
                  )
                ],
                20.height,
                // PrimaryButton(
                //   text: 'Update',
                //   onPress: () {},
                // )
              ],
            );
          }));
    });
  }

  Future<XFile?> pickFile() async {
    final ImagePicker picker = ImagePicker();
    final pickResult = await picker.pickImage(source: ImageSource.gallery);
    return pickResult;
  }

  void updateImage() async {}
}
