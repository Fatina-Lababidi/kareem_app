import 'package:careem_app_clean/core/error/failures.dart';
import 'package:careem_app_clean/features/wallet/domain/entities/create_wallet_entity.dart';
import 'package:careem_app_clean/features/wallet/domain/entities/valid_code_entity.dart';
import 'package:careem_app_clean/features/wallet/domain/entities/wallet_info_entity.dart';
import 'package:dartz/dartz.dart';

abstract class WalletRepo {
  Future<Either<Failures, WalletInfoEntity>> getMyWalletInfo();
  Future<Either<Failures, String>> createWallet(CreateWalletEntity wallet);
  Future<Either<Failures, ValidCodeEntity>> getValidCode();
}
