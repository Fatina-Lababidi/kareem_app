// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:careem_app_clean/core/error/failures.dart';
import 'package:careem_app_clean/features/authentication/domain/usecases/login_usecase.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUserUseCase loginUser;
  LoginBloc(
    this.loginUser,
  ) : super(LoginInitial()) {
    on<LoginUserEvent>((event, emit) async {
      emit(LoginLoading());

      final failureOrToken = await loginUser.call(event.phone, event.password);

      failureOrToken.fold(
        (failure) {
          if (failure is OfflineFailure) {
            emit(LoginOffline());
          } else {
            emit(LoginFailure(message: _mapFailureToMessage(failure)));
          }
        },
        (token) => emit(LoginSuccess(token: token)),
      );
    });
  }
}

String _mapFailureToMessage(Failures failure) {
  switch (failure.runtimeType) {
    case ServerFailure:
      return failure.message??'Server Failure';
    default:
      return 'Unexpected Error';
  }
}
