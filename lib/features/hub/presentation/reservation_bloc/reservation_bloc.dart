// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:careem_app_clean/core/error/failures.dart';
import 'package:careem_app_clean/features/hub/domain/entities/reservation_entity.dart';
import 'package:careem_app_clean/features/hub/domain/usecase/reservation_usecase.dart';
import 'package:meta/meta.dart';

part 'reservation_event.dart';
part 'reservation_state.dart';

class ReservationBloc extends Bloc<ReservationEvent, ReservationState> {
  final ReservationUsecase reservationUsecase;
  ReservationBloc(
    this.reservationUsecase,
  ) : super(ReservationInitial()) {
    on<MakeReservation>((event, emit) async {
      emit(ReservationLoading());
      final failureOrEntity =
          await reservationUsecase.call(event.requestEntity);
      failureOrEntity.fold((failure) {
        String message = '';
        switch (failure.runtimeType) {
          case ServerFailure:
            message = failure.message ?? 'please try later ..';
            break;
          default:
            message = 'there is no internet ..';
            break;
        }
        emit(ReservationFailure(message: message));
      }, (entity) {
        emit(ReservationSuccess(reservationResponseEntity: entity));
      });
    });
  }
}
