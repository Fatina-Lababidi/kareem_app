import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/resources/string.dart';
import 'package:careem_app_clean/features/hub/presentation/view/rent_hub_page.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingButtonsRow extends StatelessWidget {
  final String photoPath;
  final String bikeModel;
  final int hubId;
  final String hubName;
  final String hubDescription;
  final int bikeId;
  final Dio dio;
  final SharedPreferences sharedPreferences;

  const BookingButtonsRow(
      {super.key,
      required this.photoPath,
      required this.bikeModel,
      required this.hubId,
      required this.hubName,
      required this.hubDescription,
      required this.bikeId,
      required this.dio,
      required this.sharedPreferences});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double screenWidth = MediaQuery.sizeOf(context).width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            // Navigator.push(
            //     context,
            //     PageTransition(
            //         child:const ThanksPage(message: 'your booking has been placed sent',), type: PageTransitionType.fade));
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
                style: TextStyle(
                  fontSize: screenWidth * 0.04, //16,
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
            try {
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
                  type: PageTransitionType.fade,
                ),
              );
            } catch (e) {
              print('Error during PageTransition: $e');
            }
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
                style: TextStyle(
                  fontSize: screenWidth * 0.04, //16,
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
