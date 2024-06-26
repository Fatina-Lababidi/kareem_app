import 'package:careem_app/bloc/register_bloc/register_bloc.dart';
import 'package:careem_app/core/resources/color.dart';
import 'package:careem_app/core/resources/string.dart';
import 'package:careem_app/models/request/register_model.dart';
import 'package:careem_app/pages/select_transport_page.dart';
import 'package:careem_app/widgets/app_button.dart';
import 'package:careem_app/widgets/app_textFormField.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

class PasswordPage extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String phone;
  final String birthDate;
  final String userName;
  const PasswordPage(
      {super.key,
      required this.firstName,
      required this.lastName,
      required this.phone,
      required this.birthDate,
      required this.userName});

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
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double screenWidth = MediaQuery.sizeOf(context).width;
    return BlocProvider(
      create: (context) => RegisterBloc(),
      child: Builder(builder: (context) {
        return Scaffold(
            backgroundColor: AppColor.whiteColor,
            body: BlocListener<RegisterBloc, RegisterState>(
              listener: (context, state) {
                if (state is RegisterSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration:const Duration(seconds: 1),
                      backgroundColor: AppColor.buttonColor,
                      content: Text('success'),
                    ),
                  );
                  Navigator.push(
                      context,
                      PageTransition(
                          child: SelectTransportPage(),
                          type: PageTransitionType.fade));
                } else if (state is RegisterFailed) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration:const Duration(seconds: 1),
                      backgroundColor: AppColor.snackbarFaildColor,
                      content: Text(state.message),
                    ),
                  );
                } else if (state is OfflineRegister) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration:const Duration(seconds: 1),
                      backgroundColor: AppColor.snackbarOfflineColor,
                      content: Text(state.message),
                    ),
                  );
                }
              },
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: screenWidth * 0.02),
                        child: GestureDetector(
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
                        ),
                      ).animate().fade(duration: .2.seconds, delay: .1.seconds),
                      SizedBox(
                        height: screenHeight * 0.04,
                      ),
                      Text(
                        LocalizationKeys.setPassword.tr(),
                        style: const TextStyle(
                          color: AppColor.contentSecondaryTextColor,
                          fontSize: 24,
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
                      ).animate().fade(duration: .4.seconds, delay: .2.seconds),
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
                            setState(() {
                              obscureConfirmpassword = !obscureConfirmpassword;
                            });
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
                      ).animate().fade(duration: .6.seconds, delay: .3.seconds),
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
                              style:const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.textColor),
                            )),
                      )
                          .animate()
                          .fade(duration: .7.seconds, delay: .35.seconds),
                      SizedBox(
                        height: screenHeight * 0.25,
                      ),
                      // Spacer(),
                      BlocBuilder<RegisterBloc, RegisterState>(
                        builder: (context, state) {
                          switch (state) {
                            case RegisterLoading():
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: AppColor.baseColor,
                                ),
                              );
                            // case RegisterSuccess():
                            //   return Text(state.message);
                            // case RegisterFailed():
                            //   return Text(state.message);
                            // case OfflineRegister():
                            //   return Text(state.message);
                            default:
                              return AppButton(
                                screenHeight: screenHeight,
                                screenWidth: screenWidth,
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {
                                    print('Form is valid');
                                    //! here we need to send to the back , doing moke !!
                                    context.read<RegisterBloc>().add(
                                          SignUp(
                                            user: RegisterModel(
                                              firstName: widget.firstName,
                                              lastName: widget.lastName,
                                              username: widget.userName,
                                              birthDate: widget.birthDate,
                                              phone: widget.phone,
                                              password:
                                                  _passwordController.text,
                                              confirmPassword:
                                                  _confirmPasswordController
                                                      .text,
                                            ),
                                          ),
                                        );
                                  }
                                },
                                text: LocalizationKeys.register.tr(),
                                textColor: AppColor.whiteColor,
                                containerColor: AppColor.buttonColor,
                              );
                          }
                        },
                      ).animate().fade(duration: .8.seconds, delay: .4.seconds)
                    ],
                  ),
                ),
              ),
            ));
      }),
    );
  }
}
//! confirm password we can't wrote in it , until the password filled ,
