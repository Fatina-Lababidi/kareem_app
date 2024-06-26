import 'package:careem_app/core/functions/language.dart';
import 'package:careem_app/core/resources/asset.dart';
import 'package:careem_app/core/resources/color.dart';
import 'package:careem_app/core/resources/string.dart';
import 'package:careem_app/pages/Password_page.dart';
import 'package:careem_app/widgets/app_button.dart';
import 'package:careem_app/widgets/app_textFormField.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:page_transition/page_transition.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});
  final _formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double screenWidth = MediaQuery.sizeOf(context).width;
    bool isEng = isEnglish(context);
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: SingleChildScrollView(
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
                height: screenHeight * 0.02,
              ),
              Padding(
                padding: EdgeInsets.only(left: screenWidth * 0.02),
                child: Align(
                  alignment: isEng ? Alignment.topLeft : Alignment.topRight,
                  child: Text(
                    LocalizationKeys.signUpWithEmailOrPhone.tr(),
                    style: const TextStyle(
                      color: AppColor.contentSecondaryTextColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ).animate().fade(duration: .3.seconds, delay: .15.seconds),
              Padding(
                padding: EdgeInsets.only(left: screenWidth * 0.02),
                child: Align(
                  alignment: isEng ? Alignment.topLeft : Alignment.topRight,
                  child: Text(
                    LocalizationKeys.phoneNumber.tr(),
                    style: const TextStyle(
                      color: AppColor.contentSecondaryTextColor,
                      fontSize: 24,
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
                              colorScheme: ColorScheme.light(
                                  primary: AppColor.baseColor,
                                  onSurface: Colors.black,
                                  onPrimary: AppColor.whiteColor)),
                          child: child!);
                    },
                  );
                  if (pickedDate != null) {
                    birthDateController.text =
                        DateFormat('dd-MM-yyyy', 'en').format(pickedDate);
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
              //! here i need to make country choose // its string
              // AppTextFormField(
              //   screenWidth: screenWidth,
              //   screenHeight: screenHeight,
              //   hintText: LocalizationKeys.phoneNumber.tr(),
              //   textColor: Colors.black,
              //   hintColor: Colors.grey,
              //   containerColor: Colors.white,
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return LocalizationKeys.phoneValidate.tr();
              //     }
              //     return null;
              //   },
              //   controller: phoneController,
              // ).animate().fade(duration: .7.seconds, delay: .4.seconds),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: IntlPhoneField(
                    validator: (value) {
                    if (value == null||value.completeNumber.isEmpty) {
                      return LocalizationKeys.phoneValidate.tr();
                    }
                    return null;
                  },
                  cursorColor: AppColor.skipTextColor,
                  controller: phoneController,
                  decoration: InputDecoration(
                    hintText: LocalizationKeys.phoneNumber.tr(),
                    hintStyle: TextStyle(
                      fontSize: screenWidth * 0.04, // 16,
                      color: Colors.grey,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.025, horizontal: 12.0),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColor.skipTextColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                        const  BorderSide(color: AppColor.skipTextColor, width: 2.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:const BorderSide(color: Colors.red),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:const BorderSide(color: Colors.red, width: 2.0),
                    ),
                    border:const OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                  ),
                  initialCountryCode: 'SY',
                  // onChanged: (phone) {
                  //   print(phone.completeNumber);
                  // },
                ).animate().fade(duration: .8.seconds, delay: .45.seconds),
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              Row(
                children: [
                  Image.asset(AppImages.circle),
                  Text(
                    LocalizationKeys.bySigningUp.tr(),
                    style:const TextStyle(
                        fontSize: 12,
                        color: AppColor.skipTextColor,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Text(
                    LocalizationKeys.termsOfService.tr(),
                    style:const TextStyle(
                        fontSize: 12,
                        color: AppColor.baseColor,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Text(
                    LocalizationKeys.and.tr(),
                    style:const TextStyle(
                        fontSize: 12,
                        color: AppColor.skipTextColor,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ).animate().fade(duration: .9.seconds, delay: .5.seconds),
              Padding(
                padding: EdgeInsets.only(left: screenWidth * 0.07),
                child: Align(
                  alignment: isEng ? Alignment.topLeft : Alignment.topRight,
                  child: Text(
                    LocalizationKeys.privacyPolicy.tr(),
                    style: const TextStyle(
                        fontSize: 12,
                        color: AppColor.baseColor,
                        fontWeight: FontWeight.w500),
                  ).animate().fade(duration: 1.seconds, delay: .55.seconds),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.02,
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
                        child: PasswordPage(
                          firstName: firstNameController.text,
                          lastName: lastNameController.text,
                          userName: userNameController.text,
                          phone: phoneController.text,
                          birthDate: birthDateController.text,
                        ),
                        type: PageTransitionType.fade,
                      ),
                    );
                  }
                },
                text: LocalizationKeys.signUp.tr(),
                textColor: AppColor.whiteColor,
                containerColor: AppColor.buttonColor,
              ).animate().fade(duration: 1.2.seconds, delay: .6.seconds),
              SizedBox(height: screenHeight*0.04,),
            ],
          ),
        ),
      ),
    );
  }
}
