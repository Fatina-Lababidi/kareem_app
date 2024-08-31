import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/resources/string.dart';
import 'package:careem_app_clean/features/bicycles/presentation/view/bicycle_by_id.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BicycleByCategorySuccessUi extends StatelessWidget {
  const BicycleByCategorySuccessUi({
    super.key,
    required this.sharedPreferences,
    required this.dio,
    required this.bicycleByCtegoryEntity,
  });

  final SharedPreferences sharedPreferences;
  final Dio dio;
  final bicycleByCtegoryEntity;

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double screenWidth = MediaQuery.sizeOf(context).width;
    return Column(
      children: [
        Text(
          '${bicycleByCtegoryEntity.body.length} ${LocalizationKeys.bikesFound.tr()}',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: AppColor.skipTextColor,
              fontSize: screenWidth * 0.035, //14,
              fontWeight: FontWeight.w500),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: bicycleByCtegoryEntity.body.length,
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.all(10),
                height: screenHeight * 0.2, //170,
                width: screenWidth * 0.9, //363,
                decoration: BoxDecoration(
                    color: AppColor.categoriesContainerColor,
                    border: Border.all(color: AppColor.baseColor),
                    borderRadius: BorderRadius.circular(8)),
                margin: EdgeInsets.all(screenWidth * 0.025),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bicycleByCtegoryEntity
                                  .body[index].modelPrice.model,
                              style: TextStyle(
                                  fontSize: screenWidth * 0.04, //16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.buttonDetailsColor),
                            ),
                            Text(
                              'id:${bicycleByCtegoryEntity.body[index].id} | size:${bicycleByCtegoryEntity.body[index].size} | price:${bicycleByCtegoryEntity.body[index].modelPrice.price}',
                              style: TextStyle(
                                color: AppColor.skipTextColor,
                                fontSize: screenWidth * 0.035,
                              ),
                            ),
                            Text(
                              'note :${bicycleByCtegoryEntity.body[index].note}',
                              style: TextStyle(
                                fontSize: screenWidth * 0.035,
                              ),
                            )
                          ],
                        ),
                        Image.network(
                          // loadingBuilder: (context,
                          //     child,
                          //     loadingProgress) {
                          //   return const CircularProgressIndicator(
                          //     color:
                          //         AppColor.baseColor,
                          //   );
                          // },
                          errorBuilder: (context, error, stackTrace) {
                            return Column(
                              children: [
                                Image.asset(
                                  'assets/images/bicycle.png',
                                  width: screenWidth * 0.12, //50,
                                ),
                                Text(
                                  'enable to fetch image',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.12,
                                  ),
                                ), //! localization
                              ],
                            );
                          },
                          'https://${bicycleByCtegoryEntity.body[index].photoPath}',
                          width: screenWidth * 0.2, //80,
                          colorBlendMode: BlendMode.colorBurn,
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () {
                          final bike = bicycleByCtegoryEntity.body[index];
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: BicycleByIdPage(
                                    sharedPreferences: sharedPreferences,
                                    dio: dio,
                                    id: bike.id,
                                    price: bike.modelPrice.price,
                                    model: bike.modelPrice.model,
                                    size: bike.size,
                                    photoPath: bike.photoPath,
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
                  ],
                ),
              )
                  .animate()
                  .scaleXY(duration: (0.2 * index).seconds, delay: .3.seconds);
            },
          ),
        ),
      ],
    );
  }
}
