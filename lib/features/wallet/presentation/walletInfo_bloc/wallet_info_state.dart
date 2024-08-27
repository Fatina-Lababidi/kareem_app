part of 'wallet_info_bloc.dart';

@immutable
sealed class WalletInfoState {}

final class WalletInfoInitial extends WalletInfoState {}

class WalletInfoLoding extends WalletInfoState {}

class WalletInfoOffline extends WalletInfoState {}

class WalletInfoFailure extends WalletInfoState {
  final String message;
  WalletInfoFailure({
    required this.message,
  });
}

class WalletInfoSuccess extends WalletInfoState {
  final WalletInfoEntity walletInfoEntity;
  WalletInfoSuccess({
    required this.walletInfoEntity,
  });
}
