import 'package:bloc/bloc.dart';
import 'package:careem_app_clean/core/error/failures.dart';
import 'package:careem_app_clean/core/resources/string.dart';
import 'package:careem_app_clean/features/wallet/domain/usecase/add_money_usecase.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:meta/meta.dart';

part 'add_money_event.dart';
part 'add_money_state.dart';

class AddMoneyBloc extends Bloc<AddMoneyEvent, AddMoneyState> {
  final AddMoneyUsecase addMoneyUsecase;
  AddMoneyBloc(this.addMoneyUsecase) : super(AddMoneyInitial()) {
    on<AddMoney>((event, emit) async {
      emit(AddMoneyLoading());
      final failureOrEntity = await addMoneyUsecase.call(event.code);

      failureOrEntity.fold((failure) {
        String message = '';
        switch (failure.runtimeType) {
          case ServerFailure:
            message = failure.message ?? 'please try later';
            break;
          default:
            message = LocalizationKeys.thereIsNoInternet.tr();
            break;
        }
        emit(AddMoneyFailure(message: message));
      }, (message) {
        emit(AddMoneySuccess(message: message));
      });
    });
  }
}
