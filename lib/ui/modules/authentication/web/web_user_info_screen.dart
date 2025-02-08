import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:reentry/core/const/app_constants.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/ui/components/pill_selector_component.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/modules/authentication/bloc/authentication_state.dart';

import '../../../../core/routes/routes.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style/text_style.dart';
import '../../../../core/util/input_validators.dart';
import '../../../../data/enum/account_type.dart';
import '../../../components/app_bar.dart';
import '../../../components/buttons/primary_button.dart';
import '../../../components/date_time_picker.dart';
import '../../../components/input/input_field.dart';
import '../bloc/auth_events.dart';
import '../bloc/authentication_bloc.dart';
import '../bloc/onboarding_cubit.dart';

class WebOnboardingBasicUserInfo extends HookWidget {
  const WebOnboardingBasicUserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final key = useMemoized(() => GlobalKey<FormState>());

    final data = context.read<OnboardingCubit>().state??OnboardingEntity(email: 'email');
    final date = useState<DateTime?>(DateTime(2000));
    final selectedAccountType = useState<int?>(data.accountType?.index);
    final nameController = useTextEditingController(text: data.name);
    final addressController = useTextEditingController(text: data.address);
    final phoneController = useTextEditingController(text: data.phoneNumber);
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is RegistrationSuccessFull) {

          context.showSnackbarSuccess('Account created successfully');
          context.goNamed(AppRoutes.success.name);
          if (state.data.accountType==AccountType.citizen) {
            context.goNamed(AppRoutes.dashboard.name);
          }
        }
        if (state is AuthError) {
          context.showSnackbarError(state.message);
        }
      },
      builder: (context, state) {
        return BaseScaffold(
            appBar: const CustomAppbar(
              showBack: false,
              title: 'Sainte',
            ),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width / 2.5),
                      child: Form(
                          key: key,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Let's get you set!",style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),),
                              5.height,
                              Text("Enter your details to set your profile",style: Theme.of(context).textTheme.bodyMedium,),
                              50.height,
                              InputField(
                                hint: 'First name Last name',
                                validator: InputValidators.stringValidation,
                                enable: data.name == null,
                                label: 'Full name',
                                controller: nameController,
                              ),
                              15.height,
                              InputField(
                                hint: 'Address',
                                validator: (v) => null,
                                label: 'Street, City, State',
                                controller: addressController,
                              ),
                              15.height,
                              InputField(
                                hint: '(000) 000-0000',
                                controller: phoneController,
                                enable: true,
                                phone: true,
                                label: "Phone number",
                              ),
                              15.height,
                              Text(
                                'Date of birth',
                                style: AppTextStyle.heading.copyWith(
                                    color: AppColors.white, fontSize: 14),
                              ),
                              8.height,
                              DateTimePicker(
                                hint: 'Date of birth',
                                height: 12,
                                title: date.value?.formatDate(),
                                radius: 50,
                                onTap: () async {
                                  final result = await showDatePicker(
                                      initialDate: DateTime(2010),
                                      firstDate: DateTime(2004),
                                      lastDate: DateTime(2024),
                                      onDatePickerModeChange: (value) {},
                                      context: context);
                                  if (result == null) {
                                    return;
                                  }
                                  date.value = result;
                                },
                                // title: date.value?.formatDate(),
                              ),
                              15.height,
                              Row(
                                children: [
                                  Text(
                                    'Profile types',
                                    style: AppTextStyle.heading.copyWith(
                                        color: AppColors.white, fontSize: 14),
                                  ),
                                  5.width,
                                  InkWell(
                                    onTap: () {},
                                    child: const Icon(
                                      Icons.info,
                                      color: AppColors.white,
                                      size: 18,
                                    ),
                                  ),
                                ],
                              ),
                              10.height,
                              PillSelector(
                                options: AppConstants.accountType,
                                initialSelectedItemIndex: selectedAccountType.value??0,
                                onChange: (value) {
                                  selectedAccountType.value = value;
                                },
                                wrap: true,
                              ),
                              50.height,
                              PrimaryButton(
                                text: 'Continue',
                                loading: state is AuthLoading,
                                onPress: () {
                                  if (key.currentState!.validate()) {
                                    if(selectedAccountType.value==null){
                                      context.showSnackbarError('Please select profile type');
                                      return;
                                    }
                                    final result = data.copyWith(
                                        name: nameController.text,
                                        address: addressController.text,
                                        accountType: AccountType.values[selectedAccountType.value??0],
                                        dob: date.value?.toIso8601String(),
                                        phoneNumber: phoneController.text);
                                    context
                                        .read<OnboardingCubit>()
                                        .setOnboarding(result);
                                    if (result.accountType ==
                                        AccountType.citizen) {
                                      //create account;
                                      context
                                          .read<AuthBloc>()
                                          .add(RegisterEvent(data: result));
                                      return;
                                    }
                                    context.goNamed(
                                      AppRoutes.organizationInfo.name,
                                    );
                                  }
                                },
                              ),
                              50.height,
                            ],
                          )),
                    )
                  ],
                ),
              ),
            ));
      },
    );
  }
}
