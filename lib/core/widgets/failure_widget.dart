import 'package:careem_app_clean/core/resources/asset.dart';
import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/resources/string.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class FailureUi extends StatelessWidget {
  final void Function()? onTap;
  const FailureUi({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          AppImages.failureImage,
          width: 200,
        ).animate(
          onComplete: (controller) {
            controller.repeat();
          },
        ).slideY(delay: 0.1.seconds, duration: 5.seconds),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColor.baseColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              LocalizationKeys.tryAgain.tr(),
              style: const TextStyle(
                color: AppColor.whiteColor,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
