import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/resources/string.dart';
import 'package:careem_app_clean/core/widgets/appBar_widget.dart';
import 'package:careem_app_clean/core/widgets/app_button.dart';
import 'package:careem_app_clean/features/home/presentation/view/home_page.dart';
import 'package:careem_app_clean/features/payment/presentation/view/payment_page.dart';
import 'package:easy_localization/easy_localization.dart';
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
            textTitle: LocalizationKeys.payment.tr() //'Payment',
            ),
        const Spacer(),
        Text(
          textAlign: TextAlign.center,
          '${LocalizationKeys.createWalletAndAddMoney.tr()} \n ${LocalizationKeys.cofirmFormDetailsPage.tr()}',
          // 'please make a wallet fist and add money to it \n  then pay to the rect from the RentDetails Page!',
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColor.buttonDetailsColor),
        ),
        const Spacer(),
        AppButton(
          screenWidth: screenWidth,
          screenHeight: screenHeight,
          text: LocalizationKeys.createWallet.tr(), //'Make wallet',
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
