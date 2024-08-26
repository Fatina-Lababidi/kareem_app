import 'package:careem_app_clean/core/resources/asset.dart';
import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/resources/string.dart';
import 'package:careem_app_clean/core/widgets/app_button.dart';
import 'package:careem_app_clean/features/authentication/data/datasource/remote/remote_user.dart';
import 'package:careem_app_clean/features/authentication/data/repositories/auth_repository_imp.dart';
import 'package:careem_app_clean/features/authentication/domain/usecases/login_usecase.dart';
import 'package:careem_app_clean/features/authentication/presentation/login_bloc/login_bloc.dart';
import 'package:careem_app_clean/features/authentication/presentation/view/login_page.dart';
import 'package:careem_app_clean/features/authentication/presentation/view/register_page.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomePage extends StatelessWidget {
  final SharedPreferences sharedPreferences;
  final Dio dio;
  final double screenHeight;
  final double screenWidth;
  const WelcomePage(
      {super.key,
      required this.sharedPreferences,
      required this.dio,
      required this.screenHeight,
      required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Center(
          child: Column(
        children: [
          SizedBox(
            height: screenHeight * 0.05, //20,
          ),
          Image.asset(
            AppImages.welcome,
          ).animate().fade(duration: 0.2.seconds, delay: .1.seconds),
          SizedBox(
            height: screenHeight * 0.05, //20,
          ),
          Text(
            LocalizationKeys.welcome.tr(),
            style: TextStyle(fontSize: screenWidth * 0.06 //24,
                ),
          ).animate().fade(duration: .3.seconds, delay: .2.seconds),
          SizedBox(
            height: screenHeight * 0.02,
          ),
          Text(
            LocalizationKeys.betterSharingExperience.tr(),
            style: TextStyle(
                fontSize: screenWidth * 0.04, //16,
                color: AppColor.detailsTextColor),
          ).animate().fade(duration: .4.seconds, delay: .3.seconds),
          const Spacer(),
          AppButton(
            onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                      child: SignUpPage(
                        dio: dio,
                        sharedPreferences: sharedPreferences,
                        screenHeight: screenHeight,
                        screenWidth: screenWidth,
                      ),
                      type: PageTransitionType.fade));
            }, //navigate to sign up page
            text: LocalizationKeys.createAccount.tr(),
            containerColor: AppColor.buttonColor,
            textColor: AppColor.whiteColor,
            screenWidth: screenWidth,
            screenHeight: screenHeight,
          ).animate().fade(duration: .5.seconds, delay: .4.seconds),
          SizedBox(
            height: screenHeight * 0.03,
          ),
          AppButton(
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            child: BlocProvider(
                              create: (context) => LoginBloc(
                                LoginUserUseCase(
                                  repository: AuthRepositoryImpl(
                                    internetConnectionChecker:
                                        InternetConnectionChecker(),
                                    remoteDataSource:
                                        RemoteUserDataSourceImpl(dio: dio),
                                    sharedPreferences: sharedPreferences,
                                  ),
                                ),
                              ),
                              child: LoginPage(
                                dio: dio,
                                sharedPreferences: sharedPreferences,
                                screenHeight: screenHeight,
                                screenWidth: screenWidth,
                              ),
                            ),
                            type: PageTransitionType.fade));
                  },
                  text: LocalizationKeys.logIn.tr(),
                  containerColor: AppColor.whiteColor,
                  textColor: AppColor.buttonColor,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight)
              .animate()
              .fade(duration: .6.seconds, delay: .5.seconds),
          SizedBox(
            height: screenHeight * 0.075, // 30,
          )
        ],
      )),
    );
  }
}
