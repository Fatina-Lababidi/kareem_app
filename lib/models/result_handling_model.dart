// ignore_for_file: public_member_api_docs, sort_constructors_first
abstract class ResultModel {}

class SuccessModel<T> extends ResultModel {
  final T data;
 // final String message;
  SuccessModel({
    required this.data,
   // required this.message,
  });
}

class ErrorModel extends ResultModel {
  final String message;
  ErrorModel({
    required this.message,
  });
}

class ExceptionModel extends ResultModel {
  final String message;
  ExceptionModel({
    required this.message,
  });
}

//! is this true?
class OfflineModel extends ResultModel {
  final String message;
  OfflineModel({
    required this.message,
  });
}

class ListOf<T> extends ResultModel {
  final List<T> result;
  ListOf({
    required this.result,
  });
}
