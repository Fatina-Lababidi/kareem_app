import 'package:careem_app_clean/features/wallet/domain/entities/create_wallet_entity.dart';

class CreateWalletModel extends CreateWalletEntity {
  CreateWalletModel({
    required super.securityCode,
    required super.confirmSecurityCode,
    required super.bankAccount,
  });

  factory CreateWalletModel.fromJson(Map<String, dynamic> json) {
    return CreateWalletModel(
        securityCode: json['securityCode'],
        confirmSecurityCode: json['confirmSecurityCode'],
        bankAccount: json['bankAccount']);
  }

  Map<String, dynamic> toJson() {
    return {
      'securityCode': securityCode,
      'confirmSecurityCode': confirmSecurityCode,
      'bankAccount': bankAccount,
    };
  }

  factory CreateWalletModel.fromEntity(CreateWalletEntity wallet) {
    return CreateWalletModel(
        securityCode: wallet.securityCode,
        confirmSecurityCode: wallet.confirmSecurityCode,
        bankAccount: wallet.bankAccount);
  }
}
