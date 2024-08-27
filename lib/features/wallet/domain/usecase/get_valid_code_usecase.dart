// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:careem_app_clean/core/error/failures.dart';
import 'package:careem_app_clean/features/wallet/domain/entities/valid_code_entity.dart';
import 'package:careem_app_clean/features/wallet/domain/repositories/wallet_repo.dart';
import 'package:dartz/dartz.dart';

class GetValidCodeUsecase {
  final WalletRepo walletRepo;
  GetValidCodeUsecase({
    required this.walletRepo,
  });
  Future<Either<Failures, ValidCodeEntity>> call() async {
    return await walletRepo.getValidCode();
  }
}
