import 'package:bloc/bloc.dart';
import 'package:careem_app_clean/core/error/failures.dart';
import 'package:careem_app_clean/core/resources/string.dart';
import 'package:careem_app_clean/features/hub/domain/entities/hub_content_entity.dart';
import 'package:careem_app_clean/features/hub/domain/usecase/hub_content_usecase.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:meta/meta.dart';

part 'hub_content_event.dart';
part 'hub_content_state.dart';

class HubContentBloc extends Bloc<HubContentEvent, HubContentState> {
  final HubContentUsecase hubContentUsecase;
  HubContentBloc(this.hubContentUsecase) : super(HubContentInitial()) {
    on<GetHubContent>((event, emit) async {
      emit(HubContentLoding());
      final failureOrEntity = await hubContentUsecase.call();
      failureOrEntity.fold((failure) {
        String message = '';
        switch (failure.runtimeType) {
          case ServerFailure:
            message = failure.message ?? 'please try later ..';
            break;
          default:
            message = LocalizationKeys.thereIsNoInternet.tr();
            break;
        }
        emit(HubContentFailure(message: message));
      }, (entity) {
        emit(HubContentSuccess(hubContentResponseEntity: entity));
      });
    });
  }
}
