class CubitState {}

class CubitStateLoading extends CubitState{}

class CubitStateError extends CubitState {
  CubitStateError(this.message);

  final String message;
}
class CubitStateSuccess extends CubitState{}
class CubitDataStateSuccess<T> extends CubitState {

  CubitDataStateSuccess(this.data);
  final T data;
}
