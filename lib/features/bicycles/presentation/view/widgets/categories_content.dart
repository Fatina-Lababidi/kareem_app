import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/features/bicycles/presentation/view/bicycle_by_category_page.dart';
import 'package:careem_app_clean/features/hub/presentation/view/hub_content.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoriesContainer extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;
  final String catergory;
  // final String imageUrl;
  final String categoryKey;
  final Dio dio;
  final SharedPreferences sharedPreferences;
  final int? id;
  const CategoriesContainer({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.catergory,
    // required this.imageUrl,
    required this.categoryKey,
    required this.dio,
    required this.sharedPreferences,
    this.id,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print('Hub id:${id.toString()}');
        if (id != null) {
          //hub content page:
          Navigator.push(
              context,
              PageTransition(
                child: HubContentPage(
                  sharedPreferences: sharedPreferences,
                  dio: dio,
                  hubId: id!,
                  categroy: catergory,
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                ),
                type: PageTransitionType.fade,
              ));
        } else {
          Navigator.push(
            context,
            PageTransition(
              child: BicycleByCategoryPage(
                //! we have to get this
                sharedPreferences: sharedPreferences,
                dio: dio,
                category: categoryKey,
                screenHeight: screenHeight,
                screenWidth: screenWidth,
              ),
              type: PageTransitionType.fade,
            ),
          );
        }
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
