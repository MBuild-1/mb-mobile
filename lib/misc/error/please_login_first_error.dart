class PleaseLoginFirstError extends Error {
  final String message;

  PleaseLoginFirstError({this.message = ""});

  @override
  String toString() {
    return 'PleaseLoginFirstError: $message';
  }
}