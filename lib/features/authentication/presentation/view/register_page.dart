import 'package:careem_app_clean/core/functions/language.dart';
import 'package:careem_app_clean/core/resources/asset.dart';
import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/resources/string.dart';
import 'package:careem_app_clean/core/widgets/app_button.dart';
import 'package:careem_app_clean/core/widgets/app_textFormField.dart';
import 'package:careem_app_clean/core/widgets/back_row_widget.dart';
import 'package:careem_app_clean/features/authentication/data/datasource/remote/remote_user.dart';
import 'package:careem_app_clean/features/authentication/data/repositories/auth_repository_imp.dart';
import 'package:careem_app_clean/features/authentication/domain/usecases/login_usecase.dart';
import 'package:careem_app_clean/features/authentication/domain/usecases/register_user.dart';
import 'package:careem_app_clean/features/authentication/presentation/login_bloc/login_bloc.dart';
import 'package:careem_app_clean/features/authentication/presentation/register_bloc/register_bloc_bloc.dart';
import 'package:careem_app_clean/features/authentication/presentation/view/login_page.dart';
import 'package:careem_app_clean/features/authentication/presentation/view/password_page.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({
    super.key,
    required this.sharedPreferences,
    required this.dio,
  });
  final SharedPreferences sharedPreferences;
  final Dio dio;

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController firstNameController = TextEditingController();

  final TextEditingController lastNameController = TextEditingController();

  final TextEditingController userNameController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  final TextEditingController birthDateController = TextEditingController();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    userNameController.dispose();
    phoneController.dispose();
    birthDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double screenWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                        padding: EdgeInsets.only(
                          left: screenWidth * 0.02,
                          top: screenHeight * 0.01,
                        ),
                        child: const BackWidget())
                    .animate()
                    .fade(duration: .2.seconds, delay: .1.seconds),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.02),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      LocalizationKeys.signUpWithEmailOrPhone.tr(),
                      style: TextStyle(
                        color: AppColor.contentSecondaryTextColor,
                        fontSize: screenWidth * 0.06, //24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ).animate().fade(duration: .3.seconds, delay: .15.seconds),
                Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.02),
                  child: Align(
                    alignment: isEnglish(context)
                        ? Alignment.topLeft
                        : Alignment.topRight,
                    child: Text(
                      LocalizationKeys.phoneNumber.tr(),
                      style: TextStyle(
                        color: AppColor.contentSecondaryTextColor,
                        fontSize: screenWidth * 0.06, //24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ).animate().fade(duration: .3.seconds, delay: .2.seconds),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                AppTextFormField(
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  hintText: LocalizationKeys.firstName.tr(),
                  textColor: Colors.black,
                  hintColor: Colors.grey,
                  containerColor: Colors.white,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return LocalizationKeys.firstNameValidate.tr();
                    }
                    return null;
                  },
                  controller: firstNameController,
                ).animate().fade(duration: .4.seconds, delay: .25.seconds),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                AppTextFormField(
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  hintText: LocalizationKeys.lastName.tr(),
                  textColor: Colors.black,
                  hintColor: Colors.grey,
                  containerColor: Colors.white,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return LocalizationKeys.lastNameValidate.tr();
                    }
                    return null;
                  },
                  controller: lastNameController,
                ).animate().fade(duration: .5.seconds, delay: .3.seconds),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                AppTextFormField(
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  hintText: LocalizationKeys.userName.tr(),
                  textColor: Colors.black,
                  hintColor: Colors.grey,
                  containerColor: Colors.white,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return LocalizationKeys.userNameValidate.tr();
                    }
                    return null;
                  },
                  controller: userNameController,
                ).animate().fade(duration: .6.seconds, delay: .35.seconds),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                GestureDetector(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                      builder: (context, child) {
                        return Theme(
                            data: ThemeData.light().copyWith(
                                colorScheme: const ColorScheme.light(
                                    primary: AppColor.baseColor,
                                    onSurface: Colors.black,
                                    onPrimary: AppColor.whiteColor)),
                            child: child!);
                      },
                    );
                    if (pickedDate != null) {
                      birthDateController.text =
                          DateFormat('yyyy-MM-dd', 'en').format(pickedDate);
                    }
                  },
                  child: AbsorbPointer(
                    child: AppTextFormField(
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      hintText: LocalizationKeys.birthDate.tr(),
                      textColor: Colors.black,
                      hintColor: Colors.grey,
                      containerColor: Colors.white,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return LocalizationKeys.birthDateValidate.tr();
                        }
                        return null;
                      },
                      controller: birthDateController,
                    ).animate().fade(duration: .7.seconds, delay: .4.seconds),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                AppTextFormField(
                  controller:phoneController,
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                  hintText: LocalizationKeys.phoneNumber.tr(),
                  textColor: Colors.black,
                  hintColor: Colors.grey,
                  containerColor: Colors.white,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return LocalizationKeys.phoneValidate.tr();
                    }
                    if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                      return LocalizationKeys.phoneValidate.tr();
                    }
                    return null;
                  },
                ).animate().fade(duration: .8.seconds, delay: .45.seconds),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                Row(
                  children: [
                    Image.asset(AppImages.circle),
                    Text(
                      LocalizationKeys.bySigningUp.tr(),
                      style: TextStyle(
                          fontSize: screenWidth * 0.03, //12,
                          color: AppColor.skipTextColor,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      width: screenWidth * 0.01,
                    ),
                    Text(
                      LocalizationKeys.termsOfService.tr(),
                      style: TextStyle(
                          fontSize: screenWidth * 0.03, // 12,
                          color: AppColor.baseColor,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      width: screenWidth * 0.01,
                    ),
                    Text(
                      LocalizationKeys.and.tr(),
                      style: TextStyle(
                          fontSize: screenWidth * 0.03, //12,
                          color: AppColor.skipTextColor,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ).animate().fade(duration: .9.seconds, delay: .5.seconds),
                Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.07),
                  child: Align(
                    alignment: isEnglish(context)
                        ? Alignment.topLeft
                        : Alignment.topRight,
                    child: Text(
                      LocalizationKeys.privacyPolicy.tr(),
                      style: TextStyle(
                          fontSize: screenWidth * 0.03, //12,
                          color: AppColor.baseColor,
                          fontWeight: FontWeight.w500),
                    ).animate().fade(duration: 1.seconds, delay: .55.seconds),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                Padding(
                  padding: isEnglish(context)
                      ? const EdgeInsets.only(left: 20)
                      : const EdgeInsets.only(right: 20),
                  child: Row(
                    children: [
                      Text(
                        LocalizationKeys.alreadyHaveAccount.tr(),
                        style: TextStyle(
                          fontSize: screenWidth * 0.04, //16,
                          fontWeight: FontWeight.w500,
                          color: AppColor.buttonDetailsColor,
                        ),
                      ),
                      GestureDetector(
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
                                              RemoteUserDataSourceImpl(
                                                  dio: widget.dio),
                                          sharedPreferences:
                                              widget.sharedPreferences,
                                        ),
                                      ),
                                    ),
                                    child: LoginPage(
                                      dio: widget.dio,
                                      sharedPreferences:
                                          widget.sharedPreferences,
                                    ),
                                  ),
                                  type: PageTransitionType.fade));
                        },
                        child: Text(
                          LocalizationKeys.logIn.tr(),
                          style: TextStyle(
                            fontSize: screenWidth * 0.04, //16,
                            fontWeight: FontWeight.w500,
                            color: AppColor.buttonColor,
                          ),
                        ),
                      )
                    ],
                  ),
                ).animate().fade(duration: 1.2.seconds, delay: .6.seconds),
                SizedBox(
                  height: screenHeight * 0.04,
                ),
                AppButton(
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      print('Form is valid');
                      Navigator.push(
                        context,
                        PageTransition(
                          child: BlocProvider(
                            create: (context) => RegisterBloc(
                              RegisterUserUseCase(
                                repository: AuthRepositoryImpl(
                                  internetConnectionChecker:
                                      InternetConnectionChecker(),
                                  remoteDataSource:
                                      RemoteUserDataSourceImpl(dio: widget.dio),
                                  sharedPreferences: widget.sharedPreferences,
                                ),
                              ),
                            ),
                            child: PasswordPage(
                              firstName: firstNameController.text,
                              lastName: lastNameController.text,
                              userName: userNameController.text,
                              phone: phoneController.text,
                              birthDate: birthDateController.text,
                              dio: widget.dio,
                              sharedPreferences: widget.sharedPreferences,
                            ),
                          ),
                          type: PageTransitionType.fade,
                        ),
                      );
                    }
                  },
                  text: LocalizationKeys.signUp.tr(),
                  textColor: AppColor.whiteColor,
                  containerColor: AppColor.buttonColor,
                ).animate().fade(duration: 1.4.seconds, delay: .8.seconds),
                SizedBox(
                  height: screenHeight * 0.03,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
