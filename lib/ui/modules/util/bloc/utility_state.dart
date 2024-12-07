class UtilityState{}

class UtilitySuccess extends UtilityState{}
class UtilityFailed extends UtilityState{
  final String error;
  UtilityFailed(this.error);
}
class UtilityLoading extends UtilityState{}
class UtilityInitial extends UtilityState{}

class SupportFailure extends UtilityState {
  final String error;
  SupportFailure(this.error);
}
class SupportSuccess extends UtilityState {}

