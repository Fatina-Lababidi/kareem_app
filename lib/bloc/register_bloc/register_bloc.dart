import 'package:bloc/bloc.dart';
import 'package:careem_app/models/request/register_model.dart';
import 'package:careem_app/models/result_handling_model.dart';
import 'package:careem_app/service/mock/register_mock.dart';
import 'package:meta/meta.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterInitial()) {
    on<SignUp>((event, emit) async {
      emit(RegisterLoading());
      ResultModel status = await MockRegisterService().register(event.user);
      switch (status) {
        case SuccessModel():
          emit(RegisterSuccess());//! should i add string message to this ?
        case OfflineModel():
          emit(OfflineRegister(message: status.message));
        case ErrorModel():
          emit(RegisterFailed(message: status.message));
        case ExceptionModel():
          emit(RegisterFailed(message: status.message));
        default:
          emit(RegisterLoading());//! what we have to but here ??
      }
    });
  }
}
