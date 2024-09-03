import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/features/bicycles/presentation/view/bicycle_by_id.dart';
import 'package:careem_app_clean/features/favourite/domain/entities/add_fav_response_entity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavouriteCardWidget extends StatelessWidget {
  const FavouriteCardWidget({
    super.key,
    required this.screenHeight,
    required this.bike,
    required this.dio,
    required this.sharedPreferences,
    required this.screenWidth,
  });

  final double screenHeight;
  final BicyclesWithNullPhotoEntity bike;
  final Dio dio;
  final SharedPreferences sharedPreferences;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenHeight * 0.12,
      padding: const EdgeInsets.all(3),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColor.circularRipple2,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              PageTransition(
                  child: BicycleByIdPage(
                    id: bike.id,
                    dio: dio,
                    sharedPreferences: sharedPreferences,
                  ),
                  type: PageTransitionType.fade));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(
                  Icons.pedal_bike,
                  color: AppColor.snackbarOfflineColor,
                  size: screenWidth * 0.08,
                ),
                SizedBox(
                  width: screenWidth * 0.02,
                ),
                Text(
                  bike.modelPrice.model,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    //delete event
                  },
                  icon: Icon(
                    Icons.stop_circle,
                    color: AppColor.snackbarFaildColor,
                    size: screenWidth * 0.08,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  "${bike.type}|${bike.modelPrice.price}|${bike.note}",
                  style: TextStyle(
                      fontSize: screenWidth * 0.025, //10,
                      color: AppColor.skipTextColor,
                      fontWeight: FontWeight.bold),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
