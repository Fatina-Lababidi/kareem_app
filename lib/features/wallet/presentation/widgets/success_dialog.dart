import 'package:careem_app_clean/core/resources/asset.dart';
import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/widgets/app_button.dart';
import 'package:careem_app_clean/features/home/presentation/view/home_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SuccessDialogAddMoney extends StatelessWidget {
  const SuccessDialogAddMoney({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.finalAmount,
    required this.dio,
    required this.sharedPreferences,
  });

  final double screenWidth;
  final double screenHeight;
  final num finalAmount;
  final Dio dio;
  final SharedPreferences sharedPreferences;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenWidth * 0.533,
      height: screenHeight * 0.5, // 0.369,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.close_rounded,
                  color: AppColor.buttonDetailsColor,
                )),
          ),
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
                child: Icon(
                  Icons.check_rounded,
                  color: AppColor.checkColor,
                  size: screenWidth * 0.213,
                ),
              ),
            ],
          ),
          Text(
            textAlign: TextAlign.center,
            'Add Success',
            style: TextStyle(
                color: AppColor.buttonDetailsColor,
                fontSize: screenWidth * 0.058, // 22,
                fontWeight: FontWeight.w500),
          ),
          Text(
            textAlign: TextAlign.center,
            'your money has been add successfully',
            style: TextStyle(
                color: AppColor.addTextColor,
                fontSize: screenWidth * 0.032, //12,
                fontWeight: FontWeight.w500),
          ),
          Text(
            textAlign: TextAlign.center,
            '$finalAmount',
            style: TextStyle(
                color: AppColor.buttonDetailsColor,
                fontSize: screenWidth * 0.032, //12,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: screenHeight * 0.01,
          ),
          AppButton(
            onTap: () {
              //?navigate to home? or to the wallet info??
              //we need to make it turn to the home age in the index of wallet(2):
              // Navigator.push(
              //   context,
              //   PageTransition(
              //       child: WalletInfoPage(
              //         dio: widget.dio,
              //       ),
              //       type: PageTransitionType
              //           .fade),
              // );
              Navigator.push(
                  context,
                  PageTransition(
                      child: HomePage(
                        dio: dio,
                        sharedPreferences: sharedPreferences,
                        currentIndex: 2,
                      ),
                      type: PageTransitionType.fade));
            },
            screenWidth: screenWidth / 1.2,
            screenHeight: screenHeight / 1.5,
            text: 'Back Home',
            textColor: AppColor.whiteColor,
            containerColor: AppColor.buttonColor,
          ),
          SizedBox(
            height: screenHeight * 0.01,
          )
        ],
      ),
    );
  }
}
