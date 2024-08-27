import 'package:bloc/bloc.dart';
import 'package:careem_app_clean/core/error/failures.dart';
import 'package:careem_app_clean/features/wallet/domain/entities/wallet_info_entity.dart';
import 'package:careem_app_clean/features/wallet/domain/usecase/get_wallet_info_usecase.dart';
import 'package:meta/meta.dart';

part 'wallet_info_event.dart';
part 'wallet_info_state.dart';

class WalletInfoBloc extends Bloc<WalletInfoEvent, WalletInfoState> {
  final GetWalletInfoUsecase getWalletInfoUsecase;
  WalletInfoBloc(this.getWalletInfoUsecase) : super(WalletInfoInitial()) {
    on<GetWalletInfo>((event, emit) async {
      emit(WalletInfoLoding());
      final failureOrEntity = await getWalletInfoUsecase.call();
      failureOrEntity.fold((failure) {
        String message;
        switch (failure.runtimeType) {
          case ServerFailure:
            message = failure.message ?? "please try later ..";
            break;
          default:
            message = 'there is no internet';
            break;
        }
        emit(WalletInfoFailure(message: message));
      }, (entity) {
        emit(WalletInfoSuccess(walletInfoEntity: entity));
      });
    });
  }
}
