import 'package:bloc/bloc.dart';
import 'package:careem_app/models/response/bicycle_by_category_model.dart';
import 'package:careem_app/models/result_handling_model.dart';
import 'package:careem_app/service/mock/bicycle_by_category_mock.dart';
import 'package:meta/meta.dart';

part 'bicycle_by_category_event.dart';
part 'bicycle_by_category_state.dart';

class BicycleByCategoryBloc
    extends Bloc<BicycleByCategoryEvent, BicycleByCategoryState> {
  BicycleByCategoryBloc() : super(BicycleByCategoryInitial()) {
    on<FetchBicycles>((event, emit) async {
      emit(BicycleLoading());
      final result = await MockBicycleByCategory().getBicyclesByCategory(
          latitude: event.latitude,
          longitude: event.longitude,
          category: event.category);
      if (result is SuccessModel<BicycleResponseModel>) {
        emit(BicycleSuccess(bicycleResponse: result.data));
      } else if (result is ErrorModel) {
        emit(BicycleFailed(message: result.message));
      } else if (result is OfflineModel) {
        emit(BicycleOffline(message: result.message));
      } else if (result is ExceptionModel) {
        emit(BicycleFailed(message: result.message));
      }
    });
  }
}
