part of 'create_wallet_bloc.dart';

@immutable
sealed class CreateWalletState {}

final class CreateWalletInitial extends CreateWalletState {}

class CreateWalletLoding extends CreateWalletState {}

class CreateWalletOffline extends CreateWalletState {}

class CreateWalletFailure extends CreateWalletState {
  final String message;
  CreateWalletFailure({
    required this.message,
  });
}

class CreateWalletSuccess extends CreateWalletState {
  final String message;
  CreateWalletSuccess({
    required this.message,
  });
}
