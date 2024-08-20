import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/resources/string.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

//!! setstate!!

class BackWidget extends StatelessWidget {
  const BackWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    EasyLocalization.of(context)?.locale;
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Row(
        children: [
          const Icon(
            size: 20,
            Icons.arrow_back_ios_new_outlined,
            color: AppColor.contentSecondaryTextColor,
          ),
          Text(
            LocalizationKeys.back.tr(),
            style: const TextStyle(
                color: AppColor.contentSecondaryTextColor,
                fontSize: 16,
                fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
