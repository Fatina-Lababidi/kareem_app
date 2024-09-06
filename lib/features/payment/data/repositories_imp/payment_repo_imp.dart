// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:careem_app_clean/core/error/exceptions.dart';
import 'package:careem_app_clean/core/error/failures.dart';
import 'package:careem_app_clean/core/network/network_connection.dart';
import 'package:careem_app_clean/features/payment/data/datasource/remote_payment_datasource.dart';
import 'package:careem_app_clean/features/payment/data/models/payment_model.dart';
import 'package:careem_app_clean/features/payment/domain/entities/payment_entity.dart';
import 'package:careem_app_clean/features/payment/domain/repostitories/payment_repo.dart';
import 'package:dartz/dartz.dart';

class PaymentRepoImp implements PaymentRepo {
  final RemotePaymentDatasource remotePaymentDatasource;
  final NetworkConnection networkConnection;
  PaymentRepoImp({
    required this.remotePaymentDatasource,
    required this.networkConnection,
  });

  @override
  Future<Either<Failures, String>> pay(PaymentRequestEntity payment) async {
    if (await networkConnection.isConnected) {
      try {
        final paymentModel = PaymentRequestModel.fromEntity(payment);
        String message = await remotePaymentDatasource.pay(paymentModel);
        return Right(message);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.errorModel.errorMessage));
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
