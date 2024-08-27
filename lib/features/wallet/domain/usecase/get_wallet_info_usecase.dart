import 'package:careem_app_clean/core/error/failures.dart';
import 'package:careem_app_clean/features/wallet/domain/entities/wallet_info_entity.dart';
import 'package:careem_app_clean/features/wallet/domain/repositories/wallet_repo.dart';
import 'package:dartz/dartz.dart';

class GetWalletInfoUsecase {
  final WalletRepo walletRepo;
  GetWalletInfoUsecase({
    required this.walletRepo,
  });

  Future<Either<Failures, WalletInfoEntity>> call() async {
    return await walletRepo.getMyWalletInfo();
  }
}
