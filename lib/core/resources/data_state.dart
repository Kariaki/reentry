
abstract class DataState<T>{
  final T? data;
  final String? error;

  const DataState({this.data,this.error});

  @override
  String toString() {
    // TODO: implement toString
    return 'Data state';
  }
}

class DataLoading<T> extends DataState<T> {
  const DataLoading():super();
  @override
  String toString() {
    // TODO: implement toString
    return 'Data loading';
  }
}
class DataInitial<T> extends DataState<T> {
  const DataInitial({super.data});
  @override
  String toString() {
    // TODO: implement toString
    return 'initial';
  }
}
class DataSuccess<T> extends DataState<T>{
  const DataSuccess(T data):super(data: data);
  @override
  String toString() {
    // TODO: implement toString
    return 'Data success';
  }
}

class DataFailed<T> extends DataState<T>{
  const DataFailed(String error):super(error: error);
  @override
  String toString() {
    // TODO: implement toString
    return 'Data failed: $error';
  }
}