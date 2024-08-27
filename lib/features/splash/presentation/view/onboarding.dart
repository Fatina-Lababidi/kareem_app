import 'package:careem_app_clean/core/functions/language.dart';
import 'package:careem_app_clean/core/resources/asset.dart';
import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/resources/string.dart';
import 'package:careem_app_clean/features/splash/presentation/view/location_page.dart';
import 'package:careem_app_clean/features/splash/presentation/view/welcom_page.dart';
import 'package:careem_app_clean/features/splash/presentation/widgets/progress_content.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoarding extends StatefulWidget {
  final Dio dio;
  final SharedPreferences sharedPreferences;
  const OnBoarding({
    super.key,
    required this.dio,
    required this.sharedPreferences,
  });

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
    LocalizationKeys.onboardingDescription2A.tr(),
    LocalizationKeys.onboardingDescription3A.tr(),
  ];
  final List descriptionP2 = [
    LocalizationKeys.onboardingDescription1B.tr(),
    LocalizationKeys.onboardingDescription2B.tr(),
    LocalizationKeys.onboardingDescription3B.tr(),
  ];
  final List descriptionP3 = [
    LocalizationKeys.onboardingDescription1C.tr(),
    LocalizationKeys.onboardingDescription2C.tr(),
    LocalizationKeys.onboardingDescription3C.tr(),
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
            child: LocationPage(
              dio: widget.dio,
              sharedPreferences: widget.sharedPreferences,
            ),
            type: PageTransitionType.fade,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    bool isEng = isEnglish(context);
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 2,
              ),
              Align(
                alignment: isEng ? Alignment.topRight : Alignment.topLeft,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        child: WelcomePage(
                          dio: widget.dio,
                          sharedPreferences: widget.sharedPreferences,
                        ),
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
              const Spacer(),
              ProgressContent(
                key: ValueKey<int>(
                  _currentIndex,
                ), //to make the animation repate for each image
                image: images[_currentIndex],
                title: titles[_currentIndex],
                descriptionP1: descriptionP1[_currentIndex],
                descriptionP2: descriptionP2[_currentIndex],
                descriptionP3: descriptionP3[_currentIndex],
              ),
              const Spacer(
                flex: 2,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: screenWidth * 0.25,
                      height: screenWidth * 0.25,
                      child: CircularProgressIndicator(
                        value: _progressValue,
                        strokeWidth: 4,
                        color: AppColor.baseColor,
                        backgroundColor: AppColor.progressBackgoundColor,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: screenWidth * 0.2,
                      height: screenWidth * 0.2,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          backgroundColor: AppColor.baseColor,
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: _updateProgress,
                        child: (_currentIndex < 2)
                            ? const Icon(
                                Icons.arrow_forward,
                                color: AppColor.buttonDetailsColor,
                                size: 24,
                              )
                            : Text(
                                LocalizationKeys.go.tr(),
                                style: const TextStyle(
                                  color: AppColor.buttonDetailsColor,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
