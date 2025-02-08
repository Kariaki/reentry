import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:reentry/core/const/app_constants.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/ui/components/pill_selector_component.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/modules/authentication/bloc/authentication_bloc.dart';
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
import '../bloc/onboarding_cubit.dart';

class WebCareTeamInfoScreen extends HookWidget {
  const WebCareTeamInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final key = useMemoized(() => GlobalKey<FormState>());

    final data = context.read<OnboardingCubit>().state!;
    final selectedServices = useState<Set<String>>({});
    final organizationController = useTextEditingController();
    final organizationAddressController = useTextEditingController();
    final jobTitleController = useTextEditingController();
    final supervisorNameController = useTextEditingController();
    final supervisorEmailController = useTextEditingController();
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is RegistrationSuccessFull) {
          context.showSnackbarSuccess('Account created successfully');
          context.goNamed(AppRoutes.success.name);
          if (state.data.accountType != AccountType.citizen) {
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
                              Text("Let's know more about you!",style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),),
                              5.height,
                              Text("Enter your details to help us know you more",style: Theme.of(context).textTheme.bodyMedium,),
                              50.height,
                              50.height,
                              InputField(
                                hint: 'Organisation name',
                                controller: organizationController,
                                label: 'Organisation',
                              ),
                              15.height,
                              InputField(
                                label: 'Organisation address',
                                controller: organizationAddressController,
                                hint: 'Street, City, State',
                              ),
                              15.height,
                              InputField(
                                label: 'Job title',
                                controller: jobTitleController,
                                hint: 'Job title',
                              ),
                              15.height,
                              InputField(
                                label: 'Supervisor\'s name',
                                controller: supervisorNameController,
                                validator: (a)=>null,
                                hint: 'First name, Last name',
                              ),
                              15.height,
                              InputField(
                                label: 'Supervisor\'s email',
                                controller: supervisorEmailController,
                                validator: (a)=>null,
                                hint: 'hello@mail.com',
                              ),
                              15.height,
                              Text(
                                'What services do you offer?',
                                style: AppTextStyle.heading.copyWith(
                                    color: AppColors.white, fontSize: 14),
                              ),
                              10.height,
                              Wrap(
                                children: List.generate(
                                    AppConstants.careTeamServices.length,
                                    (index) {
                                  final e =
                                      AppConstants.careTeamServices[index];
                                  return PillSelectorComponent1(
                                      selected:
                                          selectedServices.value.contains(e),
                                      text: e,
                                      callback: () {

                                        if (selectedServices.value
                                            .contains(e)) {
                                          selectedServices.value =
                                              selectedServices.value
                                                  .where((value) => value != e)
                                                  .toSet();
                                          return;
                                        }
                                        // if(selectedServices.value.length==4){
                                        //   return;
                                        // }
                                        selectedServices.value = {
                                          ...selectedServices.value,
                                          e
                                        };
                                      });
                                }).toList(),
                              ),
                              50.height,
                              PrimaryButton(
                                text: 'Save',
                                loading: state is AuthLoading,
                                onPress: () {
                                  if (key.currentState!.validate()) {
                                    if(selectedServices.value.isEmpty){
                                      context.showSnackbarError('Please select a service');
                                      return;
                                    }
                                    final result = data.copyWith(
                                        organizationAddress:
                                            organizationAddressController.text,
                                        organization:
                                            organizationController.text,
                                        jobTitle: jobTitleController.text,
                                        services:
                                            selectedServices.value.toList(),
                                        supervisorsName:
                                            supervisorNameController.text,
                                        supervisorsEmail:
                                            supervisorEmailController.text);
                                    context
                                        .read<AuthBloc>()
                                        .add(RegisterEvent(data: result));
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
