import 'package:careem_app_clean/core/functions/language.dart';
import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/widgets/back_row_widget.dart';
import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({
    super.key,
    required this.screenWidth,
    required this.screenHeight, required this.textTitle,
  });

  final double screenWidth;
  final double screenHeight;
  final String textTitle;

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
                textTitle,
                style: TextStyle(
                  fontSize: screenWidth * 0.045, //18,
                  color: AppColor.settingsTitleColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
