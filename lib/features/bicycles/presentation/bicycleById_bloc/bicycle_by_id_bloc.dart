import 'package:bloc/bloc.dart';
import 'package:careem_app_clean/core/error/failures.dart';
import 'package:careem_app_clean/features/bicycles/domain/entities/bicycle_by_id.dart';
import 'package:careem_app_clean/features/bicycles/domain/usecase/bicycle_by_id_usecase.dart';
import 'package:meta/meta.dart';

part 'bicycle_by_id_event.dart';
part 'bicycle_by_id_state.dart';

class BicycleByIdBloc extends Bloc<BicycleByIdEvent, BicycleByIdState> {
  final BicycleByIdUsecase bicycleByIdUsecase;
  BicycleByIdBloc(this.bicycleByIdUsecase) : super(BicycleByIdInitial()) {
    on<GetBicycleById>((event, emit) async {
      emit(BicycleByIdLoding());
      final failureOrEntity = await bicycleByIdUsecase.call();
      failureOrEntity.fold((failure) {
        String message = '';
        switch (failure.runtimeType) {
          case ServerFailure:
            message = failure.message ?? 'Please try again later ..';
            break;
          default:
            message = 'there is no internet';
            break;
        }
        emit(BicycleByIdFailure(message: message));
      }, (entity) {
        emit(BicycleByIdSuccess(bicycleByIdEntity: entity));
      });
    });
  }
}
