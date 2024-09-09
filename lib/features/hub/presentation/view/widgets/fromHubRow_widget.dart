import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/features/hub/presentation/view/pages/rent_hub_page.dart';
import 'package:flutter/material.dart';

class FromHubRowWidget extends StatelessWidget {
  const FromHubRowWidget({
    super.key,
    required this.widget,
    required this.screenWidth,
  });

  final RentPage widget;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          const Icon(
            Icons.location_on,
            color: AppColor.snackbarFaildColor,
          ),
          Column(
            children: [
              Text(
                widget.hubName,
                style: TextStyle(
                    color: AppColor.buttonDetailsColor,
                    fontSize: screenWidth * 0.04, // 16,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                widget.hubDescription,
                style: TextStyle(
                    fontSize: screenWidth * 0.04, //12,
                    fontWeight: FontWeight.w400,
                    color: AppColor.skipTextColor),
              )
            ],
          ),
        ],
      ),
    );
  }
}
