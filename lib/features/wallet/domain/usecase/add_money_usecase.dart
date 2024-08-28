// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:careem_app_clean/core/error/failures.dart';
import 'package:careem_app_clean/features/wallet/domain/repositories/wallet_repo.dart';
import 'package:dartz/dartz.dart';

class AddMoneyUsecase {
  final WalletRepo walletRepo;
  AddMoneyUsecase({
    required this.walletRepo,
  });

  Future<Either<Failures, String>> call(String code) async {
    return await walletRepo.addMoney(code);
  }
}
