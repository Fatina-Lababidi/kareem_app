
import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/features/hub/presentation/view/rent_hub_page.dart';
import 'package:flutter/material.dart';

class BikeDetailsForRent extends StatelessWidget {
  const BikeDetailsForRent({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.widget,
  });

  final double screenWidth;
  final double screenHeight;
  final RentPage widget;

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
              widget.bikeModel,
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
                'https://${widget.photoPath}',
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
