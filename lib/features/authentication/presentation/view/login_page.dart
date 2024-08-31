import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/resources/string.dart';
import 'package:careem_app_clean/core/widgets/app_button.dart';
import 'package:careem_app_clean/core/widgets/app_textFormField.dart';
import 'package:careem_app_clean/core/widgets/back_row_widget.dart';
import 'package:careem_app_clean/features/authentication/presentation/login_bloc/login_bloc.dart';
import 'package:careem_app_clean/features/home/presentation/view/home_page.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  final Dio dio;
  final SharedPreferences sharedPreferences;

  const LoginPage({
    super.key,
    required this.dio,
    required this.sharedPreferences,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool obscurepassword = true;
  @override
  void dispose() {
    _passwordController.dispose();
    _phoneController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double screenWidth = MediaQuery.sizeOf(context).width;
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(LocalizationKeys.success.tr()),
              backgroundColor: AppColor.baseColor,
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
        } else if (state is LoginFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColor.snackbarFaildColor,
            ),
          );
        } else if (state is LoginOffline) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(LocalizationKeys.offline.tr()),
              backgroundColor: AppColor.snackbarOfflineColor,
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
                          LocalizationKeys.logintitle.tr(),
                          style:  TextStyle(
                            color: AppColor.contentSecondaryTextColor,
                            fontSize:screenWidth*0.06 ,//24,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                            .animate()
                            .fade(duration: .3.seconds, delay: .15.seconds),
                        SizedBox(
                          height: screenHeight * 0.02,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: IntlPhoneField(
                            // initialValue:'0999999999',
                            // autovalidateMode : AutovalidateMode.always,
                            validator: (value) {
                              print('Validator called with value: $value');
                              if (value == null ||
                                  value.completeNumber.isEmpty) {
                                return LocalizationKeys.phoneValidate.tr();
                              }
                              return null;
                            },
                            cursorColor: AppColor.skipTextColor,
                            controller: _phoneController,
                            decoration: InputDecoration(
                              hintText: LocalizationKeys.phoneNumber.tr(),
                              hintStyle: TextStyle(
                                fontSize: screenWidth * 0.04, // 16,
                                color: Colors.grey,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.025,
                                  horizontal: 12.0),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                    color: AppColor.skipTextColor),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                    color: AppColor.skipTextColor, width: 2.0),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Colors.red),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                    color: Colors.red, width: 2.0),
                              ),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(),
                              ),
                            ),
                            initialCountryCode: 'SY',
                            // onChanged: (phone) {
                            //   print(phone.completeNumber);
                            // },
                          )
                              .animate()
                              .fade(duration: .4.seconds, delay: .20.seconds),
                        ),
                        SizedBox(
                          height: screenHeight * 0.02,
                        ),
                        AppTextFormField(
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
                          height: screenHeight * 0.08,
                        ),
                        BlocBuilder<LoginBloc, LoginState>(
                          builder: (context, state) {
                            switch (state) {
                              case LoginLoading():
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

                                      context.read<LoginBloc>().add(
                                          LoginUserEvent(
                                              phone: _phoneController.text,
                                              password:
                                                  _passwordController.text));
                                    }
                                  },
                                  text: LocalizationKeys.register.tr(),
                                  textColor: AppColor.whiteColor,
                                  containerColor: AppColor.buttonColor,
                                ).animate().fade(
                                    duration: .7.seconds, delay: .3.seconds);
                            }
                          },
                        ),
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
