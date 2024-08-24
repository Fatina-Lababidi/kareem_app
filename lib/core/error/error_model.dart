class ErrorModel {
  final String status;//!: make it string !
  final String errorMessage;
  ErrorModel({
    required this.status,
    required this.errorMessage,
  });

  factory ErrorModel.fromJson(Map jsonData) {
    return ErrorModel(
      status: jsonData['status'],
      errorMessage: jsonData['message'],
    );
  }
}
