class BaseExceptions implements Exception {
  String message;

  BaseExceptions(this.message);

  @override
  String toString() => message;
}
