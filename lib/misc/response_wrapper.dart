class ResponseWrapper {
  final dynamic response;

  ResponseWrapper(this.response);
}

class MainStructureResponseWrapper extends ResponseWrapper {
  @override
  dynamic get response => _dataResponse;

  late final dynamic _dataResponse;

  late final String status;
  late final int code;
  late final String message;

  factory MainStructureResponseWrapper.factory(dynamic fullResponse) {
    return MainStructureResponseWrapper(fullResponse);
  }

  MainStructureResponseWrapper(dynamic fullResponse) : super(fullResponse) {
    dynamic meta = fullResponse["meta"];
    status = meta["isSuccess"];
    code = meta["code"];
    message = meta["message"];
    _dataResponse = fullResponse["data"];
  }
}