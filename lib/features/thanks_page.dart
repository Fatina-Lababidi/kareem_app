import 'package:careem_app_clean/core/resources/asset.dart';
import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/resources/string.dart';
import 'package:careem_app_clean/core/widgets/app_button.dart';
import 'package:careem_app_clean/core/widgets/back_row_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ThanksPage extends StatelessWidget {
  const ThanksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double screenWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: screenWidth * 0.02, top: screenHeight * 0.01),
              child: const BackWidget(),
            ),
            Spacer(),
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
                const Center(
                  child: Icon(
                    Icons.check_rounded,
                    color: AppColor.checkColor,
                    size: 80,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: screenHeight * 0.05,
            ),
            Text(
              LocalizationKeys.thankYou.tr(),
              style: const TextStyle(
                color: AppColor.buttonDetailsColor,
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: screenHeight * 0.01,
            ),
            Text(
              LocalizationKeys.yourBookingHasBeenPlacedSent.tr(),
              style: const TextStyle(
                color: AppColor.buttonDetailsColor,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
            Spacer(),
            AppButton(
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              text: LocalizationKeys.confirmRide.tr(),
              textColor: AppColor.whiteColor,
              containerColor: AppColor.buttonColor,
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
