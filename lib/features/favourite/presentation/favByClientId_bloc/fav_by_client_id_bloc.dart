// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:careem_app_clean/core/error/failures.dart';
import 'package:careem_app_clean/features/favourite/domain/entities/add_fav_response_entity.dart';
import 'package:careem_app_clean/features/favourite/domain/usecase/get_fav_by_clientId.dart';
import 'package:meta/meta.dart';

part 'fav_by_client_id_event.dart';
part 'fav_by_client_id_state.dart';

class FavByClientIdBloc extends Bloc<FavByClientIdEvent, FavByClientIdState> {
  final GetFavByClientidUsecase getFavByClientid;
  FavByClientIdBloc(
    this.getFavByClientid,
  ) : super(FavByClientIdInitial()) {
    on<GetFavByClientid>((event, emit) async {
      emit(FavByClientIdLoading());
      final failureOrEntity = await getFavByClientid.call();
      failureOrEntity.fold((failure) {
        String message;
        if (failure is OfflineFailure) {
          message = 'There is no internet connection.';
        } else if (failure is ServerFailure) {
          message = "Client doesn't have any favourite bikes.";
        } else {
          message = 'Unexpected error occurred.';
        }

        emit(FavByClientIdFailure(message: message));
      }, (entity) {
        emit(FavByClientIdSuccess(addFavResponseEntity: entity));
      });
    });
  }
}
