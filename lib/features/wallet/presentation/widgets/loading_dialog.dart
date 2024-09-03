import 'package:careem_app_clean/core/resources/color.dart';
import 'package:flutter/material.dart';

class LoadingDialogAddMoney extends StatelessWidget {
  const LoadingDialogAddMoney({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  final double screenWidth;
  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenWidth * 0.533,
      height: screenHeight * 0.5, //0.369,
      child: const Center(
        child: CircularProgressIndicator(
          color: AppColor.baseColor,
        ),
      ),
    );
  }
}
