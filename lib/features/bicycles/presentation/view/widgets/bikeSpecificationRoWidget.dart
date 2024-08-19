import 'package:careem_app_clean/core/resources/color.dart';
import 'package:flutter/material.dart';

class BikeSpecificationRoWidget extends StatelessWidget {
  const BikeSpecificationRoWidget({
    super.key,
    required this.text,
    required this.icon,
  });

  final String text;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      //! query
      width: 80,
      height: 80,
      decoration: BoxDecoration(
          color: AppColor.categoriesContainerColor,
          border: Border.all(
            color: AppColor.baseColor,
          ),
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: AppColor.buttonDetailsColor,
          ),
          Text(
            text,
            style: const TextStyle(
                color: AppColor.buttonDetailsColor,
                fontSize: 10,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
