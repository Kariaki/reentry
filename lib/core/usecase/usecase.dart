abstract class UseCase<Type,Params>{

  Future<Type> call(Params params);
  Stream<Type> stream(Params params)async*{

  }
}

