// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/core/util/input_validators.dart';
import 'package:reentry/data/enum/account_type.dart';
import 'package:reentry/data/model/incidence_dto.dart';
import 'package:reentry/data/model/user_dto.dart';
import 'package:reentry/generated/assets.dart';
import 'package:reentry/ui/components/error_component.dart';
import 'package:reentry/ui/components/input/dropdownField.dart';
import 'package:reentry/ui/components/input/input_field.dart';
import 'package:reentry/ui/components/loading_component.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/modules/authentication/bloc/account_cubit.dart';
import 'package:reentry/ui/modules/citizens/component/icon_button.dart';
import 'package:reentry/ui/modules/clients/bloc/client_cubit.dart';
import 'package:reentry/ui/modules/clients/bloc/client_state.dart';
import 'package:reentry/ui/modules/incidents/cubit/report_cubit.dart';
import 'package:reentry/ui/modules/messaging/entity/conversation_user_entity.dart';
import 'package:reentry/ui/modules/profile/bloc/profile_cubit.dart';
import 'package:reentry/ui/modules/profile/bloc/profile_state.dart';
import 'package:reentry/ui/modules/util/bloc/utility_bloc.dart';
import 'package:reentry/ui/modules/util/bloc/utility_event.dart';
import 'package:reentry/ui/modules/util/bloc/utility_state.dart';

class SettingsPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<FormState>();
    final incidentKey = GlobalKey<FormState>();
    final supportKey = GlobalKey<FormState>();
    final selectedUser = useState<ConversationUserEntity?>(null);
    final incidentFiledController = useTextEditingController();
    final incidentTitleFiledController = useTextEditingController();
    final titleController = useTextEditingController();
    final descriptionController = useTextEditingController();
    final _selectedImageBytes = useState<Uint8List?>(null);
    String? _imageUrl;

    Future<void> _pickImage(UserDto user) async {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true,
      );

      final XFile? image = result?.xFiles.first;

      final bytes = await image?.readAsBytes();

      if (result != null && bytes != null) {
        final fileName = result.files.single.name;
        _selectedImageBytes.value = bytes;
      }
    }

    return BlocProvider(
      create: (context) =>
          ConversationUsersCubit()..fetchConversationUsers(showLoader: true),
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (_, current) {
          if (current is ProfileSuccess) {
            if (current.user != null) {
              context.read<AccountCubit>().setAccount(current.user!);
            }
            context.showSnackbarSuccess("Profile updated successfully");
          }
          if (current is ProfileError) {
            context.showSnackbarError(current.message);
          }
        },
        builder: (context, state) {
          return BaseScaffold(
            isLoading: state is ProfileLoading,
            child: Scrollbar(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Personal info',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: AppColors.greyWhite,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                              ),
                              8.height,
                              Text(
                                'Update your photo and personal details.',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: AppColors.greyWhite,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        32.height,
                        BlocBuilder<AccountCubit, UserDto?>(
                          builder: (context, state) {
                            if (state == null) {
                              return const Center(
                                child: Text("No user found"),
                              );
                            }
                            final user = state;
                            return HookBuilder(
                              builder: (context) {
                                final supervisorNameController =
                                    useTextEditingController(
                                        text: user.supervisorsName);
                                final supervisorEmailController =
                                    useTextEditingController(
                                        text: user.supervisorsEmail);
                                final organizationNameController =
                                    useTextEditingController(
                                        text: user.organization);
                                final organizationAddressController =
                                    useTextEditingController(
                                        text: user.organizationAddress);
                                final phoneNumberController =
                                    useTextEditingController(
                                        text: user.phoneNumber);
                                final nameController =
                                    useTextEditingController(text: user.name);
                                final address = useTextEditingController(
                                    text: user.address);
                                _imageUrl = user.avatar;
                                print("thi is the image: $_imageUrl");
                                return Form(
                                  key: key,
                                  child: Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        InputField(
                                          hint: 'Full name',
                                          controller: nameController,
                                          enable: true,
                                          label: "Name",
                                          radius: 8.0,
                                        ),
                                        24.height,
                                        InputField(
                                          hint: '(000) 000-0000',
                                          controller: phoneNumberController,
                                          enable: true,
                                          phone: true,
                                          label: "Phone number",
                                          radius: 8.0,
                                        ),
                                        24.height,
                                        InputField(
                                          hint: '(000) 000-0000',
                                          controller: TextEditingController(
                                              text: user.email ?? ''),
                                          enable: false,
                                          phone: true,
                                          label: "Email address",
                                          radius: 8.0,
                                        ),
                                        if ((user.accountType !=
                                                    AccountType.admin ||
                                                user.accountType !=
                                                    AccountType.reentry_orgs) &&
                                            user.dob != null) ...[
                                          24.height,
                                          InputField(
                                            hint: '(000) 000-0000',
                                            controller: TextEditingController(
                                                text: user.dob ?? ''),
                                            enable: false,
                                            phone: true,
                                            label: "Date of birth",
                                            radius: 8.0,
                                          )
                                        ],
                                        24.height,
                                        InputField(
                                          hint: 'Address',
                                          controller: address,
                                          enable: true,
                                          label: "Address",
                                          radius: 8.0,
                                        ),
                                        24.height,
                                        Row(
                                          children: [
                                            if (user.supervisorsName
                                                    ?.isNotEmpty ??
                                                false) ...[
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(height: 8),
                                                    InputField(
                                                      hint: 'Supervisors Name',
                                                      controller:
                                                          supervisorNameController,
                                                      label: 'Supervisors Name',
                                                      radius: 8.0,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                            16.width,
                                            if (user.supervisorsEmail
                                                    ?.isNotEmpty ??
                                                false) ...[
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(height: 8),
                                                    InputField(
                                                      hint: 'Supervisors Email',
                                                      label:
                                                          'Supervisors Email',
                                                      controller:
                                                          supervisorEmailController,
                                                      radius: 8.0,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ]
                                          ],
                                        ),
                                        24.height,
                                        Row(
                                          children: [
                                            if (user.organization?.isNotEmpty ??
                                                false) ...[
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(height: 8),
                                                    InputField(
                                                      hint: 'Organization name',
                                                      label:
                                                          'Organization name',
                                                      controller:
                                                          organizationNameController,
                                                      enable: true,
                                                      radius: 8.0,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                            16.width,
                                            if (user.organizationAddress
                                                    ?.isNotEmpty ??
                                                false) ...[
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(height: 8),
                                                    InputField(
                                                      hint:
                                                          'Organization address',
                                                      label:
                                                          'Organization address',
                                                      controller:
                                                          organizationAddressController,
                                                      radius: 8.0,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ]
                                          ],
                                        ),
                                        24.height,
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                GestureDetector(
                                                  onTap: () async {
                                                    final result =
                                                        await FilePicker
                                                            .platform
                                                            .pickFiles(
                                                      type: FileType.image,
                                                      allowMultiple: false,
                                                      withData: true,
                                                    );

                                                    final XFile? image =
                                                        result?.xFiles.first;

                                                    final bytes = await image
                                                        ?.readAsBytes();

                                                    if (result != null &&
                                                        bytes != null) {
                                                      final fileName = result
                                                          .files.single.name;
                                                      _selectedImageBytes
                                                          .value = bytes;
                                                    }
                                                  },
                                                  child: CircleAvatar(
                                                    radius: 40,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    backgroundImage: _selectedImageBytes
                                                                .value !=
                                                            null
                                                        ? MemoryImage(
                                                            _selectedImageBytes
                                                                .value!)
                                                        : _imageUrl != null
                                                            ? NetworkImage(
                                                                _imageUrl!)
                                                            : NetworkImage(
                                                                    _imageUrl!)
                                                                as ImageProvider,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Container(
                                                    height: 150,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.grey),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Center(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          GestureDetector(
                                                              onTap: () =>
                                                                  _pickImage(
                                                                      user),
                                                              child: SvgPicture
                                                                  .asset(Assets
                                                                      .webUpload)),
                                                          const SizedBox(
                                                              height: 8),
                                                          Text.rich(
                                                            TextSpan(
                                                              children: [
                                                                TextSpan(
                                                                  text:
                                                                      'Click to upload',
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodySmall
                                                                      ?.copyWith(
                                                                        color: AppColors
                                                                            .primary,
                                                                        fontSize:
                                                                            14,
                                                                      ),
                                                                ),
                                                                TextSpan(
                                                                  text:
                                                                      ' or drag and drop',
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodySmall
                                                                      ?.copyWith(
                                                                        color: AppColors
                                                                            .greyWhite,
                                                                        fontSize:
                                                                            14,
                                                                      ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Text(
                                                            'SVG, PNG, JPG or GIF (max. 800x400px)',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodySmall
                                                                ?.copyWith(
                                                                  color:
                                                                      AppColors
                                                                          .gray2,
                                                                  fontSize: 12,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        32.height,
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              _cancelButton(
                                                  supervisorNameController,
                                                  user,
                                                  supervisorEmailController,
                                                  organizationNameController,
                                                  organizationAddressController,
                                                  phoneNumberController,
                                                  address,_selectedImageBytes),
                                              3.width,
                                              CustomIconButton(
                                                label: "Save Changes",
                                                backgroundColor:
                                                    AppColors.white,
                                                loading:
                                                    state is ProfileLoading,
                                                textColor: AppColors.black,
                                                loaderColor: AppColors.primary,
                                                onPressed: () {
                                                  if (key.currentState!
                                                      .validate()) {
                                                    var userData = user.copyWith(
                                                            supervisorsEmail:
                                                                supervisorEmailController
                                                                    .text,
                                                            address:
                                                                address.text,
                                                            name: nameController
                                                                .text,
                                                            phoneNumber:
                                                                phoneNumberController
                                                                    .text,
                                                            organization:
                                                                organizationNameController
                                                                    .text,
                                                            organizationAddress:
                                                                organizationAddressController
                                                                    .text,
                                                            supervisorsName:
                                                                supervisorNameController
                                                                    .text);
                                                    context.read<ProfileCubit>().updateProfilePhotoWeb(
                                                        _selectedImageBytes
                                                            .value,
                                                        userData);
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    90.height,
                    BlocBuilder<AccountCubit, UserDto?>(
                        builder: (context, thisUser) {
                      if (thisUser?.accountType == AccountType.admin ||
                          thisUser?.accountType == AccountType.reentry_orgs) {
                        return SizedBox();
                      }
                      return BlocProvider(
                        create: (context) => UtilityBloc(),
                        child: BlocConsumer<UtilityBloc, UtilityState>(
                          listener: (_, state) {
                            if (state is UtilityFailed) {
                              context.showSnackbarError(state.error);
                            }
                            if (state is UtilitySuccess) {
                              context.showSnackbarSuccess(
                                  "Your report will be reviewed");
                            }
                            if (state is SupportSuccess) {
                              context.showSnackbarSuccess(
                                  "Your support ticket has been submitted successfully.");
                              titleController.clear();
                              descriptionController.clear();
                            }
                            if (state is SupportFailure) {
                              context.showSnackbarError(state.error);
                            }
                          },
                          builder: (context, state) {
                            return Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        'Report an incident',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: AppColors.greyWhite,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                            ),
                                      ),
                                    ),
                                    32.height,
                                    BlocBuilder<ConversationUsersCubit,
                                        ClientState>(
                                      builder: (ctx, state) {
                                        if (state is ClientLoading) {
                                          return const LoadingComponent();
                                        }

                                        if (state is ClientError) {
                                          return ErrorComponent(
                                            title: "Something went wrong!",
                                            description:
                                                "There is no one here, try refreshing",
                                            onActionButtonClick: () {
                                              ctx
                                                  .read<
                                                      ConversationUsersCubit>()
                                                  .fetchConversationUsers(
                                                      showLoader: true);
                                            },
                                          );
                                        }

                                        if (state
                                            is ConversationUserStateSuccess) {
                                          final userData =
                                              state.data.values.toList();
                                          print("listed user $userData");
                                          return Form(
                                            key: incidentKey,
                                            child: Expanded(
                                              flex: 2,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Select user",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall
                                                        ?.copyWith(
                                                          color: AppColors
                                                              .greyWhite,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 14,
                                                        ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  userData.isEmpty
                                                      ? Center(
                                                          child: Text(
                                                            "No users available at the moment",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyMedium
                                                                ?.copyWith(
                                                                  color: AppColors
                                                                      .greyWhite,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 14,
                                                                ),
                                                          ),
                                                        )
                                                      : DropdownField<
                                                          ConversationUserEntity>(
                                                          hint:
                                                              "Select user from the dropdown",
                                                          value: selectedUser
                                                              .value,
                                                          items: userData
                                                              .map((user) {
                                                            return DropdownMenuItem(
                                                              value: user,
                                                              child: Text(
                                                                  user.name),
                                                            );
                                                          }).toList(),
                                                          onChanged: (value) {
                                                            selectedUser.value =
                                                                value;
                                                          },
                                                          fillColor: AppColors
                                                              .greyDark,
                                                          textColor:
                                                              AppColors.white,
                                                          borderColor: AppColors
                                                              .inputBorderColor,
                                                        ),
                                                  24.height,
                                                  InputField(
                                                    controller:
                                                        incidentTitleFiledController,
                                                    hint:
                                                        'Enter title of incident',
                                                    label: 'Title',
                                                    validator: InputValidators
                                                        .stringValidation,
                                                    lines: 1,
                                                    maxLines: 1,
                                                    radius: 15,
                                                  ),
                                                  32.height,
                                                  InputField(
                                                    controller:
                                                        incidentFiledController,
                                                    hint:
                                                        'Enter the details of the incident',
                                                    label: 'Incident',
                                                    validator: InputValidators
                                                        .stringValidation,
                                                    lines: 3,
                                                    maxLines: 5,
                                                    radius: 15,
                                                  ),
                                                  32.height,
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        CustomIconButton(
                                                          label: "Cancel",
                                                          backgroundColor:
                                                              AppColors
                                                                  .greyDark,
                                                          textColor:
                                                              AppColors.white,
                                                          borderColor:
                                                              AppColors.white,
                                                          onPressed: () {
                                                            selectedUser.value =
                                                                null;
                                                            incidentFiledController
                                                                .clear();
                                                            incidentTitleFiledController
                                                                .clear();
                                                          },
                                                        ),
                                                        5.width,
                                                        CustomIconButton(
                                                          label: "Submit",
                                                          backgroundColor:
                                                              selectedUser.value ==
                                                                      null
                                                                  ? AppColors
                                                                      .greyDark
                                                                  : AppColors
                                                                      .white,
                                                          textColor: selectedUser
                                                                      .value ==
                                                                  null
                                                              ? AppColors.gray2
                                                              : AppColors.black,
                                                          borderColor:
                                                              AppColors.white,
                                                          loading: state
                                                              is UtilityLoading,
                                                          onPressed: () {
                                                            if (incidentKey
                                                                .currentState!
                                                                .validate()) {
                                                              final selectedUserId =
                                                                  selectedUser
                                                                      .value!
                                                                      .userId;

                                                              context.read<UtilityBloc>().add(ReportUserEvent(IncidenceDto(
                                                                  title:
                                                                      incidentTitleFiledController
                                                                          .text,
                                                                  description:
                                                                      incidentFiledController
                                                                          .text,
                                                                  date: DateTime
                                                                      .now(),
                                                                  id: '',
                                                                  reported: UsersInvolved(
                                                                      name: selectedUser.value?.name ??
                                                                          '',
                                                                      userId:
                                                                          selectedUserId,
                                                                      account: AccountType
                                                                          .mentor),
                                                                  victim: UsersInvolved(
                                                                      name: thisUser?.name ??
                                                                          "",
                                                                      userId:
                                                                          thisUser?.userId ??
                                                                              '',
                                                                      account:
                                                                          thisUser?.accountType ??
                                                                              AccountType.citizen))));
                                                            }
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }
                                        return Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "Fetching users...",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: AppColors.greyWhite,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14,
                                                ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                90.height,
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        'Support',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: AppColors.greyWhite,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                            ),
                                      ),
                                    ),
                                    32.height,
                                    Expanded(
                                      flex: 2,
                                      child: Form(
                                        key: supportKey,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            24.height,
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                8.height,
                                                InputField(
                                                  hint: 'Enter title',
                                                  label: 'Title',
                                                  radius: 8.0,
                                                  controller: titleController,
                                                ),
                                              ],
                                            ),
                                            24.height,
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                InputField(
                                                  hint: 'Enter the description',
                                                  label: 'Description',
                                                  lines: 3,
                                                  maxLines: 5,
                                                  radius: 15,
                                                  controller:
                                                      descriptionController,
                                                ),
                                              ],
                                            ),
                                            32.height,
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  CustomIconButton(
                                                    label: "Cancel",
                                                    backgroundColor:
                                                        AppColors.greyDark,
                                                    textColor: AppColors.white,
                                                    borderColor:
                                                        AppColors.white,
                                                    onPressed: () {
                                                      descriptionController
                                                          .clear();
                                                      titleController.clear();
                                                    },
                                                  ),
                                                  3.width,
                                                  CustomIconButton(
                                                    label: "Save Changes",
                                                    backgroundColor:
                                                        AppColors.white,
                                                    loading:
                                                        state is UtilityLoading,
                                                    textColor: AppColors.black,
                                                    loaderColor:
                                                        AppColors.primary,
                                                    onPressed: () {
                                                      if (supportKey
                                                          .currentState!
                                                          .validate()) {
                                                        context
                                                            .read<UtilityBloc>()
                                                            .add(
                                                              SupportTicketEvent(
                                                                  title:
                                                                      titleController
                                                                          .text,
                                                                  description:
                                                                      descriptionController
                                                                          .text),
                                                            );
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _cancelButton(
      TextEditingController supervisorNameController,
      UserDto user,
      TextEditingController supervisorEmailController,
      TextEditingController organizationNameController,
      TextEditingController organizationAddressController,
      TextEditingController phoneNumberController,
      TextEditingController address,
      ValueNotifier<Uint8List?> image,) {
    return CustomIconButton(
      label: "Cancel",
      backgroundColor: AppColors.greyDark,
      textColor: AppColors.white,
      borderColor: AppColors.white,
      onPressed: () {
        image.value=null;
        supervisorNameController.text = user.supervisorsName ?? '';
        supervisorEmailController.text = user.supervisorsEmail ?? '';

        organizationNameController.text = user.organization ?? '';
        organizationAddressController.text = user.organizationAddress ?? '';
        phoneNumberController.text = user.phoneNumber ?? '';
        address.text = user.address ?? '';
      },
    );
  }
}
