import 'package:bloc/bloc.dart';
import 'package:careem_app_clean/core/error/failures.dart';
import 'package:careem_app_clean/core/resources/string.dart';
import 'package:careem_app_clean/features/wallet/domain/entities/valid_code_entity.dart';
import 'package:careem_app_clean/features/wallet/domain/usecase/get_valid_code_usecase.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:meta/meta.dart';

part 'valid_code_event.dart';
part 'valid_code_state.dart';

class ValidCodeBloc extends Bloc<ValidCodeEvent, ValidCodeState> {
  final GetValidCodeUsecase getValidCodeUsecase;
  ValidCodeBloc(this.getValidCodeUsecase) : super(ValidCodeInitial()) {
    on<GetValidCode>((event, emit) async {
      emit(ValidCodeLoading());
      final failureOrEntity = await getValidCodeUsecase.call();
      failureOrEntity.fold((failure) {
        String message = '';
        switch (failure.runtimeType) {
          case ServerFailure:
            message = failure.message ?? "please try later..";
            break;
          default:
            message = LocalizationKeys.thereIsNoInternet.tr();
            break;
        }
        emit(ValidCodeFailure(message: message));
      }, (validCode) {
        emit(ValidCodeSuccess(validCodeEntity: validCode));
      });
    });
  }
}
