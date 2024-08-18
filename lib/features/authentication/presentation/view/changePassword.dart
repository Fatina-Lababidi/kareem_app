import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/resources/string.dart';
import 'package:careem_app_clean/core/widgets/app_button.dart';
import 'package:careem_app_clean/core/widgets/app_textFormField.dart';
import 'package:careem_app_clean/features/authentication/presentation/changePassword_bloc/change_password_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({
    super.key,
  });

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newpasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool obscureCurrentpassword = true;
  bool obscureNewpassword = true;
  bool obscureConfirmpassword = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newpasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double screenWidth = MediaQuery.sizeOf(context).width;
    return BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
      listener: (context, state) {
        if (state is ChangePasswordSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColor.baseColor,
            ),
          );
          //  Navigator to the next page
          Navigator.pop(context);
          // Navigator.push(
          //     context,
          //     PageTransition(
          //         child: const NextPage(), type: PageTransitionType.fade));
        } else if (state is ChangePasswordFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColor.snackbarFaildColor,
            ),
          );
        } else if (state is ChangePasswordOffline) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('offline'),
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
                        )
                            .animate()
                            .fade(duration: .2.seconds, delay: .1.seconds),
                        SizedBox(
                          height: screenHeight * 0.04,
                        ),
                        Text(
                          LocalizationKeys.changePasswordTitle.tr(),
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

                        // SizedBox(
                        //   height: screenHeight * 0.03,
                        // ),

                        AppTextFormField(
                          //focusNode: _passwordFocusNode,
                          obscurepassword: obscureCurrentpassword,
                          secretPasswordIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                obscureCurrentpassword =
                                    !obscureCurrentpassword;
                              });
                            },
                            icon: obscureCurrentpassword == false
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
                          controller: _currentPasswordController,
                        )
                            .animate()
                            .fade(duration: .5.seconds, delay: .25.seconds),
                        SizedBox(
                          height: screenHeight * 0.02,
                        ),
                        AppTextFormField(
                          //focusNode: _passwordFocusNode,
                          obscurepassword: obscureNewpassword,
                          secretPasswordIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                obscureNewpassword = !obscureNewpassword;
                              });
                            },
                            icon: obscureNewpassword == false
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
                          controller: _newpasswordController,
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
                            } else if (value != _newpasswordController.text) {
                              return LocalizationKeys.passwordMismatch.tr();
                            }
                            return null;
                          },
                          controller: _confirmPasswordController,
                        )
                            .animate()
                            .fade(duration: .6.seconds, delay: .3.seconds),

                        SizedBox(
                          height: screenHeight * 0.1,
                        ),
                        // Spacer(),
                        BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
                          builder: (context, state) {
                            switch (state) {
                              case ChangePasswordLoading():
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

                                      context.read<ChangePasswordBloc>().add(
                                          ChangeUserPasswordEvent(
                                              currentPassword:
                                                  _currentPasswordController
                                                      .text,
                                              newPassword:
                                                  _newpasswordController.text,
                                              confirmPassword:
                                                  _confirmPasswordController
                                                      .text));
                                    }
                                  },
                                  text: LocalizationKeys.save.tr(),
                                  textColor: AppColor.whiteColor,
                                  containerColor: AppColor.buttonColor,
                                ).animate().fade(
                                    duration: .8.seconds, delay: .4.seconds);
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
