class CubitState {
  static final nameLoading = 'loading';
  static final nameSuccess = 'success';
  static final nameError = 'error';
  final String name;
  CubitState({this.name='initial'});
}

class CubitStateLoading extends CubitState{
  CubitStateLoading():super(name: CubitState.nameLoading);
}

class CubitStateError extends CubitState {
  CubitStateError(this.message):super(name: CubitState.nameError);

  final String message;
}
class CubitStateSuccess extends CubitState{

  CubitStateSuccess():super(name: CubitState.nameSuccess);
}
class CubitDataStateSuccess<T> extends CubitState {

  CubitDataStateSuccess(this.data);
  final T data;
}
