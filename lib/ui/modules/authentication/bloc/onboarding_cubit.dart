import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/ui/modules/authentication/bloc/authentication_state.dart';

class OnboardingCubit extends Cubit<OnboardingEntity?> {
  OnboardingCubit() : super(null);

  void setOnboarding(OnboardingEntity entity) {
    emit(entity);
  }
}
