import 'package:careem_app_clean/core/resources/asset.dart';
import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/resources/string.dart';
import 'package:careem_app_clean/core/widgets/app_button.dart';
import 'package:careem_app_clean/features/home/presentation/view/home_page.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThanksPage extends StatelessWidget {
  final String message;
  final Dio dio;
  final SharedPreferences sharedPreferences;
  const ThanksPage({
    super.key,
    required this.message,
    required this.dio,
    required this.sharedPreferences,
  });

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double screenWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: SafeArea(
        child: Column(
          children: [
            // Padding(
            //   padding: isEnglish(context)
            //       ? EdgeInsets.only(
            //           left: screenWidth * 0.02, top: screenHeight * 0.01)
            //       : EdgeInsets.only(
            //           right: screenWidth * 0.02, top: screenHeight * 0.01),
            //   child: const BackWidget(),
            // ),
            const Spacer(),
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  AppImages.thinkStart,
                ).animate(
                  onComplete: (controller) {
                    controller.repeat();
                  },
                ).rotate(duration: 3.seconds, delay: 1.seconds),
                Center(
                  child: Icon(Icons.check_rounded,
                      color: AppColor.checkColor, size: screenWidth * 0.2 //80,
                      ),
                ),
              ],
            ),
            SizedBox(
              height: screenHeight * 0.05,
            ),
            Text(
              textAlign: TextAlign.center,
              LocalizationKeys.thankYou.tr(),
              style: TextStyle(
                  color: AppColor.buttonDetailsColor,
                  fontWeight: FontWeight.w500,
                  fontSize: screenWidth * 0.05 //20,
                  ),
            ),
            SizedBox(
              height: screenHeight * 0.01,
            ),
            Text(
              textAlign: TextAlign.center,
              message,

              // LocalizationKeys.yourBookingHasBeenPlacedSent.tr(),
              style: TextStyle(
                  color: AppColor.buttonDetailsColor,
                  fontWeight: FontWeight.w500,
                  fontSize: screenWidth * 0.03 //12,
                  ),
            ),
            Spacer(),
            AppButton(
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              text: 'Back home', //LocalizationKeys.confirmRide.tr(),
              textColor: AppColor.whiteColor,
              containerColor: AppColor.buttonColor,
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        child: HomePage(
                          dio: dio,
                          sharedPreferences: sharedPreferences,
                          currentIndex: 4,
                        ),
                        type: PageTransitionType.fade));
                // Navigator.push(
                //     context,
                //     PageTransition(
                //         child: const PaymentPage(),
                //         type: PageTransitionType.fade));
              },
            ),
            SizedBox(
              height: screenHeight * 0.05,
            )
          ],
        ),
      ),
    );
  }
}
