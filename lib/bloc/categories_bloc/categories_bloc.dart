import 'package:bloc/bloc.dart';
import 'package:careem_app/models/response/categories_model.dart';
import 'package:careem_app/models/result_handling_model.dart';
import 'package:careem_app/service/mock/categories_mock.dart';
import 'package:meta/meta.dart';

part 'categories_event.dart';
part 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  CategoriesBloc() : super(CategoriesInitial()) {
    on<FetchCategories>((event, emit) async {
      emit(CategoriesLoading());
      ResultModel status =
          await MockBicycleCategorisService().getBycicleCategories();
      switch (status) {
        case SuccessModel():
          emit(CategoriesSuccess(categoriesResponseModel: status.data)); //! should i add string message to this ?
        case OfflineModel():
          emit(CategoriesOffline(message: status.message));
        case ErrorModel():
          emit(CategoriesFailed(message: status.message));
        case ExceptionModel():
          emit(CategoriesFailed(message: status.message));
        default:
          emit(CategoriesLoading()); //! what we have to but here ??
      }
    });
  }
}
