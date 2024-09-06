import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/widgets/appBar_widget.dart';
import 'package:careem_app_clean/core/widgets/app_button.dart';
import 'package:careem_app_clean/features/home/presentation/view/home_page.dart';
import 'package:careem_app_clean/features/payment/presentation/view/payment_page.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';



class PaymentWithNoWalletWidget extends StatelessWidget {
  const PaymentWithNoWalletWidget({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.widget,
  });

  final double screenWidth;
  final double screenHeight;
  final PaymentPage widget;

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          AppBarWidget(
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            textTitle: 'Payment',
          ),
          Spacer(),
          Text(
            textAlign: TextAlign.center,
            'please make a wallet fist and add money to it \n  then pay to the rect from the RentDetails Page!',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColor.buttonDetailsColor),
          ),
          Spacer(),
          AppButton(
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            text: 'Make wallet',
            textColor: AppColor.whiteColor,
            containerColor: AppColor.buttonColor,
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  child: HomePage(
                    dio: widget.dio,
                    sharedPreferences: widget.sharedPreferences,
                    currentIndex: 2, //wallet page
                  ),
                  type: PageTransitionType.fade,
                ),
              );
            },
          ),
          SizedBox(
            height: screenHeight * 0.03,
          ),
        ],
      );
  }
}

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
