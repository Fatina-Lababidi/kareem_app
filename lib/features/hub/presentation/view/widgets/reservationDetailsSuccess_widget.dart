import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/resources/string.dart';
import 'package:careem_app_clean/core/widgets/app_button.dart';
import 'package:careem_app_clean/features/hub/domain/entities/reservation_details_entity.dart';
import 'package:careem_app_clean/features/hub/presentation/view/pages/reservation_details.dart';
import 'package:careem_app_clean/features/payment/presentation/view/payment_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Clinet :${reservation.client}',
                  style: TextStyle(
                    fontSize:
                        screenWidth * 0.045, //16,
                    fontWeight: FontWeight.bold,
                    color:
                        AppColor.buttonDetailsColor,
                  ),
                ),
                Text(
                  'Bike : ${reservation.bicycle}',
                  style: TextStyle(
                    fontSize:
                        screenWidth * 0.035, //14,
                    color: AppColor.buttonDetailsColor
                        .withOpacity(0.8),
                  ),
                )
              ],
            ),
            SizedBox(
              height: screenHeight * 0.01,
            ),
            const Divider(),
            SizedBox(
              height: screenHeight * 0.01,
            ),
            Text(
              'Form hub : ${reservation.from}',
              style: TextStyle(
                  fontSize: screenWidth * 0.035, //14,
                  fontWeight: FontWeight.w500,
                  color:
                      AppColor.snackbarOfflineColor),
            ),
            Text('To hub : ${reservation.to}',
                style: TextStyle(
                    fontSize:
                        screenWidth * 0.035, //14,
                    fontWeight: FontWeight.w500,
                    color: AppColor
                        .snackbarOfflineColor)),
            SizedBox(
              height: screenHeight * 0.01,
            ),
            const Divider(),
            SizedBox(
              height: screenHeight * 0.01,
            ),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    'Duration: ${reservation.duration} hr',
                    style: TextStyle(
                        fontSize:
                            screenWidth * 0.035, //14,
                        fontWeight: FontWeight.w500,
                        color: AppColor
                            .snackbarOfflineColor)),
                Text(
                  'Price: \$${reservation.price}',
                  style: TextStyle(
                    fontSize:
                        screenWidth * 0.04, //16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: screenHeight * 0.01,
            ),
            const Divider(),
            // SizedBox(height: screenHeight * 0.04),
            (reservation.reservationStatus ==
                    'PENDING')
                ? Text(
                    LocalizationKeys
                        .payForConfirmation
                        .tr(),
                    style: TextStyle(
                        fontSize:
                            screenWidth * 0.035, //14,
                        fontWeight: FontWeight.w500,
                        color: AppColor
                            .snackbarOfflineColor))
                : const Text(''),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            Center(
              child: AppButton(
                screenWidth: screenWidth * 0.8,
                screenHeight: screenHeight*0.8,
                text: reservation.reservationStatus,
                textColor: AppColor.whiteColor,
                containerColor:
                    reservation.reservationStatus ==
                            'PENDING'
                        ? AppColor.snackbarFaildColor
                        : AppColor.buttonColor,
                borderColor:
                    reservation.reservationStatus ==
                            'PENDING'
                        ? AppColor.snackbarFaildColor
                        : AppColor.buttonColor,
                onTap: () {
                  if (reservation.reservationStatus ==
                      'PENDING') {
                    Navigator.push(
                        context,
                        PageTransition(
                            child: PaymentPage(
                                reservationId:
                                    reservation.id,
                                bikeModel: reservation
                                    .bicycle,
                                photoPath:
                                    '', //! this have to be changed
                                sharedPreferences: widget
                                    .sharedPreferences,
                                dio: widget.dio),
                            type: PageTransitionType
                                .fade));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
