import 'package:beamer/beamer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/routes/routes.dart';
import 'package:reentry/ui/components/scaffold/onboarding_scaffold.dart';
import 'package:reentry/ui/modules/authentication/bloc/authentication_state.dart';
import 'package:reentry/ui/modules/authentication/onboarding_success.dart';
import '../../../core/theme/style/app_styles.dart';
import '../../components/app_radio_button.dart';
import '../../components/buttons/primary_button.dart';
import '../../components/input/input_field.dart';
import 'bloc/auth_events.dart';
import 'bloc/authentication_bloc.dart';
import 'bloc/onboarding_cubit.dart';

final serviceOptions = [
  'Food',
  'Health',
  'Housing',
  'Money',
  'Education',
  'Goods',
  'Legal',
  'Transit',
  'Work',
  'Care'
];

class OnboardingSelectService extends HookWidget {
  const OnboardingSelectService({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final data = context.read<OnboardingCubit>().state!;
    debugPrint('Data retrieved in PeerMentorOrganizationInfoScreen: $data');
    final key = GlobalKey<FormState>();
    final selectedItem = useState<List<String>>([]);
    final theme = AppStyles.textTheme(context);
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (_, state) {
        if (state is RegistrationSuccessFull) {
          if (kIsWeb) {
            context.goNamed(AppRoutes.success.name);
          } else {
            context.pushRemoveUntil(const OnboardingSuccess());
          }
        }
        if (state is AuthError) {
          context.showSnackbarError(state.message);
        }
      },
      builder: (context, state) {
        return OnboardingScaffold(
            formKey: key,
            title: 'What services do you offer?',
            children: [
              50.height,
              GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, mainAxisExtent: 40),
                shrinkWrap: true,
                children: serviceOptions.map((e) {
                  return AppRadioButton(
                    selected: selectedItem.value.contains(e),
                    text: e,
                    onClick: () {
                      if (selectedItem.value.contains(e)) {
                        selectedItem.value =
                            selectedItem.value.where((_) => _ != e).toList();
                        return;
                      }
                      selectedItem.value = [...selectedItem.value, e];
                    },
                  );
                }).toList(),
              ),
              50.height,
              PrimaryButton(
                text: 'Save',
                enable: selectedItem.value.isNotEmpty,
                loading: state is AuthLoading,
                onPress: () {
                  final result = data.copyWith(services: selectedItem.value);
                  context.read<AuthBloc>().add(RegisterEvent(data: result));
                },
              )
            ]);
      },
    );
  }
}
