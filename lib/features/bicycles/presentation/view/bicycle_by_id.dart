import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/widgets/back_row_widget.dart';
import 'package:careem_app_clean/features/bicycles/presentation/view/widgets/bikeSpecificationColWidget.dart';
import 'package:careem_app_clean/features/bicycles/presentation/view/widgets/bikeSpecificationRoWidget.dart';
import 'package:careem_app_clean/features/hub/presentation/view/hub_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class BicycleByIdPage extends StatelessWidget {
  final int id;
  final double price;
  final String model;
  final int size;
  final String photoPath;
  final String type;
  final String note;
  final Dio dio;

  const BicycleByIdPage(
      {super.key,
      required this.id,
      required this.price,
      required this.model,
      required this.size,
      required this.photoPath,
      required this.type,
      required this.note,
      required this.dio});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenHeight = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.012 //12,
                    ),
                const BackWidget(),
                SizedBox(height: screenHeight * 0.02 //20,
                    ),
                Text(
                  model,
                  style: const TextStyle(
                    color: AppColor.buttonDetailsColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  type,
                  style: const TextStyle(
                      fontSize: 14,
                      color: AppColor.skipTextColor,
                      fontWeight: FontWeight.w500),
                ),
                Center(
                  child: Image.network(
                    // loadingBuilder: (context, child, loadingProgress) {
                    //   return const CircularProgressIndicator(
                    //     color: AppColor.baseColor,
                    //   );
                    // },
                    errorBuilder: (context, error, stackTrace) {
                      return Column(
                        children: [
                          Image.asset(
                            'assets/images/bicycle.png',
                            width: 50,
                          ),
                          Text('enable to fetch image'), //! localization
                        ],
                      );
                    },
                    'https://$photoPath',
                    width: 200,
                    colorBlendMode: BlendMode.colorBurn,
                  ),
                ),
                SizedBox(height: screenHeight * 0.04 //5,
                    ),
                Text(
                  'Specifications',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColor.buttonDetailsColor),
                ), //! Localization
                SizedBox(height: screenHeight * 0.02 //5,
                    ),
                bikeSpecificationsRow(screenWidth),
                SizedBox(
                  height: screenHeight * 0.02, //5,
                ),
                Text('bicycle features',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: AppColor.buttonDetailsColor)),
                SizedBox(height: screenHeight * 0.02 //5,
                    ),
                BikeSpecificationColWidget(
                    title: 'type: ',
                    text: type,
                    icon: Icons.pedal_bike_outlined),
                SizedBox(height: screenHeight * 0.015 // 10,
                    ),
                BikeSpecificationColWidget(
                    title: 'model: ', text: model, icon: Icons.numbers),
                SizedBox(
                  height: screenHeight * 0.015, // 10,
                ),
                BikeSpecificationColWidget(
                  title: 'price: ',
                  text: price.toString(),
                  icon: Icons.attach_money_rounded,
                ),
                SizedBox(
                  height: screenHeight * 0.015, //10,
                ),
                BikeSpecificationColWidget(
                    title: 'size: ',
                    text: size.toString(),
                    icon: Icons.confirmation_number_sharp),
                SizedBox(height: screenHeight * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: screenHeight * 0.07, //50,
                      width: screenWidth * 0.4, //170,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColor.buttonColor,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          'Book later',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColor.buttonColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: screenWidth * 0.03,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: HubPage(
                                  dio: dio,
                                ),
                                type: PageTransitionType.fade));
                      },
                      child: Container(
                        height: screenHeight * 0.07, //50,
                        width: screenWidth * 0.4, //170,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColor.buttonColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            'Ride Now',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColor.whiteColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                //tow buttons : what the diffrence between them ?
                SizedBox(
                  height: screenHeight * 0.05,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  bikeSpecificationsRow(double screenWidth) {
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
      ),
    );
  }
}
