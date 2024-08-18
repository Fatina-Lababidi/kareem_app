
import 'package:careem_app_clean/core/functions/language.dart';
import 'package:careem_app_clean/core/resources/asset.dart';
import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/resources/string.dart';
import 'package:careem_app_clean/core/widgets/app_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeLanguage extends StatefulWidget {
  const ChangeLanguage({super.key});

  @override
  State<ChangeLanguage> createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguage> {
  int selectedContainerIndex = 1;
  final Color selectedColor = AppColor.baseColor;
  final Color unSelectedColor = Colors.grey;
  final SharedPreferences _prefs = GetIt.instance<SharedPreferences>();

  @override
  void initState() {
    super.initState();
    _loadSelectedLanguageIndex();
  }

  void _loadSelectedLanguageIndex() {
    setState(() {
      selectedContainerIndex = _prefs.getInt('selectedLanguageIndex') ?? 1;
    });
  }

  void _saveSelectedLanguageIndex(int index) async {
    await _prefs.setInt('selectedLanguageIndex', index);
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
            SizedBox(
              height: screenHeight * 0.02,
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.02),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        const Icon(
                          size: 20,
                          Icons.arrow_back_ios_new_outlined,
                          color: AppColor.contentSecondaryTextColor,
                        ),
                        Text(
                          LocalizationKeys.back.tr(),
                          style: const TextStyle(
                              color: AppColor.contentSecondaryTextColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: isEnglish(context)
                          ? const EdgeInsets.only(right: 50)
                          : const EdgeInsets.only(left: 50),
                      child: Text(
                        LocalizationKeys.changeLanguage.tr(),
                        style: const TextStyle(
                          fontSize: 18,
                          color: AppColor.settingsTitleColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ).animate().fade(duration: .2.seconds, delay: .1.seconds),
            SizedBox(
              height: screenHeight * 0.05,
            ),
            GestureDetector(
              onTap: () async {
                setState(() {
                  selectedContainerIndex = 1;
                });
                 _saveSelectedLanguageIndex(selectedContainerIndex);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                width: screenWidth * 0.8, //362,
                height: screenHeight * 0.09, //64,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  border: Border.all(
                    color: selectedContainerIndex == 1
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
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColor.buttonDetailsColor,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.check_circle_outline_rounded,
                      color: selectedContainerIndex == 1
                          ? selectedColor
                          : unSelectedColor,
                    ),
                  ],
                ),
              ),
            ).animate().fade(duration: .3.seconds,delay: .2.seconds),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedContainerIndex = 2;
                });
                 _saveSelectedLanguageIndex(selectedContainerIndex);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: screenWidth * 0.8, // 362,
                height: screenHeight * 0.09, //64,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  border: Border.all(
                    color: selectedContainerIndex == 2
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
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColor.buttonDetailsColor,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.check_circle_outline_rounded,
                      color: selectedContainerIndex == 2
                          ? selectedColor
                          : unSelectedColor,
                    ),
                  ],
                ),
              ),
            ).animate().fade(duration: .4.seconds,delay: .3.seconds),
            const Spacer(),
            AppButton(
              onTap: () async {
                if (selectedContainerIndex == 1) {
                  await EasyLocalization.of(context)!
                      .setLocale(const Locale('en'));
                } else {
                  await EasyLocalization.of(context)!
                      .setLocale(const Locale('ar'));
                }
                 ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(LocalizationKeys.languageChanged.tr()),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              text: LocalizationKeys.save.tr(),
              textColor: AppColor.whiteColor,
              containerColor: AppColor.buttonColor,
            ).animate().fade(duration: .5.seconds,delay: .4.seconds),
            SizedBox(
              height: screenHeight * 0.07,
            )
          ],
        ),
      ),
    );
  }
}
