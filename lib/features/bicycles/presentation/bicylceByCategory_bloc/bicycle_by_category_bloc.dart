import 'package:bloc/bloc.dart';
import 'package:careem_app_clean/core/error/failures.dart';
import 'package:careem_app_clean/features/bicycles/domain/entities/bicycle_by_ctegory_entity.dart';
import 'package:careem_app_clean/features/bicycles/domain/usecase/bicycle_by_category_usecase.dart';
import 'package:meta/meta.dart';

part 'bicycle_by_category_event.dart';
part 'bicycle_by_category_state.dart';

class BicycleByCategoryBloc
    extends Bloc<BicycleByCategoryEvent, BicycleByCategoryState> {
  final BicycleByCategoryUsecase bicycleByCategoryUsecase;
  BicycleByCategoryBloc(this.bicycleByCategoryUsecase)
      : super(BicycleByCategoryInitial()) {
    on<GetBicycleByCategor>((event, emit) async {
      emit(BicycleByCategoryLoding());

      final failureOrEntity = await bicycleByCategoryUsecase.call();
      failureOrEntity.fold((failure) {
        String message = '';
        switch (failure.runtimeType) {
          case ServerFailure():
            message = failure.message ??'Please try again later ..';
            break;
          default:
            message = 'there is no internet';
            break;
        }
        emit(BicycleByCategoryFailure(message: message));
      }, (bicycles) {
        emit(BicycleByCategorySuccess(
            bicycleByCtegoryEntity: bicycles));
      });
    });
  }
}
