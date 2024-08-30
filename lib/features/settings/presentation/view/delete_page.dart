import 'package:careem_app_clean/core/functions/language.dart';
import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/resources/string.dart';
import 'package:careem_app_clean/core/widgets/app_button.dart';
import 'package:careem_app_clean/core/widgets/back_row_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeletePage extends StatelessWidget {
  final SharedPreferences sharedPreferences;
  const DeletePage({super.key, required this.sharedPreferences});

  Future<void> deleteToken() async {
    await sharedPreferences.remove('token');
    print('token deleted');
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double screenWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: screenWidth * 0.02, top: screenHeight * 0.01),
                child: const BackWidget(),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: isEnglish(context)
                        ? EdgeInsets.only(right: 50, top: screenHeight * 0.01)
                        : EdgeInsets.only(left: 50, top: screenHeight * 0.01),
                    child: Text(
                      LocalizationKeys.deleteAccount.tr(),
                      style: const TextStyle(
                        fontSize: 18,
                        color: AppColor.settingsTitleColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ).animate().fade(duration: .2.seconds, delay: .1.seconds),
          Text(
            'Are you sure you want to delete your token?',
            style: TextStyle(
                color: AppColor.policydescColor,
                fontSize: 16,
                fontWeight: FontWeight.w400),
          ),
          Center(
            child: AppButton(
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              text: 'Delete token',
              textColor: AppColor.whiteColor,
              containerColor: AppColor.snackbarFaildColor,
              borderColor: AppColor.snackbarFaildColor,
              onTap: () {
                deleteToken().then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Token has been deleted'),
                    ),
                  );
                });
              },
            ),
          ),
          SizedBox(
            height: screenHeight * 0.02,
          )
        ],
      ),
    );
  }
}
