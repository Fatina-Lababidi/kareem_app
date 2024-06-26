import 'package:careem_app/core/resources/color.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.text,
    required this.textColor,
    required this.containerColor,
    this.borderColor = AppColor.buttonColor, this.onTap,
  });

  final double screenWidth;
  final double screenHeight;
  final String text;
  final Color textColor;
  final Color containerColor;
  final Color? borderColor;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:onTap,//log in
      child: Container(
        width: screenWidth * 0.75, //340,
        height: screenHeight * 0.075, // 54,
        decoration: BoxDecoration(
          border: Border.all(color: borderColor ?? AppColor.baseColor),
          color: containerColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: screenWidth * 0.04, // 16,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
