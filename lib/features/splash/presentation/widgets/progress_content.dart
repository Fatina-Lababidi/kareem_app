
import 'package:careem_app_clean/core/resources/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ProgressContent extends StatelessWidget {
  final String image;
  final String title;
  final double screenHeight;
  final double screenWidth;
  final String descriptionP1;
  final String descriptionP2;
  final String descriptionP3;

  const ProgressContent({
    super.key,
    required this.image,
    required this.title,
    required this.descriptionP1,
    required this.descriptionP2,
    required this.descriptionP3,
    required this.screenHeight,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: screenHeight * 0.3,
          width: screenWidth * 1,
          child: Image.asset(
            image,
          ).animate().scaleXY(duration: .4.seconds, delay: .2.seconds),
        ),
        SizedBox(
          height: screenHeight * 0.02,
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ).animate().fade(duration: .4.seconds, delay: .25.seconds),
        SizedBox(
          height: screenHeight * 0.02,
        ),
        Text(
          descriptionP1,
          style: const TextStyle(
            fontSize: 14,
            color: AppColor.detailsTextColor,
            fontWeight: FontWeight.w500,
          ),
        ).animate().fade(duration: .4.seconds, delay: .3.seconds),
        Text(
          descriptionP2,
          style: const TextStyle(
            fontSize: 14,
            color: AppColor.detailsTextColor,
            fontWeight: FontWeight.w500,
          ),
        ).animate().fade(duration: .4.seconds, delay: .4.seconds),
        Text(
          descriptionP3,
          style: const TextStyle(
            fontSize: 14,
            color: AppColor.detailsTextColor,
            fontWeight: FontWeight.w500,
          ),
        ).animate().fade(duration: .4.seconds, delay: .5.seconds),
      ],
    );
  }
}
