import 'package:careem_app_clean/core/resources/asset.dart';
import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/resources/string.dart';
import 'package:careem_app_clean/core/widgets/appBar_widget.dart';
import 'package:careem_app_clean/core/widgets/app_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeLanguage extends StatefulWidget {
  final SharedPreferences sharedPreferences;
  final ValueNotifier<bool> languageChangedNotifier;
  const ChangeLanguage({
    super.key,
    required this.sharedPreferences,
    required this.languageChangedNotifier,
  });

  @override
  State<ChangeLanguage> createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguage> {
  int selectedContainerIndex = 1;
  int? tempSelectedIndex;
  final Color selectedColor = AppColor.baseColor;
  final Color unSelectedColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    _loadSelectedLanguageIndex();
  }

  void _loadSelectedLanguageIndex() {
    setState(() {
      selectedContainerIndex =
          widget.sharedPreferences.getInt('selectedLanguageIndex') ?? 1;
      tempSelectedIndex = selectedContainerIndex;
    });
  }

  void _saveSelectedLanguageIndex(int index) async {
    widget.sharedPreferences.setInt('selectedLanguageIndex', index);
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double screenWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: SafeArea(
        child: Column(
          children: [
            AppBarWidget(
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              textTitle: LocalizationKeys.changeLanguage.tr(),
            ).animate().fade(duration: .2.seconds, delay: .1.seconds),
            SizedBox(
              height: screenHeight * 0.05,
            ),
            GestureDetector(
              onTap: () async {
                setState(() {
                  tempSelectedIndex = 1;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                width: screenWidth * 0.8, //362,
                height: screenHeight * 0.09, //64,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  border: Border.all(
                    color: tempSelectedIndex == 1
                        ? selectedColor
                        : unSelectedColor,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      AppImages.englishLanguage,
                    ),
                    SizedBox(
                      width: screenWidth * 0.02,
                    ),
                    Text(
                      LocalizationKeys.englishOption.tr(),
                      style: TextStyle(
                        fontSize: screenWidth * 0.04, //16,
                        fontWeight: FontWeight.w500,
                        color: AppColor.buttonDetailsColor,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.check_circle_outline_rounded,
                      color: tempSelectedIndex == 1
                          ? selectedColor
                          : unSelectedColor,
                    ),
                  ],
                ),
              ),
            ).animate().fade(duration: .3.seconds, delay: .2.seconds),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  tempSelectedIndex = 2;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: screenWidth * 0.8, // 362,
                height: screenHeight * 0.09, //64,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  border: Border.all(
                    color: tempSelectedIndex == 2
                        ? selectedColor
                        : unSelectedColor,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      AppImages.arabicLanguage,
                    ),
                    SizedBox(
                      width: screenWidth * 0.02,
                    ),
                    Text(
                      LocalizationKeys.arabicOption.tr(),
                      style: TextStyle(
                        fontSize: screenWidth * 0.04, //16,
                        fontWeight: FontWeight.w500,
                        color: AppColor.buttonDetailsColor,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.check_circle_outline_rounded,
                      color: tempSelectedIndex == 2
                          ? selectedColor
                          : unSelectedColor,
                    ),
                  ],
                ),
              ),
            ).animate().fade(duration: .4.seconds, delay: .3.seconds),
            const Spacer(),
            AppButton(
              onTap: () async {
                if (tempSelectedIndex != null) {
                  setState(() {
                    selectedContainerIndex = tempSelectedIndex!;
                  });
                  _saveSelectedLanguageIndex(selectedContainerIndex);

                  if (selectedContainerIndex == 1) {
                    await EasyLocalization.of(context)!
                        .setLocale(const Locale('en'));
                  } else {
                    await EasyLocalization.of(context)!
                        .setLocale(const Locale('ar'));
                  }

                  widget.languageChangedNotifier.value =
                      !widget.languageChangedNotifier.value;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(LocalizationKeys.languageChanged.tr()),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              text: LocalizationKeys.save.tr(),
              textColor: AppColor.whiteColor,
              containerColor: AppColor.buttonColor,
            ).animate().fade(duration: .5.seconds, delay: .4.seconds),
            SizedBox(
              height: screenHeight * 0.07,
            )
          ],
        ),
      ),
    );
  }
}
