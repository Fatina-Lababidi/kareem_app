import 'package:bloc/bloc.dart';
import 'package:careem_app_clean/core/error/failures.dart';
import 'package:careem_app_clean/features/authentication/domain/entities/user_entity.dart';
import 'package:careem_app_clean/features/authentication/domain/usecases/register_user.dart';
import 'package:meta/meta.dart';

part 'register_bloc_event.dart';
part 'register_bloc_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUserUseCase registerUser;

  RegisterBloc(this.registerUser) : super(RegisterInitial()) {
    on<RegisterUserEvent>((event, emit) async {
      emit(RegisterLoading());

      final failureOrToken = await registerUser.call(event.user);

      failureOrToken.fold(
        (failure) {
          if (failure is OfflineFailure) {
            emit(RegisterOffline());
          } else {
            emit(RegisterFailure(message: _mapFailureToMessage(failure)));
          }
        },
        (token) => emit(RegisterSuccess(token: token)),
      );
    });
  }

  String _mapFailureToMessage(Failures failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return failure.message ??'Server Failure';
      default:
        return 'Unexpected Error';
    }
  }
}
