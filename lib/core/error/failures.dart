// ignore_for_file: public_member_api_docs, sort_constructors_first
abstract class Failures {
  final String? message;
  Failures({
    this.message,
  });
}

class ServerFailure extends Failures {
  ServerFailure({super.message});
}

class OfflineFailure extends Failures {
  OfflineFailure({super.message});
}

class EmptyCacheFailure extends Failures {
  EmptyCacheFailure({super.message});
}
