import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/features/bicycles/presentation/view/bicycle_by_category_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class CategoriesContainer extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;
  final String catergory;
  // final String imageUrl;
  final String categoryKey;
  final Dio dio;
  const CategoriesContainer({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.catergory,
    // required this.imageUrl,
    required this.categoryKey, required this.dio,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
            child: BicycleByCategoryPage(
              //! we have to get this
              dio: dio,
              category: categoryKey,
            ),
            type: PageTransitionType.fade,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColor.categoriesContainerColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColor.baseColor),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Flexible(
            //   child: Image.asset(
            //     imageUrl,
            //     height: screenHeight * 0.15,
            //     fit: BoxFit.contain,
            //   ),
            // ),
            const SizedBox(height: 8),
            Text(
              catergory,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
