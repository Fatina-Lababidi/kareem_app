import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/resources/string.dart';
import 'package:careem_app_clean/features/hub/domain/entities/hub_content_entity.dart';
import 'package:careem_app_clean/features/hub/presentation/view/pages/hub_bicycleById_page.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BicycleInfoCard extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;
  final HubContentResponseEntity hubContent;
  final int index;
  final int hubId;
  final String name;
  final String hubDescription;
  final SharedPreferences sharedPreferences;
  final Dio dio;
  const BicycleInfoCard(
      {super.key,
      required this.screenHeight,
      required this.screenWidth,
      required this.hubContent,
      required this.index,
      required this.hubId,
      required this.name,
      required this.hubDescription,
      required this.sharedPreferences,
      required this.dio});

  @override
  Widget build(BuildContext context) {
    final bike = hubContent.body.bicycleList[index];
    return Container(
      padding: const EdgeInsets.all(10),
      height: screenHeight * 0.25, //170,
      width: screenWidth * 0.9, //363,
      decoration: BoxDecoration(
          color: AppColor.categoriesContainerColor,
          border: Border.all(color: AppColor.baseColor),
          borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.all(screenWidth * 0.025),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment:
        //     MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bike.modelPrice.model,
                      style: TextStyle(
                          fontSize: screenWidth * 0.04, // 16,
                          fontWeight: FontWeight.w500,
                          color: AppColor.buttonDetailsColor),
                    ),
                    Text(
                      '${LocalizationKeys.id.tr()} :${bike.id} | ${LocalizationKeys.size.tr()} :${bike.size} | ${LocalizationKeys.price.tr()} :${bike.modelPrice.price}',
                      style: TextStyle(
                        color: AppColor.skipTextColor,
                        fontSize: screenWidth * 0.035,
                      ),
                    ),
                    Text(
                      '${LocalizationKeys.note.tr()} :${bike.note}',
                      style: TextStyle(
                        color: AppColor.skipTextColor,
                        fontSize: screenWidth * 0.035,
                      ),
                    )
                  ],
                ),
              ),
              Image.network(
                errorBuilder: (context, error, stackTrace) {
                  return Column(
                    children: [
                      Image.asset(
                        'assets/images/bicycle.png',
                        width: screenWidth * 0.12, //50,
                      ),
                      Text('enable to fetch image',
                          style: TextStyle(
                            color: AppColor.snackbarFaildColor,
                            fontWeight: FontWeight.w400,
                            fontSize: screenWidth * 0.025,
                          ) //10),
                          ), //! localization
                    ],
                  );
                },
                'https://${bike.photoPath}', //!! we don't have imgage!
                width: screenWidth * 0.2, //80,
                colorBlendMode: BlendMode.colorBurn,
              ),
            ],
          ),
          SizedBox(
            height: screenHeight * 0.01,
          ),
          Align(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () {
                // final bike =
                //     state.hubContentResponseEntity.body.bicycleList[index];
                print(bike.photoPath);
                Navigator.push(
                    context,
                    PageTransition(
                        child: HubBicyclebyidPage(
                          hubId: hubId,
                          hubName: name,
                          hubDescription: hubDescription,
                          sharedPreferences: sharedPreferences,
                          dio: dio,
                          id: bike.id,
                          price: bike.modelPrice.price,
                          model: bike.modelPrice.model,
                          size: bike.size,
                          photoPath: bike.photoPath.toString(), //!!
                          type: bike.type,
                          note: bike.note,
                        ),
                        type: PageTransitionType.fade));
              },
              child: Container(
                width: screenWidth * 0.85, //340,
                height: screenHeight * 0.06, //54,
                decoration: BoxDecoration(
                    color: AppColor.categoriesContainerColor,
                    border: Border.all(color: AppColor.baseColor),
                    borderRadius: BorderRadius.circular(8)),
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      LocalizationKeys.viewBikeList.tr(),
                      style: TextStyle(
                          fontSize: screenWidth * 0.04, //16,
                          fontWeight: FontWeight.w500,
                          color: AppColor.baseColor),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
