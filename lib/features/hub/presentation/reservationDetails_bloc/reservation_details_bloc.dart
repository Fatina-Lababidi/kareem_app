import 'package:bloc/bloc.dart';
import 'package:careem_app_clean/core/error/failures.dart';
import 'package:careem_app_clean/core/resources/string.dart';
import 'package:careem_app_clean/features/hub/domain/entities/reservation_details_entity.dart';
import 'package:careem_app_clean/features/hub/domain/usecase/reservation_details_usecase.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:meta/meta.dart';

part 'reservation_details_event.dart';
part 'reservation_details_state.dart';

class ReservationDetailsBloc
    extends Bloc<ReservationDetailsEvent, ReservationDetailsState> {
  final ReservationDetailsUsecase reservationDetailsUsecase;
  ReservationDetailsBloc(this.reservationDetailsUsecase)
      : super(ReservationDetailsInitial()) {
    on<GetReservationDetails>((event, emit) async {
      emit(ReservationDetailsLoading());
      final failureOrEntity =
          await reservationDetailsUsecase.call(event.clientId);
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
        emit(ReservationDetailsFailure(message: message));
      }, (entity) {
        emit(ReservationDetailsSuccess(
            reservationDetailsResponseEntity: entity));
      });
    });
  }
}
