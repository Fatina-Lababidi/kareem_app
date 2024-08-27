import 'package:careem_app_clean/features/wallet/domain/entities/wallet_info_entity.dart';

class WalletInfoModel extends WalletInfoEntity {
  final String status;
  WalletInfoModel({
    required this.status,
    required super.message,
    required super.body,
  });

  factory WalletInfoModel.fromJson(Map<String, dynamic> json) {
    return WalletInfoModel(
        status: json['status'],
        message: json['message'],
        body: WalletDetailsModel.fromJson(json['body']));
  }
}

//2: subclass :
class WalletDetailsModel extends WalletDetailsEntity {
  WalletDetailsModel({
    required super.id,
    required super.balance,
    required super.bankAccount,
  });

  factory WalletDetailsModel.fromJson(Map<String, dynamic> json) {
    return WalletDetailsModel(
      id: json['id'],
      balance: json['balance'],
      bankAccount: json['bankAccount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'balance': balance,
      'bankAccount': bankAccount,
    };
  }
}
