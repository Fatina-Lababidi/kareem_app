// ignore_for_file: public_member_api_docs, sort_constructors_first
//? request data:
//{
//   "walletPassword": "string",
//   "reservationID": 4
// }
//? :
//! i have to make a shared preferacnces , if he make a wallet it going to be true, else so its false
// and in the payment page , if the value of this shared false so we tell him to create wallet if its true , so we  appears the payment page and he can enter the password

//? status code 400:
// {
//   "message": "YOU DON'T HAVE WALLET, PLEASE CREATE WALLET FIRST",
//   "status": "BAD_REQUEST",
//   "localDateTime": "2024-09-05T08:27:15.8995476"
// }
//? ++
// Not enough wallet, please charge your wallet first then try again

//? status code 200:
// {
//   "message": "Your reservation has been confirmed successfully",
//   "status": "ACCEPTED",
//   "localDateTime": "2024-09-05T19:17:57.2364683",
//   "body": {
//     "id": 4,
//     "client": "sana",
//     "bicycle": "PUE229",
//     "from": "وزارة التربية",
//     "to": "جامع صلاح الدين",
//     "duration": 1,
//     "startTime": "2024-09-04T04:29:15.319",
//     "endTime": null,
//     "reservationStatus": "NOT_STARTED",
//     "price": 900
//   }
// }


class PaymentRequestEntity {
  final String walletPassword;
  final int reservationID;
  PaymentRequestEntity({
    required this.walletPassword,
    required this.reservationID,
  });
}


