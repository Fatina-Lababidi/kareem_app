import 'package:bloc/bloc.dart';
import 'package:careem_app_clean/core/error/failures.dart';
import 'package:careem_app_clean/core/resources/string.dart';
import 'package:careem_app_clean/features/payment/domain/entities/payment_entity.dart';
import 'package:careem_app_clean/features/payment/domain/usecases/payment_usecase.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:meta/meta.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentUsecase paymentUsecase;
  PaymentBloc(this.paymentUsecase) : super(PaymentInitial()) {
    on<PayForYourReservation>((event, emit) async {
      emit(PaymentLoading());
      final failureOrEntity =
          await paymentUsecase.call(event.paymentRequestEntity);

      failureOrEntity.fold((failure) {
        String message = '';
        switch (failure.runtimeType) {
          case ServerFailure:
            message = failure.message ?? 'please try later..';
            break;
          default:
            message = LocalizationKeys.thereIsNoInternet.tr();
            break;
        }
        emit(PaymentFailure(message: message));
      }, (message) {
        emit(PaymentSuccess(message: message));
      });
    });
  }
}
