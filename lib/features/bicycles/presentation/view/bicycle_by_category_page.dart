import 'package:careem_app_clean/core/network/network_connection.dart';
import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/resources/string.dart';
import 'package:careem_app_clean/core/widgets/back_row_widget.dart';
import 'package:careem_app_clean/core/widgets/failure_widget.dart';
import 'package:careem_app_clean/features/bicycles/data/datasource/remote_bicycle_by_category_datasource.dart';
import 'package:careem_app_clean/features/bicycles/data/datasource/remote_categories_datasource.dart';
import 'package:careem_app_clean/features/bicycles/data/repositories/categories_repo_imp.dart';
import 'package:careem_app_clean/features/bicycles/domain/usecase/bicycle_by_category_usecase.dart';
import 'package:careem_app_clean/features/bicycles/presentation/bicylceByCategory_bloc/bicycle_by_category_bloc.dart';
import 'package:careem_app_clean/features/bicycles/presentation/view/bicycle_by_id.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:page_transition/page_transition.dart';

class BicycleByCategoryPage extends StatelessWidget {
  final String category;
  final Dio dio;
  const BicycleByCategoryPage(
      {super.key, required this.category, required this.dio});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double screenWidth = MediaQuery.sizeOf(context).width;
    return BlocProvider(
      create: (context) => BicycleByCategoryBloc(BicycleByCategoryUsecase(
          category: category,
          categoriesRepo: CategoriesRepoImp(
              remoteBicycleByCategoryDatasource:
                  RemoteBicycleByCategoryDatasource(dio: dio),
              remoteCategoriesDatasource: RemoteCategoriesDatasource(dio: dio),
              networkConnection: NetworkConnection(
                  internetConnectionChecker: InternetConnectionChecker()))))
        ..add(GetBicycleByCategor(category: category)),
      child: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: AppColor.whiteColor,
          body: SafeArea(
            child: BlocListener<BicycleByCategoryBloc, BicycleByCategoryState>(
              listener: (context, state) {
                if (state is BicycleByCategoryFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: AppColor.snackbarOfflineColor,
                      content: Text(
                        state.message,
                      ),
                    ),
                  );
                }
              },
              child: Column(
                children: [
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: screenWidth * 0.02),
                      child: const BackWidget()),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    LocalizationKeys.availableBikesForRide.tr(),
                    style: const TextStyle(
                        fontSize: 24,
                        color: AppColor.buttonDetailsColor,
                        fontWeight: FontWeight.w600),
                  ),
                  Expanded(
                    child: BlocBuilder<BicycleByCategoryBloc,
                        BicycleByCategoryState>(
                      builder: (context, state) {
                        switch (state) {
                          case BicycleByCategorySuccess():
                            return Column(
                              children: [
                                Text(
                                  '${state.bicycleByCtegoryEntity.body.length} ${LocalizationKeys.bikesFound.tr()}',
                                  style: const TextStyle(
                                      color: AppColor.skipTextColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: state
                                        .bicycleByCtegoryEntity.body.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        padding: EdgeInsets.all(10),
                                        height: screenHeight * 0.2, //170,
                                        width: screenWidth * 0.9, //363,
                                        decoration: BoxDecoration(
                                            color: AppColor
                                                .categoriesContainerColor,
                                            border: Border.all(
                                                color: AppColor.baseColor),
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        margin: EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      state
                                                          .bicycleByCtegoryEntity
                                                          .body[index]
                                                          .modelPrice
                                                          .model,
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: AppColor
                                                              .buttonDetailsColor),
                                                    ),
                                                    Text(
                                                      'id:${state.bicycleByCtegoryEntity.body[index].id} | size:${state.bicycleByCtegoryEntity.body[index].size} | price:${state.bicycleByCtegoryEntity.body[index].modelPrice.price}',
                                                      style: const TextStyle(
                                                        color: AppColor
                                                            .skipTextColor,
                                                      ),
                                                    ),
                                                    Text(
                                                        'note :${state.bicycleByCtegoryEntity.body[index].note}')
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
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    return Column(
                                                      children: [
                                                        Image.asset(
                                                          'assets/images/bicycle.png',
                                                          width: 50,
                                                        ),
                                                        Text(
                                                            'enable to fetch image'), //! localization
                                                      ],
                                                    );
                                                  },
                                                  'https://${state.bicycleByCtegoryEntity.body[index].photoPath}',
                                                  width: 80,
                                                  colorBlendMode:
                                                      BlendMode.colorBurn,
                                                ),
                                              ],
                                            ),
                                            Align(
                                              alignment: Alignment.center,
                                              child: GestureDetector(
                                                onTap: () {
                                                  final bike = state
                                                      .bicycleByCtegoryEntity
                                                      .body[index];
                                                  Navigator.push(
                                                      context,
                                                      PageTransition(
                                                          child:
                                                              BicycleByIdPage(
                                                                dio: dio,
                                                            id: bike.id,
                                                            price: bike
                                                                .modelPrice
                                                                .price,
                                                            model: bike
                                                                .modelPrice
                                                                .model,
                                                            size: bike.size,
                                                            photoPath:
                                                                bike.photoPath,
                                                            type: bike.type,
                                                            note: bike.note,
                                                          ),
                                                          type:
                                                              PageTransitionType
                                                                  .fade));
                                                },
                                                child: Container(
                                                  width:
                                                      screenWidth * 0.85, //340,
                                                  height:
                                                      screenHeight * 0.06, //54,
                                                  decoration: BoxDecoration(
                                                      color: AppColor
                                                          .categoriesContainerColor,
                                                      border: Border.all(
                                                          color: AppColor
                                                              .baseColor),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8)),
                                                  child: Center(
                                                    child: Text(
                                                      LocalizationKeys
                                                          .viewBikeList
                                                          .tr(),
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: AppColor
                                                              .baseColor),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ).animate().scaleXY(
                                          duration: (0.2 * index).seconds,
                                          delay: .3.seconds);
                                    },
                                  ),
                                ),
                              ],
                            );
                          case BicycleByCategoryFailure():
                            return FailureUi(
                              onTap: () {
                                context.read<BicycleByCategoryBloc>().add(
                                    GetBicycleByCategor(category: category));
                              },
                            );
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
            ),
          ),
        );
      }),
    );
  }
}
