class UtilityState{}

class UtilitySuccess extends UtilityState{}
class UtilityFailed extends UtilityState{
  final String error;
  UtilityFailed(this.error);
}
class UtilityLoading extends UtilityState{}
class UtilityInitial extends UtilityState{}