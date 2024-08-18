import 'package:careem_app_clean/core/resources/color.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsOption extends StatelessWidget {
  const SettingsOption({
    super.key,
    required this.dio,
    required this.sharedPreferences,
    required this.screenWidth,
    required this.screenHeight,
    required this.child,
    required this.text,
  });

  final Dio dio;
  final SharedPreferences sharedPreferences;
  final double screenWidth;
  final double screenHeight;
  final Widget child;
  final String text;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
            child: child,
            type: PageTransitionType.fade,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        width: screenWidth * 0.9, //362,
        height: screenHeight * 0.078, // 51,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            border: Border.all(color: AppColor.baseColor, width: 0.5)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColor.contentSecondaryTextColor,
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColor.contentSecondaryTextColor,
              size: 20,
            )
          ],
        ),
      ),
    );
  }
}
