import 'package:careem_app_clean/core/functions/language.dart';
import 'package:careem_app_clean/core/network/network_connection.dart';
import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/resources/string.dart';
import 'package:careem_app_clean/core/widgets/back_row_widget.dart';
import 'package:careem_app_clean/features/authentication/data/datasource/remote/remote_user.dart';
import 'package:careem_app_clean/features/authentication/data/repositories/auth_repository_imp.dart';
import 'package:careem_app_clean/features/authentication/domain/usecases/change_password.dart';
import 'package:careem_app_clean/features/authentication/presentation/changePassword_bloc/change_password_bloc.dart';
import 'package:careem_app_clean/features/authentication/presentation/view/changePassword.dart';
import 'package:careem_app_clean/features/settings/data/datasource/remote_policy.dart';
import 'package:careem_app_clean/features/settings/data/repositories/policy_repo_imp.dart';
import 'package:careem_app_clean/features/settings/domain/usecase/get_policy.dart';
import 'package:careem_app_clean/features/settings/presentation/policy_bloc/policy_bloc.dart';
import 'package:careem_app_clean/features/settings/presentation/view/change_language.dart';
import 'package:careem_app_clean/features/settings/presentation/view/policy_page.dart';
import 'package:careem_app_clean/features/settings/presentation/view/widgets/settings_options.dart';
import 'package:careem_app_clean/main.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatelessWidget {
  final Dio dio;
  final SharedPreferences sharedPreferences;
  final double screenHeight;
  final double screenWidth;
  const SettingsPage(
      {super.key,
      required this.dio,
      required this.sharedPreferences,
      required this.screenHeight,
      required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: SafeArea(
        child: Column(
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
                          ? const EdgeInsets.only(right: 50)
                          : const EdgeInsets.only(left: 50),
                      child: Text(
                        LocalizationKeys.settingsTitle.tr(),
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
            SizedBox(
              height: screenHeight * 0.05,
            ),
            SettingsOption(
              dio: dio,
              sharedPreferences: sharedPreferences,
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              text: LocalizationKeys.changePasswordTitle.tr(),
              child: BlocProvider(
                create: (context) => ChangePasswordBloc(
                  ChangePasswordUseCase(
                    repository: AuthRepositoryImpl(
                      internetConnectionChecker: InternetConnectionChecker(),
                      remoteDataSource: RemoteUserDataSourceImpl(dio: dio),
                      sharedPreferences: sharedPreferences,
                    ),
                  ),
                ),
                child: ChangePasswordPage(
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                ),
              ),
            ).animate().scaleXY(duration: .3.seconds, delay: .15.seconds),
            SizedBox(
              height: screenHeight * 0.025,
            ),
            SettingsOption(
              dio: dio,
              sharedPreferences: sharedPreferences,
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              text: LocalizationKeys.changeLanguage.tr(),
              child: ChangeLanguage(
                screenHeight: screenHeight,
                screenWidth: screenWidth,
              ),
            ).animate().scaleXY(duration: .4.seconds, delay: .2.seconds),
            SizedBox(
              height: screenHeight * 0.025,
            ),
            SettingsOption(
              dio: dio,
              sharedPreferences: sharedPreferences,
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              text: LocalizationKeys.privacyPolicy.tr(),
              child: BlocProvider<PolicyBloc>(
                create: (context) => PolicyBloc(
                  GetPolicyUseCase(
                    policyRepo: PolicyRepoImp(
                      remotePolicyDataSource: RemotePolicyDataSource(dio: dio),
                      networkConnection: NetworkConnection(
                        internetConnectionChecker: InternetConnectionChecker(),
                      ),
                    ),
                  ),
                )..add(GetPolicy()),
                child: PolicyPage(
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                ),
              ),
            ).animate().scaleXY(duration: .5.seconds, delay: .25.seconds),
            SizedBox(
              height: screenHeight * 0.025,
            ),
            SettingsOption(
              dio: dio,
              sharedPreferences: sharedPreferences,
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              text: LocalizationKeys.contactUs.tr(),
              child: const NextPage(
                id: 1,
              ),
            ).animate().scaleXY(duration: .6.seconds, delay: .3.seconds),
            SizedBox(
              height: screenHeight * 0.025,
            ),
            SettingsOption(
                dio: dio,
                sharedPreferences: sharedPreferences,
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                text: LocalizationKeys.deleteAccount.tr(),
                child: const NextPage(
                  id: 1,
                )).animate().scaleXY(duration: .7.seconds, delay: .35.seconds)
          ],
        ),
      ),
    );
  }
}


//change the child :