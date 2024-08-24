// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:careem_app_clean/core/error/failures.dart';
import 'package:careem_app_clean/features/favourite/domain/entities/add_fav_response_entity.dart';
import 'package:careem_app_clean/features/favourite/domain/usecase/add_favourite_usecase.dart';
import 'package:meta/meta.dart';

part 'add_favourite_event.dart';
part 'add_favourite_state.dart';

class AddFavouriteBloc extends Bloc<AddFavouriteEvent, AddFavouriteState> {
  AddFavouriteUsecase addFavouriteUsecase;
  AddFavouriteBloc(
    this.addFavouriteUsecase,
  ) : super(AddFavouriteInitial()) {
    on<AddFav>((event, emit) async {
      emit(AddFavouriteLoding());

      final failureOrEntity = await addFavouriteUsecase.call();

      failureOrEntity.fold((failure) {
        String message = '';
        switch (failure.runtimeType) {
          case ServerFailure:
            message =failure.message ??"not added to the favourite..";
            break;
          default:
            message = "there is no internet ..";
        }
        emit(AddFavouriteFailure(message: message));
      }, (fav) {
        emit(AddFavouriteSuccess(fav: fav));
      });
    });
  }
}
