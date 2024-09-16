import 'package:careem_app_clean/features/bicycles/presentation/view/widgets/bikeSpecificationRoWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class BikeSpecificationsRow extends StatelessWidget {
  final double screenWidth;
  final String model;
  final double price;
  final String type;
  final int size;
  const BikeSpecificationsRow(
      {super.key,
      required this.screenWidth,
      required this.model,
      required this.price,
      required this.type,
      required this.size});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: screenWidth * 0.01 // 5,
              ),
          BikeSpecificationRoWidget(
              text: type, icon: Icons.pedal_bike_outlined),
          SizedBox(width: screenWidth * 0.02 //10,
              ),
          BikeSpecificationRoWidget(text: model, icon: Icons.numbers),
          SizedBox(
            width: screenWidth * 0.02, //10,
          ),
          BikeSpecificationRoWidget(
            text: price.toString(),
            icon: Icons.attach_money_rounded,
          ),
          SizedBox(width: screenWidth * 0.02 //10,
              ),
          BikeSpecificationRoWidget(
              text: size.toString(), icon: Icons.confirmation_number_sharp),
          SizedBox(width: screenWidth * 0.01 // 5,
              ),
        ],
      ).animate().fade(duration: .6.seconds, delay: .45.seconds),
    );
  }
}
