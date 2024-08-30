import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/resources/string.dart';
import 'package:careem_app_clean/features/hub/presentation/view/rent_hub_page.dart';
import 'package:careem_app_clean/features/thanks_page.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingButtonsRow extends StatelessWidget {
  const BookingButtonsRow({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.sharedPreferences,
    required this.dio,
    required this.hubId,
    required this.hubName,
    required this.hubDescription,
    required this.bikeId,
    required this.photoPath,
    required this.bikeModel,
  });

  final double screenHeight;
  final double screenWidth;
  final SharedPreferences sharedPreferences;
  final Dio dio;
  final int hubId;
  final String hubName;
  final String hubDescription;
  final int bikeId;
  final String photoPath;
  final String bikeModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
                context,
                PageTransition(
                    child: ThanksPage(
                      screenHeight: screenHeight,
                      screenWidth: screenWidth,
                    ),
                    type: PageTransitionType.fade));
          },
          child: Container(
            height: screenHeight * 0.07, //50,
            width: screenWidth * 0.4, //170,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColor.buttonColor,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                LocalizationKeys.bookLater.tr(),
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColor.buttonColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: screenWidth * 0.03,
        ),
        InkWell(
          onTap: () {
            Navigator.push(
                context,
                PageTransition(
                    child: RentPage(
                      photoPath: photoPath,
                      bikeModel: bikeModel,
                      hubId: hubId,
                      hubName: hubName,
                      hubDescription: hubDescription,
                      bikeId: bikeId,
                      sharedPreferences: sharedPreferences,
                      dio: dio,
                    ),
                    type: PageTransitionType.fade));
          },
          child: Container(
            height: screenHeight * 0.07, //50,
            width: screenWidth * 0.4, //170,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColor.buttonColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                LocalizationKeys.rideNow.tr(),
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColor.whiteColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
