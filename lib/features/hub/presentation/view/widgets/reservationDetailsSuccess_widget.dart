import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/resources/string.dart';
import 'package:careem_app_clean/core/widgets/app_button.dart';
import 'package:careem_app_clean/features/hub/domain/entities/reservation_details_entity.dart';
import 'package:careem_app_clean/features/hub/presentation/view/pages/reservation_details.dart';
import 'package:careem_app_clean/features/payment/presentation/view/payment_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:page_transition/page_transition.dart';

class ReservationDetailsSuccessWidget extends StatelessWidget {
  const ReservationDetailsSuccessWidget({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.reservation,
    required this.widget,
  });

  final double screenHeight;
  final double screenWidth;
  final ReservationDetailsBodyEntity reservation;
  final ReservationDetails widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: screenHeight * 0.08, //50,
        left: screenWidth * 0.02, //10,
        right: screenWidth * 0.02, //10,
      ),
      child: Container(
        width: screenWidth * 0.85, //300,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColor.categoriesContainerColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColor.buttonColor,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${LocalizationKeys.client.tr()} :${reservation.client}',
                  style: TextStyle(
                    fontSize: screenWidth * 0.045, //16,
                    fontWeight: FontWeight.bold,
                    color: AppColor.buttonDetailsColor,
                  ),
                ),
                Text(
                  '${LocalizationKeys.bike.tr()} : ${reservation.bicycle}',
                  style: TextStyle(
                    fontSize: screenWidth * 0.035, //14,
                    color: AppColor.buttonDetailsColor.withOpacity(0.8),
                  ),
                )
              ],
            ).animate().fadeIn(duration: 0.1.seconds, delay: .2.seconds),
            SizedBox(
              height: screenHeight * 0.01,
            ),
            const Divider()
                .animate()
                .fadeIn(duration: 0.2.seconds, delay: .25.seconds),
            SizedBox(
              height: screenHeight * 0.01,
            ),
            Text(
              '${LocalizationKeys.fromHub.tr()} : ${reservation.from}',
              style: TextStyle(
                  fontSize: screenWidth * 0.035, //14,
                  fontWeight: FontWeight.w500,
                  color: AppColor.snackbarOfflineColor),
            ).animate().fadeIn(duration: 0.3.seconds, delay: .3.seconds),
            Text('${LocalizationKeys.toHub.tr()} : ${reservation.to}',
                    style: TextStyle(
                        fontSize: screenWidth * 0.035, //14,
                        fontWeight: FontWeight.w500,
                        color: AppColor.snackbarOfflineColor))
                .animate()
                .fadeIn(duration: 0.4.seconds, delay: .35.seconds),
            SizedBox(
              height: screenHeight * 0.01,
            ),
            const Divider()
                .animate()
                .fadeIn(duration: 0.5.seconds, delay: .4.seconds),
            SizedBox(
              height: screenHeight * 0.01,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    '${LocalizationKeys.duration.tr()} : ${reservation.duration} hr',
                    style: TextStyle(
                        fontSize: screenWidth * 0.035, //14,
                        fontWeight: FontWeight.w500,
                        color: AppColor.snackbarOfflineColor)),
                Text(
                  '${LocalizationKeys.price.tr()} : \$${reservation.price}',
                  style: TextStyle(
                    fontSize: screenWidth * 0.04, //16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ).animate().fadeIn(duration: 0.6.seconds, delay: .45.seconds),
            SizedBox(
              height: screenHeight * 0.01,
            ),
            const Divider()
                .animate()
                .fadeIn(duration: .7.seconds, delay: .5.seconds),
            // SizedBox(height: screenHeight * 0.04),
            (reservation.reservationStatus == 'PENDING')
                ? Text(LocalizationKeys.payForConfirmation.tr(),
                        style: TextStyle(
                            fontSize: screenWidth * 0.035, //14,
                            fontWeight: FontWeight.w500,
                            color: AppColor.snackbarOfflineColor))
                    .animate()
                    .fadeIn(duration: .75.seconds, delay: .55.seconds)
                : const Text(''),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            Center(
              child: AppButton(
                screenWidth: screenWidth * 0.8,
                screenHeight: screenHeight * 0.8,
                text: reservation.reservationStatus,
                textColor: AppColor.whiteColor,
                containerColor: reservation.reservationStatus == 'PENDING'
                    ? AppColor.snackbarFaildColor
                    : AppColor.buttonColor,
                borderColor: reservation.reservationStatus == 'PENDING'
                    ? AppColor.snackbarFaildColor
                    : AppColor.buttonColor,
                onTap: () {
                  if (reservation.reservationStatus == 'PENDING') {
                    Navigator.push(
                        context,
                        PageTransition(
                            child: PaymentPage(
                                reservationId: reservation.id,
                                bikeModel: reservation.bicycle,
                                photoPath: '', //! this have to be changed
                                sharedPreferences: widget.sharedPreferences,
                                dio: widget.dio),
                            type: PageTransitionType.fade));
                  }
                },
              ),
            ).animate().fadeIn(duration: .8.seconds, delay: .55.seconds),
          ],
        ),
      ),
    );
  }
}
