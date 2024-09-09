import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/features/hub/presentation/view/pages/hub_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class ToHubRowWidget extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final String selectedHubName;
  final String descriptionText;
  final Color selectedTextColor;
  final ValueChanged<Map<String, dynamic>> onHubSelected;
  final Future<Map<String, dynamic>?> Function() getLocationData;
  final Dio dio;

  const ToHubRowWidget({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.selectedHubName,
    required this.descriptionText,
    required this.selectedTextColor,
    required this.onHubSelected,
    required this.getLocationData,
    required this.dio,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          const Icon(
            Icons.location_on,
            color: AppColor.baseColor,
          ),
          TextButton(
            onPressed: () async {
              final locationData = await getLocationData();
              if (locationData != null) {
                final result = await Navigator.push(
                  context,
                  PageTransition(
                    child: HubPage(
                      dio: dio,
                      lat: locationData['latitude']!,
                      lng: locationData['longitude']!,
                    ),
                    type: PageTransitionType.fade,
                  ),
                );

                if (result != null && result is Map<String, dynamic>) {
                  onHubSelected(result);
                }
              }
            },
            child: Column(
              children: [
                Text(
                  selectedHubName,
                  style: TextStyle(
                    color: selectedTextColor,
                    fontSize: screenWidth * 0.04, // 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  descriptionText,
                  style: TextStyle(
                    fontSize: screenWidth * 0.03, // 12,
                    fontWeight: FontWeight.w400,
                    color: AppColor.skipTextColor,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
