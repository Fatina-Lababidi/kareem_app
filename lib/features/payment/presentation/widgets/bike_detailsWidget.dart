import 'package:careem_app_clean/core/resources/color.dart';
import 'package:flutter/material.dart';

class BikeDetailsWidget extends StatelessWidget {
  const BikeDetailsWidget({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.bikeModel,
    required this.photoPath,
  });

  final double screenWidth;
  final double screenHeight;
  final String bikeModel;
  final String photoPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth * 0.89, //360,
      height: screenHeight * 0.125, //80,
      decoration: BoxDecoration(
        color: AppColor.categoriesContainerColor,
        border: Border.all(color: AppColor.baseColor),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              bikeModel,
              style: TextStyle(
                  color: AppColor.buttonDetailsColor,
                  fontSize: screenWidth * 0.04, //16,
                  fontWeight: FontWeight.w500),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Image.network(
                errorBuilder: (context, error, stackTrace) {
                  return Column(
                    children: [
                      Image.asset(
                        'assets/images/bicycle.png',
                        width: screenWidth * 0.12,
                      ),
                      Text('enable to fetch '), //! localization
                    ],
                  );
                },
                'https://${photoPath}',
                width: screenWidth * 0.2, //200,
                colorBlendMode: BlendMode.colorBurn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
