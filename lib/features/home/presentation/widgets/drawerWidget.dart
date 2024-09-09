import 'package:careem_app_clean/core/functions/language.dart';
import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/resources/string.dart';
import 'package:careem_app_clean/features/settings/presentation/view/settings_page.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Drawerwidget extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;
  final Dio dio;
  final SharedPreferences sharedPreferences;
  final VoidCallback toggleDrawer;
  const Drawerwidget(
      {super.key,
      required this.screenHeight,
      required this.screenWidth,
      required this.dio,
      required this.sharedPreferences,
      required this.toggleDrawer});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      bottom: 0,
      // left: isEnglish(context)?0:screenWidth-230,
      left: 0,
      width: screenWidth * 0.6, //230,
      child: GestureDetector(
        onPanUpdate: (details) {
          if (details.delta.dx < -5) {
            toggleDrawer();
          }
        },
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(60),
              bottomRight: Radius.circular(60),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: isEnglish(context)
                    ? EdgeInsets.only(
                        left: screenWidth * 0.02, top: screenHeight * 0.01)
                    : EdgeInsets.only(
                        right: screenWidth * 0.02, top: screenHeight * 0.02),
                child: GestureDetector(
                  onTap: toggleDrawer,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(
                        size: 20,
                        Icons.arrow_back_ios_new_outlined,
                        color: AppColor.contentSecondaryTextColor,
                      ),
                      Text(
                        LocalizationKeys.back.tr(),
                        style: TextStyle(
                            color: AppColor.contentSecondaryTextColor,
                            fontSize: screenWidth * 0.04, //16,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.2,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      child: SettingsPage(
                        dio: dio,
                        sharedPreferences: sharedPreferences,
                      ),
                      type: PageTransitionType.fade,
                    ),
                  );
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.settings,
                      color: AppColor.contentSecondaryTextColor,
                    ),
                    SizedBox(
                      width: screenWidth * 0.02,
                    ),
                    Text(
                      LocalizationKeys.settingsTitle.tr(),
                      style: TextStyle(
                        fontSize: screenWidth * 0.04, //16,
                        color: AppColor.contentSecondaryTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              ),
              const Divider(
                thickness: 1,
                color: AppColor.dividerColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
