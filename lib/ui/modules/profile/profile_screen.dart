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
    final key = GlobalKey<FormState>();
    return BlocConsumer<ProfileCubit, ProfileState>(listener: (_, current) {
      if (current is ProfileSuccess) {
        context.read<AccountCubit>().readFromLocalStorage();
        context.showSnackbarSuccess("Profile updated successfully");
      }
      if (current is ProfileError) {
        context.showSnackbarError(current.message);
      }
    }, builder: (context, state) {
      return BaseScaffold(
          isLoading: state is ProfileLoading,
          appBar: const CustomAppbar(
            title: "Sainte",
          ),
          child: BlocBuilder<AccountCubit, UserDto?>(builder: (context, state) {
            if (state == null) {
              return const Center(
                child: Text("No user found"),
              );
            }
            final user = state;
            return HookBuilder(builder: (context) {
              final supervisorNameController =
                  useTextEditingController(text: user.supervisorsName);
              final supervisorEmailController =
                  useTextEditingController(text: user.supervisorsEmail);
              final organizationNameController =
                  useTextEditingController(text: user.organization);
              final organizationAddressController =
                  useTextEditingController(text: user.organizationAddress);
              final phoneNumberController =
                  useTextEditingController(text: user.phoneNumber);
              final address = useTextEditingController(text: user.address);
              return Form(
                  key: key,
                  child: SingleChildScrollView(
                    child: Column(
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
                                      backgroundImage:
                                          NetworkImage(state.avatar ?? ''),
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
                                          padding: const EdgeInsets.all(8),
                                          decoration: const ShapeDecoration(
                                            shape: CircleBorder(
                                                side: BorderSide(
                                                    color: AppColors.gray1)),
                                            color: AppColors.white,
                                          ),
                                          child: const Icon(
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
                        5.height,
                        Text(
                          'ID: ${state.userCode}',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        20.height,
                        InputField(
                          hint: '(000) 000-0000',
                          controller: phoneNumberController,
                          enable: true,
                          phone: true,
                          label: "Phone number",
                        ),
                        20.height,
                        InputField(
                          hint: 'Address',
                          controller: address,
                          enable: true,
                          label: "Address",
                        ),
                        if (user.supervisorsName?.isNotEmpty ?? false) ...[
                          20.height,
                          InputField(
                            hint: 'Supervisors Name',
                            controller: supervisorNameController,
                            label: 'Supervisors Name',
                            enable: true,
                          ),
                        ],
                        if (user.supervisorsEmail?.isNotEmpty ?? false) ...[
                          15.height,
                          InputField(
                            hint: 'Supervisors Email',
                            label: 'Supervisors Email',
                            controller: supervisorEmailController,
                            enable: true,
                          ),
                        ],
                        if (user.organization?.isNotEmpty ?? false) ...[
                          15.height,
                          InputField(
                            hint: 'Organization name',
                            label: 'Organization name',
                            controller: organizationNameController,
                            enable: true,
                          ),
                        ],
                        if (user.organizationAddress?.isNotEmpty ?? false) ...[
                          15.height,
                          InputField(
                            hint: 'Organization address',
                            label: 'Organization address',
                            controller: organizationAddressController,
                            enable: false,
                          ),
                        ],
                        20.height,
                        PrimaryButton(
                          text: 'Update',
                          onPress: () {
                            if (key.currentState!.validate()) {
                              context.read<ProfileCubit>().updateProfile(
                                  user.copyWith(
                                      supervisorsEmail:
                                          supervisorEmailController.text,
                                      address: address.text,
                                      phoneNumber: phoneNumberController.text,
                                      organization:
                                          organizationNameController.text,
                                      organizationAddress:
                                          organizationAddressController.text,
                                      supervisorsName:
                                          supervisorNameController.text));
                            }
                          },
                        )
                      ],
                    ),
                  ));
            });
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
