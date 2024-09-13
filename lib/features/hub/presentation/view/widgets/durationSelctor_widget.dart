import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/resources/string.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DurationselctorWidget extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final ValueNotifier<double> durationNotifier;

  const DurationselctorWidget(
      {super.key,
      required this.screenHeight,
      required this.screenWidth,
      required this.onDecrement,
      required this.onIncrement,
      required this.durationNotifier});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth * 0.89, //360,
      height: screenHeight * 0.09, //60,
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.skipTextColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: onDecrement,
            icon: Icon(Icons.remove),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ValueListenableBuilder<double>(
                valueListenable: durationNotifier,
                builder: (context, value, child) {
                  return Text('$value');
                },
              ),
              Text(
                LocalizationKeys.duration.tr(),
                style: TextStyle(
                    color: AppColor.hintColor,
                    fontSize: screenWidth * 0.04, // 16,
                    fontWeight: FontWeight.w500),
              )
            ],
          ),
          IconButton(onPressed: onIncrement, icon: const Icon(Icons.add))
        ],
      ),
    );
  }
}
