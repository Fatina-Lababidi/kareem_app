import 'package:careem_app/core/resources/asset.dart';
import 'package:careem_app/core/resources/color.dart';
import 'package:careem_app/core/resources/string.dart';
import 'package:careem_app/pages/sign_up_page.dart';
import 'package:careem_app/widgets/app_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:page_transition/page_transition.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double screenWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
       backgroundColor: AppColor.whiteColor,
      body: Center(
          child: Column(
        children: [
          SizedBox(
            height: screenHeight * 0.05, //20,
          ),
          Image.asset(
            AppImages.welcome,
          ).animate().fade(duration: 0.2.seconds, delay: .1.seconds),
          SizedBox(
            height: screenHeight * 0.05, //20,
          ),
          Text(
            LocalizationKeys.welcome.tr(),
            style: TextStyle(fontSize: screenWidth * 0.06 //24,
                ),
          ).animate().fade(duration: .3.seconds, delay: .2.seconds),
          SizedBox(
            height: screenHeight * 0.02,
          ),
          Text(
            LocalizationKeys.betterSharingExperience.tr(),
            style: TextStyle(
                fontSize: screenWidth * 0.04, //16,
                color: AppColor.detailsTextColor),
          ).animate().fade(duration: .4.seconds, delay: .3.seconds),
          const Spacer(),
          AppButton(
            onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                      child:  SignUpPage(),
                      type: PageTransitionType.fade));
            }, //navigate to sign up page
            text: LocalizationKeys.createAccount.tr(),
            containerColor: AppColor.buttonColor,
            textColor: AppColor.whiteColor,
            screenWidth: screenWidth,
            screenHeight: screenHeight,
          ).animate().fade(duration: .5.seconds, delay: .4.seconds),
          SizedBox(
            height: screenHeight * 0.03,
          ),
          AppButton(
                  onTap: () {}, //log in  ,
                  text: LocalizationKeys.logIn.tr(),
                  containerColor: AppColor.whiteColor,
                  textColor: AppColor.buttonColor,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight)
              .animate()
              .fade(duration: .6.seconds, delay: .5.seconds),
          SizedBox(
            height: screenHeight * 0.075, // 30,
          )
        ],
      )),
    );
  }
}
