import 'package:careem_app_clean/core/functions/language.dart';
import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/resources/string.dart';
import 'package:careem_app_clean/features/wallet/presentation/view/add_money_page.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddMoneyContainer extends StatelessWidget {
  const AddMoneyContainer({
    super.key,
    required this.sharedPreferences,
    required this.dio,
    required this.screenWidth,
    required this.screenHeight,
    required this.context,
  });

  final SharedPreferences sharedPreferences;
  final Dio dio;
  final double screenWidth;
  final double screenHeight;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:isEnglish(context)? Alignment.topRight:Alignment.topLeft,
      child: Container(
        width: screenWidth * 0.45, //170,
        height: screenHeight * 0.08, //54,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColor.buttonColor,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: InkWell(
          onTap: () {
            //navigate to the add page
            Navigator.push(
                context,
                PageTransition(
                    child: AddMoneyPage(
                      sharedPreferences: sharedPreferences,
                      dio: dio,
                    ),
                    type: PageTransitionType.fade));
          },
          child: Center(
            child: Text(
              textAlign: TextAlign.center,
              LocalizationKeys.addMoney.tr(),
              style: TextStyle(
                  color: AppColor.buttonColor,
                  fontSize: screenWidth * 0.04, //16,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }
}
