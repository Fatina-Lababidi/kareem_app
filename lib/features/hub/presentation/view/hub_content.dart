import 'package:careem_app_clean/core/network/network_connection.dart';
import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/resources/string.dart';
import 'package:careem_app_clean/core/widgets/back_row_widget.dart';
import 'package:careem_app_clean/core/widgets/failure_widget.dart';
import 'package:careem_app_clean/features/hub/data/datasource/remote_all_hub.dart';
import 'package:careem_app_clean/features/hub/data/datasource/remote_hub_content_datasource.dart';
import 'package:careem_app_clean/features/hub/data/datasource/remote_reservation_datasource.dart';
import 'package:careem_app_clean/features/hub/data/repositories/all_hub_repo_impl.dart';
import 'package:careem_app_clean/features/hub/domain/usecase/hub_content_usecase.dart';
import 'package:careem_app_clean/features/hub/presentation/hubContent_bloc/hub_content_bloc.dart';
import 'package:careem_app_clean/features/hub/presentation/view/hub_bicycleById_page.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HubContentPage extends StatelessWidget {
  final SharedPreferences sharedPreferences;
  final Dio dio;
  final int hubId;
  final String categroy;
  final String name;
  final String hubDescription;
  const HubContentPage({
    super.key,
    required this.dio,
    required this.hubId,
    required this.categroy,
    required this.sharedPreferences,
    required this.name,
    required this.hubDescription,
  });

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double screenWidth = MediaQuery.sizeOf(context).width;
    return BlocProvider(
      create: (context) => HubContentBloc(HubContentUsecase(
          hubRepo: AllHubRepoImp(
            remoteReservationDatasource: RemoteReservationDatasource(dio: dio),
              remoteAllHubDataSource: RemoteAllHubDataSource(dio: dio),
              networkConnection: NetworkConnection(
                  internetConnectionChecker: InternetConnectionChecker()),
              remoteHubContentDatasource: RemoteHubContentDatasource(dio: dio)),
          hubId: hubId,
          category: categroy))
        ..add(GetHubContent()),
      child: BlocListener<HubContentBloc, HubContentState>(
        listener: (context, state) {
          if (state is HubContentFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: AppColor.snackbarOfflineColor,
            ));
          }
        },
        child: Scaffold(
            backgroundColor: AppColor.whiteColor,
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: screenWidth * 0.02, top: screenHeight * 0.012),
                    child: const BackWidget(),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Text(
                    LocalizationKeys.hubContent.tr(),
                    style: TextStyle(
                      fontSize: screenWidth * 0.045, //18,
                      color: AppColor.buttonDetailsColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Expanded(
                    child: BlocBuilder<HubContentBloc, HubContentState>(
                      builder: (context, state) {
                        if (state is HubContentSuccess) {
                          return Column(
                            children: [
                              Text(
                                '${state.hubContentResponseEntity.body.bicycleList.length} ${LocalizationKeys.bikesFound.tr()}',
                                style: TextStyle(
                                    color: AppColor.skipTextColor,
                                    fontSize: screenWidth * 0.035, //14,
                                    fontWeight: FontWeight.w500),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: state.hubContentResponseEntity.body
                                      .bicycleList.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      padding: const EdgeInsets.all(10),
                                      height: screenHeight * 0.2, //170,
                                      width: screenWidth * 0.9, //363,
                                      decoration: BoxDecoration(
                                          color:
                                              AppColor.categoriesContainerColor,
                                          border: Border.all(
                                              color: AppColor.baseColor),
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      margin:
                                          EdgeInsets.all(screenWidth * 0.025),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    state
                                                        .hubContentResponseEntity
                                                        .body
                                                        .bicycleList[index]
                                                        .modelPrice
                                                        .model,
                                                    style: TextStyle(
                                                        fontSize: screenWidth *
                                                            0.04, // 16,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: AppColor
                                                            .buttonDetailsColor),
                                                  ),
                                                  Text(
                                                    'id:${state.hubContentResponseEntity.body.bicycleList[index].id} | size:${state.hubContentResponseEntity.body.bicycleList[index].size} | price:${state.hubContentResponseEntity.body.bicycleList[index].modelPrice.price}',
                                                    style: TextStyle(
                                                      color: AppColor
                                                          .skipTextColor,
                                                      fontSize:
                                                          screenWidth * 0.035,
                                                    ),
                                                  ),
                                                  Text(
                                                    'note :${state.hubContentResponseEntity.body.bicycleList[index].note}',
                                                    style: TextStyle(
                                                      color: AppColor
                                                          .skipTextColor,
                                                      fontSize:
                                                          screenWidth * 0.035,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Image.network(
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Column(
                                                    children: [
                                                      Image.asset(
                                                        'assets/images/bicycle.png',
                                                        width: screenWidth *
                                                            0.12, //50,
                                                      ),
                                                      Text(
                                                          'enable to fetch image',
                                                          style: TextStyle(
                                                            color: AppColor
                                                                .snackbarFaildColor,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize:
                                                                screenWidth *
                                                                    0.025,
                                                          ) //10),
                                                          ), //! localization
                                                    ],
                                                  );
                                                },
                                                'https://${state.hubContentResponseEntity.body.bicycleList[index].photoPath}', //!! we don't have imgage!
                                                width: screenWidth * 0.2, //80,
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
                                                    .hubContentResponseEntity
                                                    .body
                                                    .bicycleList[index];
                                                print(bike.photoPath);
                                                Navigator.push(
                                                    context,
                                                    PageTransition(
                                                        child:
                                                            HubBicyclebyidPage(
                                                          hubId: hubId,
                                                          hubName: name,
                                                          hubDescription:
                                                              hubDescription,
                                                          sharedPreferences:
                                                              sharedPreferences,
                                                          dio: dio,
                                                          id: bike.id,
                                                          price: bike
                                                              .modelPrice.price,
                                                          model: bike
                                                              .modelPrice.model,
                                                          size: bike.size,
                                                          photoPath: bike
                                                              .photoPath
                                                              .toString(), //!!
                                                          type: bike.type,
                                                          note: bike.note,
                                                        ),
                                                        type: PageTransitionType
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
                                                        color:
                                                            AppColor.baseColor),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                child: Center(
                                                  child: Text(
                                                    LocalizationKeys
                                                        .viewBikeList
                                                        .tr(),
                                                    style: TextStyle(
                                                        fontSize: screenWidth *
                                                            0.04, //16,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            AppColor.baseColor),
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
                        } else if (state is HubContentFailure) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FailureUi(
                                onTap: () {
                                  context
                                      .read<HubContentBloc>()
                                      .add(GetHubContent());
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.all(screenWidth * 0.02),
                                child: Text(
                                  state.message,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: screenWidth * 0.04, //15,
                                      color: AppColor.buttonDetailsColor,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                                  .animate()
                                  .fade(duration: .2.seconds, delay: .4.seconds)
                            ],
                          );
                        } else {
                          return const Center(
                              child: CircularProgressIndicator(
                            color: AppColor.baseColor,
                          ));
                        }
                      },
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
