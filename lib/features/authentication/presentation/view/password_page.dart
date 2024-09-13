import 'package:careem_app_clean/core/functions/language.dart';
import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/resources/string.dart';
import 'package:careem_app_clean/core/widgets/app_button.dart';
import 'package:careem_app_clean/core/widgets/app_textFormField.dart';
import 'package:careem_app_clean/core/widgets/back_row_widget.dart';
import 'package:careem_app_clean/features/authentication/data/datasource/remote/remote_user.dart';
import 'package:careem_app_clean/features/authentication/data/repositories/auth_repository_imp.dart';
import 'package:careem_app_clean/features/authentication/domain/entities/user_entity.dart';
import 'package:careem_app_clean/features/authentication/domain/usecases/login_usecase.dart';
import 'package:careem_app_clean/features/authentication/presentation/login_bloc/login_bloc.dart';
import 'package:careem_app_clean/features/authentication/presentation/register_bloc/register_bloc_bloc.dart';
import 'package:careem_app_clean/features/authentication/presentation/view/login_page.dart';
import 'package:careem_app_clean/features/home/presentation/view/home_page.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PasswordPage extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String phone;
  final String birthDate;
  final String userName;
  final Dio dio;
  final SharedPreferences sharedPreferences;

  const PasswordPage({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.birthDate,
    required this.userName,
    required this.dio,
    required this.sharedPreferences,
  });

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool obscurepassword = true;
  bool obscureConfirmpassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double screenWidth = MediaQuery.sizeOf(context).width;
    return BlocConsumer<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(LocalizationKeys.success.tr()),
              backgroundColor: AppColor.baseColor,
                 duration: const Duration(seconds: 1),
            ),
          );
          //  Navigator to the next page
          Navigator.push(
              context,
              PageTransition(
                  child: HomePage(
                    dio: widget.dio,
                    sharedPreferences: widget.sharedPreferences,
                  ),
                  type: PageTransitionType.fade));
        } else if (state is RegisterFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColor.snackbarFaildColor,
                 duration: const Duration(seconds: 1),
            ),
          );
        } else if (state is RegisterOffline) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(LocalizationKeys.thereIsNoInternet.tr()),
              backgroundColor: AppColor.snackbarOfflineColor,
                 duration: const Duration(seconds: 1),
            ),
          );
        }
      },
      builder: (context, state) {
        return Builder(
          builder: (context) {
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
                                    top: screenHeight * 0.01),
                                child: const BackWidget())
                            .animate()
                            .fade(duration: .2.seconds, delay: .1.seconds),
                        SizedBox(
                          height: screenHeight * 0.04,
                        ),
                        Text(
                          LocalizationKeys.setPassword.tr(),
                          style: TextStyle(
                            color: AppColor.contentSecondaryTextColor,
                            fontSize: screenWidth * 0.06, //24,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                            .animate()
                            .fade(duration: .3.seconds, delay: .15.seconds),
                        SizedBox(
                          height: screenHeight * 0.02,
                        ),
                        Text(
                          LocalizationKeys.setYourPassword.tr(),
                          style: TextStyle(
                            fontSize: screenWidth * 0.04, //16,
                            color: AppColor.detailsTextColor,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                            .animate()
                            .fade(duration: .4.seconds, delay: .2.seconds),
                        SizedBox(
                          height: screenHeight * 0.03,
                        ),
                        AppTextFormField(
                          //focusNode: _passwordFocusNode,
                          obscurepassword: obscurepassword,
                          secretPasswordIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                obscurepassword = !obscurepassword;
                              });
                            },
                            icon: obscurepassword == false
                                ? const Icon(Icons.visibility_off)
                                : const Icon(Icons.visibility),
                            color: AppColor.detailsTextColor,
                          ),
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                          hintText: LocalizationKeys.enterYourPassword.tr(),
                          textColor: Colors.black,
                          hintColor: Colors.grey,
                          containerColor: Colors.white,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return LocalizationKeys.passwordValidate.tr();
                            } else if (value.length < 8) {
                              return LocalizationKeys.passwordTooShort.tr();
                            } else if (!RegExp(
                                    r'^(?=.*?[A-Za-z])(?=.*?[0-9]).{8,}$')
                                .hasMatch(value)) {
                              return LocalizationKeys.passwordInvalid.tr();
                            }
                            return null;
                          },
                          controller: _passwordController,
                        )
                            .animate()
                            .fade(duration: .5.seconds, delay: .25.seconds),
                        SizedBox(
                          height: screenHeight * 0.02,
                        ),
                        AppTextFormField(
                          // enable: _passwordController.text.isNotEmpty,
                          obscurepassword: obscureConfirmpassword,
                          secretPasswordIcon: IconButton(
                            onPressed: () {
                              setState(
                                () {
                                  obscureConfirmpassword =
                                      !obscureConfirmpassword;
                                },
                              );
                            },
                            icon: obscureConfirmpassword == false
                                ? const Icon(Icons.visibility_off)
                                : const Icon(Icons.visibility),
                            color: AppColor.detailsTextColor,
                          ),
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                          hintText: LocalizationKeys.confirmPassword.tr(),
                          textColor: Colors.black,
                          hintColor: Colors.grey,
                          containerColor: Colors.white,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return LocalizationKeys.confirmPasswordValidate
                                  .tr();
                            } else if (value != _passwordController.text) {
                              return LocalizationKeys.passwordMismatch.tr();
                            }
                            return null;
                          },
                          controller: _confirmPasswordController,
                        )
                            .animate()
                            .fade(duration: .6.seconds, delay: .3.seconds),
                        SizedBox(
                          height: screenHeight * 0.01,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: screenWidth * 0.04),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              LocalizationKeys
                                  .atleastOneNumberOrSpecialCharacter
                                  .tr(),
                              style: TextStyle(
                                  fontSize: screenWidth * 0.035, //14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.textColor),
                            ),
                          ),
                        )
                            .animate()
                            .fade(duration: .7.seconds, delay: .35.seconds),
                        SizedBox(
                          height: screenHeight * 0.02,
                        ),
                        // Spacer(),
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
                        )
                            .animate()
                            .fade(duration: .8.seconds, delay: .4.seconds),
                        SizedBox(
                          height: screenHeight * 0.04,
                        ),
                        BlocBuilder<RegisterBloc, RegisterState>(
                          builder: (context, state) {
                            switch (state) {
                              case RegisterLoading():
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColor.baseColor,
                                  ),
                                );
                              default:
                                return AppButton(
                                  screenHeight: screenHeight,
                                  screenWidth: screenWidth,
                                  onTap: () async {
                                    if (_formKey.currentState!.validate()) {
                                      print('Form is valid');
                                      //! here we need to send to the back , doing moke !!
                                      final user = UserEntity(
                                        firstName: widget.firstName,
                                        lastName: widget.lastName,
                                        phone: widget.phone,
                                        username: widget.userName,
                                        birthDate: widget.birthDate,
                                        password: _passwordController.text,
                                        confirmPassword:
                                            _confirmPasswordController.text,
                                      );
                                      BlocProvider.of<RegisterBloc>(context)
                                          .add(RegisterUserEvent(user: user));
                                    }
                                  },
                                  text: LocalizationKeys.register.tr(),
                                  textColor: AppColor.whiteColor,
                                  containerColor: AppColor.buttonColor,
                                );
                            }
                          },
                        )
                            .animate()
                            .fade(duration: 1.seconds, delay: .6.seconds),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

//! confirm password we can't wrote in it , until the password filled ,
