import 'package:careem_app_clean/features/payment/domain/entities/payment_entity.dart';

class PaymentRequestModel extends PaymentRequestEntity {
  PaymentRequestModel({
    required super.walletPassword,
    required super.reservationID,
  });

  Map<String, dynamic> toJson() {
    return {
      'walletPassword': walletPassword,
      'reservationID': reservationID,
    };
  }

  factory PaymentRequestModel.fromEntity(PaymentRequestEntity payment) {
    return PaymentRequestModel(
        walletPassword: payment.walletPassword,
        reservationID: payment.reservationID);
  }
}
