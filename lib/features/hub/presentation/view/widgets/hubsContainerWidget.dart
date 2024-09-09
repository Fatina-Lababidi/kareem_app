import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/features/hub/domain/entities/all_hub_entity.dart';
import 'package:flutter/material.dart';

class HubsContainer extends StatelessWidget {
  const HubsContainer({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.item,
  });

  final double screenHeight;
  final double screenWidth;
  final PlaceEntity item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: screenHeight * 0.01,
        horizontal: screenWidth * 0.05,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColor.circularRipple2,
            width: 1,
          )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(
            Icons.pedal_bike_outlined,
            color: AppColor.baseColor,
          ),
          Text(
            item.name,
            style: TextStyle(
              fontSize: screenWidth * 0.04,
            ),
          ),
        ],
      ),
    );
  }
}
