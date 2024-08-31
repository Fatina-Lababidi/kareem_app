import 'package:careem_app_clean/core/resources/color.dart';
import 'package:flutter/material.dart';

class BikeSpecificationColWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final String title;
  const BikeSpecificationColWidget({
    super.key,
    required this.icon,
    required this.text,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double screenWidth = MediaQuery.sizeOf(context).width;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.all(5),
      height: screenHeight * 0.1, //50,
      decoration: BoxDecoration(
          color: AppColor.categoriesContainerColor,
          border: Border.all(
            color: AppColor.baseColor,
          ),
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: AppColor.buttonDetailsColor,
              ),
              SizedBox(
                width: screenWidth * 0.02,
              ),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: AppColor.buttonDetailsColor,
                  fontSize: screenWidth * 0.035,
                ),
              ),
            ],
          ),
          Text(
            text,
            style: TextStyle(
                color: AppColor.buttonDetailsColor,
                fontSize: screenWidth * 0.035, //14,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
