import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/resources/string.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  const SearchBarWidget(
      {super.key,
      required this.controller,
      required this.onChanged,
      required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 11,
      left: 20,
      right: 20,
      child: Container(
        height: 39,
        margin: const EdgeInsets.symmetric(horizontal: 40),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppColor.categoriesContainerColor,
          borderRadius: BorderRadius.circular(5),
          boxShadow: const [
            BoxShadow(
              color: AppColor.baseColor,
              blurRadius: 4.0,
              spreadRadius: 1.0,
            ),
          ],
        ),
        child: TextField(
          cursorColor: AppColor.baseColor,
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: LocalizationKeys.whereWouldYouGo.tr(),
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.close),
              onPressed: onClear,
            ),
          ),
        ),
      ),
    );
  }
}
