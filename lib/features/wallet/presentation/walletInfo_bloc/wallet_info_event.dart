part of 'wallet_info_bloc.dart';

@immutable
sealed class WalletInfoEvent {}

class GetWalletInfo extends WalletInfoEvent{}