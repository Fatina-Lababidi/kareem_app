import 'package:bloc/bloc.dart';
import 'package:careem_app_clean/core/error/failures.dart';
import 'package:careem_app_clean/core/resources/string.dart';
import 'package:careem_app_clean/features/bicycles/domain/entities/categories_entity.dart';
import 'package:careem_app_clean/features/bicycles/domain/usecase/categories_usecase.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:meta/meta.dart';

part 'categories_event.dart';
part 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final GetCategoriesUsecase getCategoriesUsecase;
  CategoriesBloc(
    this.getCategoriesUsecase,
  ) : super(CategoriesInitial()) {
    on<GetCategories>((event, emit) async {
      emit(CategoriesLoding());

      final failureOrEntity = await getCategoriesUsecase.call();

      failureOrEntity.fold((failure) {
        String message = '';
        switch (failure.runtimeType) {
          case ServerFailure:
            message = failure.message ??"'Please try again later ..'";
            break;
          default:
            message = LocalizationKeys.thereIsNoInternet.tr();
            break;
        }
        emit(CategoriesFailure(message: message));
      }, (categories) {
        emit(CategoriesSuccess(categories: categories));
      });
    });
  }
}
