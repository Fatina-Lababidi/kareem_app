// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:careem_app_clean/core/error/failures.dart';
import 'package:careem_app_clean/features/payment/domain/entities/payment_entity.dart';
import 'package:careem_app_clean/features/payment/domain/repostitories/payment_repo.dart';
import 'package:dartz/dartz.dart';

class PaymentUsecase {
  final PaymentRepo paymentRepo;
  PaymentUsecase({
    required this.paymentRepo,
  });
  Future<Either<Failures, String>> call(PaymentRequestEntity payment) async {
   return await paymentRepo.pay(payment);
  }
}

