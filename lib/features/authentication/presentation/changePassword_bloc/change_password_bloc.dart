import 'package:bloc/bloc.dart';
import 'package:careem_app_clean/core/error/failures.dart';
import 'package:careem_app_clean/features/authentication/domain/usecases/change_password.dart';
import 'package:meta/meta.dart';

part 'change_password_event.dart';
part 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final ChangePasswordUseCase changePasswordUseCase;
  ChangePasswordBloc(this.changePasswordUseCase)
      : super(ChangePasswordInitial()) {
    on<ChangeUserPasswordEvent>((event, emit) async {
      emit(ChangePasswordLoading());

      final failureOrToken = await changePasswordUseCase.call(
          event.currentPassword, event.newPassword, event.confirmPassword);

      failureOrToken.fold(
        (failure) {
          if (failure is OfflineFailure) {
            emit(ChangePasswordOffline());
          } else {
            emit(ChangePasswordFailure(message: _mapFailureToMessage(failure)));
          }
        },
        (message) => emit(ChangePasswordSuccess(message: message)),
      );
    });
  }
}

String _mapFailureToMessage(Failures failure) {
  switch (failure.runtimeType) {
    case ServerFailure:
      return 'Server Failure';
    default:
      return 'Unexpected Error';
  }
}
