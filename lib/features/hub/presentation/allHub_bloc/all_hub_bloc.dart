// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:careem_app_clean/core/error/failures.dart';
import 'package:careem_app_clean/core/resources/string.dart';
import 'package:careem_app_clean/features/hub/domain/entities/all_hub_entity.dart';
import 'package:careem_app_clean/features/hub/domain/usecase/all_hub_usecase.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:meta/meta.dart';

part 'all_hub_event.dart';
part 'all_hub_state.dart';

class AllHubBloc extends Bloc<AllHubEvent, AllHubState> {
  final AllHubUsecase allHubUsecase;
  AllHubBloc(
    this.allHubUsecase,
  ) : super(AllHubInitial()) {
    on<GetAllHub>((event, emit) async {
      emit(AllHubLoding());
      final failureOrEntity = await allHubUsecase.call();

      failureOrEntity.fold((failure) {
        String message = '';
        switch (failure.runtimeType) {
          case ServerFailure:
            message = failure.message ?? 'server failure';
            break;
          default:
            message = LocalizationKeys.thereIsNoInternet.tr();
            break;
        }
        emit(AllHubFailure(message: message));
      }, (hub) {
        emit(AllHubSuccess(allHubEntity: hub));
      });
    });
  }
}
