class HttpExceptionError implements Exception {
  final String errorMessage;

  HttpExceptionError({
    required this.errorMessage,
  });

  @override
  String toString() {
     return errorMessage;
    //return super.toString();
  }
}
