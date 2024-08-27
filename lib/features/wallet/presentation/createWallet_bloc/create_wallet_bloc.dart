import 'package:bloc/bloc.dart';
import 'package:careem_app_clean/core/error/failures.dart';
import 'package:careem_app_clean/features/wallet/domain/entities/create_wallet_entity.dart';
import 'package:careem_app_clean/features/wallet/domain/usecase/create_wallet_usecase.dart';
import 'package:meta/meta.dart';

part 'create_wallet_event.dart';
part 'create_wallet_state.dart';

class CreateWalletBloc extends Bloc<CreateWalletEvent, CreateWalletState> {
  final CreateWalletUsecase createWalletUsecase;
  CreateWalletBloc(this.createWalletUsecase) : super(CreateWalletInitial()) {
    on<CreateNewWallet>((event, emit) async {
      emit(CreateWalletLoding());
      final failureOrEntity = await createWalletUsecase.call(event.wallet);
      failureOrEntity.fold((failure) {
        String message = '';
        switch (failure.runtimeType) {
          case ServerFailure:
            message = failure.message ?? "please try later ..";
            break;
          default:
            message = 'there is no internet ..';
            break;
        }
        emit(CreateWalletFailure(message: message));
      }, (walletMessage) {
        emit(CreateWalletSuccess(message: walletMessage));
      });
    });
  }
}
