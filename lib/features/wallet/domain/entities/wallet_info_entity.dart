// ignore_for_file: public_member_api_docs, sort_constructors_first
class WalletInfoEntity {
  final String message;
  final WalletDetailsEntity body;
  WalletInfoEntity({
    required this.message,
    required this.body,
  });
}

class WalletDetailsEntity {
  final int id;
  final double balance;
  final String bankAccount;
  WalletDetailsEntity({
    required this.id,
    required this.balance,
    required this.bankAccount,
  });
}
