import 'package:careem_app_clean/core/error/failures.dart';
import 'package:careem_app_clean/features/payment/domain/entities/payment_entity.dart';
import 'package:dartz/dartz.dart';

abstract class PaymentRepo {
  Future<Either<Failures, String>> pay(PaymentRequestEntity payment);
}
