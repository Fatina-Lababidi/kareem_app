import 'package:flutter/material.dart';
import 'package:careem_app/core/resources/color.dart';

class AppTextFormField extends StatelessWidget {
  AppTextFormField({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.hintText,
    this.borderColor = AppColor.skipTextColor,
    this.textColor = Colors.black,
    this.hintColor = Colors.grey,
    this.containerColor = Colors.white,
    this.onChanged,
    this.validator,
    this.controller,
    this.obscurepassword = false,
    this.secretPasswordIcon,
   // this.focusNode,
   // this.enable =true,
  });

  final double screenWidth;
  final double screenHeight;
  final String hintText;
  final Color? borderColor;
  final Color textColor;
  final Color hintColor;
  final Color containerColor;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  bool obscurepassword;
  IconButton? secretPasswordIcon;
 // FocusNode? focusNode;
//bool enable;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
       // focusNode:focusNode ,
         //enabled: enable,
        obscureText: obscurepassword,
        cursorColor: AppColor.skipTextColor,
        controller: controller,
        onChanged: onChanged,
        validator: validator,
        style: TextStyle(
          fontSize: screenWidth * 0.04, // 16,
          color: textColor,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: screenWidth * 0.04, // 16,
            color: hintColor,
          ),
          filled: true,
          fillColor: containerColor,
          contentPadding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.025, horizontal: 12.0),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:
                BorderSide(color: borderColor ?? AppColor.skipTextColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
                color: borderColor ?? AppColor.skipTextColor, width: 2.0),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.red, width: 2.0),
          ),
          suffixIcon: secretPasswordIcon,
        ),
      ),
    );
  }
}
