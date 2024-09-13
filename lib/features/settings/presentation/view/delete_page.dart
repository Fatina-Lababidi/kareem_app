import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/resources/string.dart';
import 'package:careem_app_clean/core/widgets/appBar_widget.dart';
import 'package:careem_app_clean/core/widgets/app_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeletePage extends StatelessWidget {
  final SharedPreferences sharedPreferences;
  const DeletePage({super.key, required this.sharedPreferences});

  Future<void> deleteToken() async {
    await sharedPreferences.remove('token');
    await sharedPreferences.remove('clientId');
    await sharedPreferences
        .remove('haveWallet'); //! have to find better solution
    print('token deleted');
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double screenWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppBarWidget(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              textTitle: LocalizationKeys.deleteAccount.tr(),
            ).animate().fade(duration: .2.seconds, delay: .1.seconds),
            Text(
              textAlign: TextAlign.center,
              LocalizationKeys.deleteTokenQues.tr(),
              style: const TextStyle(
                  color: AppColor.policydescColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
            ),
            Center(
              child: AppButton(
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                text: LocalizationKeys.deleteToken.tr(),
                textColor: AppColor.whiteColor,
                containerColor: AppColor.snackbarFaildColor,
                borderColor: AppColor.snackbarFaildColor,
                onTap: () {
                  deleteToken().then((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text(LocalizationKeys.deleteTokenSnackBar.tr()),
                        duration: const Duration(seconds: 1),
                        backgroundColor: AppColor.snackbarOfflineColor,
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
      ),
    );
  }
}
