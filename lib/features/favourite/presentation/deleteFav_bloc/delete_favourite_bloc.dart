import 'package:bloc/bloc.dart';
import 'package:careem_app_clean/core/error/failures.dart';
import 'package:careem_app_clean/features/favourite/domain/usecase/delete_fav_useCase.dart';
import 'package:meta/meta.dart';

part 'delete_favourite_event.dart';
part 'delete_favourite_state.dart';

class DeleteFavouriteBloc
    extends Bloc<DeleteFavouriteEvent, DeleteFavouriteState> {
  final DeleteFavouriteUsecase deleteFavouriteUsecase;
  DeleteFavouriteBloc(this.deleteFavouriteUsecase)
      : super(DeleteFavouriteInitial()) {
    on<DeleteFavouriteBike>((event, emit) async {
      emit(DeleteFavouriteLoading());

      final failureOrEntity = await deleteFavouriteUsecase.call(event.favId);
      failureOrEntity.fold((failure) {
        String message = '';
        switch (failure.runtimeType) {
          case ServerFailure:
            message = failure.message ?? "please try later..";
            break;
          default:
            message = 'there is no internet';
        }
        emit(DeleteFavouriteFailure(message: message));
      }, (entity) {
        emit(DeleteFavouriteSuccess(message: entity));
      });
    });
  }
}
