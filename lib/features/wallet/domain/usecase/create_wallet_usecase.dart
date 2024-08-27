import 'package:careem_app_clean/core/error/failures.dart';
import 'package:careem_app_clean/features/wallet/domain/entities/create_wallet_entity.dart';
import 'package:careem_app_clean/features/wallet/domain/repositories/wallet_repo.dart';
import 'package:dartz/dartz.dart';

class CreateWalletUsecase {
  final WalletRepo walletRepo;

  CreateWalletUsecase({
    required this.walletRepo,
  });

  Future<Either<Failures, String>> call(
      CreateWalletEntity createWalletEntity) async {
    return await walletRepo.createWallet(createWalletEntity);
  }
}
