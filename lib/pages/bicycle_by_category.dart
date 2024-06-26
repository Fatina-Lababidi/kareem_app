import 'package:careem_app/bloc/bicycle_by_category/bicycle_by_category_bloc.dart';
import 'package:careem_app/core/resources/color.dart';
import 'package:careem_app/core/resources/string.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BicycleByCategoryPage extends StatelessWidget {
  final double latitude;
  final double longitude;
  final String category;
  const BicycleByCategoryPage(
      {super.key,
      required this.latitude,
      required this.longitude,
      required this.category});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double screenWidth = MediaQuery.sizeOf(context).width;
    return BlocProvider(
      create: (context) => BicycleByCategoryBloc()
        ..add(FetchBicycles(
            latitude: latitude, longitude: longitude, category: category)),
      child: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: AppColor.whiteColor,
          body: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      size: 16,
                      Icons.arrow_back_ios_new_outlined,
                      color: AppColor.contentSecondaryTextColor,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    LocalizationKeys.back.tr(),
                    style: const TextStyle(
                        color: AppColor.contentSecondaryTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                  const Spacer(),
                ],
              ),
              Text(
                LocalizationKeys.availableCarsForRide.tr(),
                style: const TextStyle(
                    fontSize: 24,
                    color: AppColor.buttonDetailsColor,
                    fontWeight: FontWeight.w600),
              ),
              Expanded(
                child:
                    BlocBuilder<BicycleByCategoryBloc, BicycleByCategoryState>(
                  builder: (context, state) {
                    switch (state) {
                      case BicycleSuccess():
                        return Column(
                          children: [
                            Text(
                              '${state.bicycleResponse.body.length} ' +
                                  LocalizationKeys.carsFound.tr(),
                              style: TextStyle(
                                  color: AppColor.skipTextColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: state.bicycleResponse.body.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    padding: EdgeInsets.all(10),
                                    height: screenHeight * 0.2, //170,
                                    width: screenWidth * 0.9, //363,
                                    decoration: BoxDecoration(
                                        color:
                                            AppColor.categoriesContainerColor,
                                        border: Border.all(
                                            color: AppColor.baseColor),
                                        borderRadius: BorderRadius.circular(8)),
                                    margin: EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          state.bicycleResponse.body[index]
                                              .modelPrice.model,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  AppColor.buttonDetailsColor),
                                        ),
                                        Text(state
                                                .bicycleResponse.body[index].id
                                                .toString() +
                                            '  ' +
                                            state.bicycleResponse.body[index]
                                                .note),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Container(
                                            width: screenWidth * 0.85, //340,
                                            height: screenHeight * 0.06, //54,
                                            decoration: BoxDecoration(
                                                color: AppColor
                                                    .categoriesContainerColor,
                                                border: Border.all(
                                                    color: AppColor.baseColor),
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: Center(
                                              child: Text(
                                                LocalizationKeys.viewCarList
                                                    .tr(),
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColor.baseColor),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 0,
                                        )
                                      ],
                                    ),
                                  ).animate().scaleXY(
                                      duration: (0.2 * index).seconds,
                                      delay: .3.seconds);
                                },
                              ),
                            ),
                           // SizedBox(height:10),
                          ],
                        );
                      case BicycleFailed():
                        return Text(state.message);
                      default:
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColor.baseColor,
                          ),
                        );
                    }
                  },
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
