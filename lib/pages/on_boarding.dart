import 'package:careem_app/core/functions/language.dart';
import 'package:careem_app/core/resources/asset.dart';
import 'package:careem_app/core/resources/color.dart';
import 'package:careem_app/core/resources/string.dart';
import 'package:careem_app/pages/welcom.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:page_transition/page_transition.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  int _currentIndex = 0;
  double _progressValue = 1 / 3;
  final List<String> images = [
    AppImages.onboarding1,
    AppImages.onboarding2,
    AppImages.onboarding3,
  ];
  final List titles = [
    LocalizationKeys.onboardingTitle1.tr(),
    LocalizationKeys.onboardingTitle2.tr(),
    LocalizationKeys.onboardingTitle3.tr(),
  ];
  final List descriptionP1 = [
    LocalizationKeys.onboardingDescription1A.tr(),
    LocalizationKeys.onboardingDescription1A.tr(),
    LocalizationKeys.onboardingDescription1A.tr(),
  ];
  final List descriptionP2 = [
    LocalizationKeys.onboardingDescription1B.tr(),
    LocalizationKeys.onboardingDescription1B.tr(),
    LocalizationKeys.onboardingDescription1B.tr(),
  ];
  final List descriptionP3 = [
    LocalizationKeys.onboardingDescription1C.tr(),
    LocalizationKeys.onboardingDescription1C.tr(),
    LocalizationKeys.onboardingDescription1C.tr(),
  ];
  void _updateProgress() {
    setState(() {
      if (_currentIndex < 2) {
        _currentIndex++;
        _progressValue += 1 / 3;
      } else {
        Navigator.push(
            context,
            PageTransition(
                child: const WelcomePage(), type: PageTransitionType.fade));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    bool isEng = isEnglish(context);
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(
              height: 2,
            ),
            Align(
              alignment:isEng? Alignment.topRight:Alignment.topLeft,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      child: const WelcomePage(),
                      type: PageTransitionType.fade,
                    ),
                  );
                },
                child: Text(
                  LocalizationKeys.skip.tr(),
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
            Spacer(),
            ProgressContent(
              key: ValueKey<int>(
                  _currentIndex), //to make the animation repate for each image
              image: images[_currentIndex],
              title: titles[_currentIndex],
              descriptionP1: descriptionP1[_currentIndex],
              descriptionP2: descriptionP2[_currentIndex],
              descriptionP3: descriptionP3[_currentIndex],
            ),
            Spacer(
              flex: 2,
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 86,
                  height: 86,
                  child: CircularProgressIndicator(
                    value: _progressValue,
                    strokeWidth: 4,
                    color: AppColor.baseColor,
                    backgroundColor: AppColor.progressBackgoundColor,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: AppColor.baseColor,
                      padding: const EdgeInsets.all(32)),
                  onPressed: _updateProgress,
                  child: (_currentIndex < 2)
                      ? Icon(
                          Icons.arrow_forward,
                          color: AppColor.buttonDetailsColor,
                        )
                      : Text(
                          LocalizationKeys.go.tr(),
                          style: TextStyle(
                            color: AppColor.buttonDetailsColor,
                            fontSize: 20,
                          ),
                        ),
                ),
              ],
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}

class ProgressContent extends StatelessWidget {
  final String image;
  final String title;
  final String descriptionP1;
  final String descriptionP2;
  final String descriptionP3;

  const ProgressContent(
      {super.key,
      required this.image,
      required this.title,
      required this.descriptionP1,
      required this.descriptionP2,
      required this.descriptionP3});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          image,
          // width: 500,
          // height: 100,
        ).animate().scaleXY(duration: .4.seconds, delay: .2.seconds),
        SizedBox(
          height: 10,
        ),
        Text(
          title,
          style: TextStyle(
              fontSize: 24, color: Colors.black, fontWeight: FontWeight.w500),
        ).animate().fade(duration: .4.seconds, delay: .25.seconds),
        SizedBox(
          height: 20,
        ),
        Text(descriptionP1,
                style: TextStyle(
                    fontSize: 14,
                    color: AppColor.detailsTextColor,
                    fontWeight: FontWeight.w500))
            .animate()
            .fade(duration: .4.seconds, delay: .3.seconds),
        Text(descriptionP2,
                style: TextStyle(
                    fontSize: 14,
                    color: AppColor.detailsTextColor,
                    fontWeight: FontWeight.w500))
            .animate()
            .fade(duration: .4.seconds, delay: .4.seconds),
        Text(descriptionP3,
                style: TextStyle(
                    fontSize: 14,
                    color: AppColor.detailsTextColor,
                    fontWeight: FontWeight.w500))
            .animate()
            .fade(duration: .4.seconds, delay: .5.seconds),
      ],
    );
  }
}
