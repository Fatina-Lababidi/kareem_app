// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'create_wallet_bloc.dart';

@immutable
sealed class CreateWalletEvent {}

class CreateNewWallet extends CreateWalletEvent {
  final CreateWalletEntity wallet;
  CreateNewWallet({
    required this.wallet,
  });
}
