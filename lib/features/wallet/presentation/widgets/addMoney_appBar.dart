import 'package:careem_app_clean/core/functions/language.dart';
import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/resources/string.dart';
import 'package:careem_app_clean/core/widgets/back_row_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AddMoneyAppBar extends StatelessWidget {
  const AddMoneyAppBar({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  final double screenWidth;
  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(
              left: screenWidth * 0.02, top: screenHeight * 0.01),
          child: const BackWidget(),
        ),
        Expanded(
          child: Center(
            child: Padding(
              padding: isEnglish(context)
                  ? EdgeInsets.only(
                      right: screenWidth * 0.125, top: screenHeight * 0.01)
                  : EdgeInsets.only(
                      left: screenWidth * 0.125, top: screenHeight * 0.01),
              child: Text(
                LocalizationKeys.amountTitle.tr(),
                style: TextStyle(
                    color: AppColor.settingsTitleColor,
                    fontSize: screenWidth * 0.048, //18,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
