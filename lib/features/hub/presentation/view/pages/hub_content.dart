import 'package:careem_app_clean/core/network/network_connection.dart';
import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/resources/string.dart';
import 'package:careem_app_clean/core/widgets/back_row_widget.dart';
import 'package:careem_app_clean/features/hub/data/datasource/remote_all_hub.dart';
import 'package:careem_app_clean/features/hub/data/datasource/remote_hub_content_datasource.dart';
import 'package:careem_app_clean/features/hub/data/datasource/remote_reservation_datasource.dart';
import 'package:careem_app_clean/features/hub/data/datasource/remote_reservation_details_datasource.dart';
import 'package:careem_app_clean/features/hub/data/repositories/all_hub_repo_impl.dart';
import 'package:careem_app_clean/features/hub/domain/usecase/hub_content_usecase.dart';
import 'package:careem_app_clean/features/hub/presentation/hubContent_bloc/hub_content_bloc.dart';
import 'package:careem_app_clean/features/hub/presentation/view/widgets/bikeInfoCard_forCategory.dart';
import 'package:careem_app_clean/features/hub/presentation/view/widgets/hubContentFailureWidget.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
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
              remoteReservationDetailsDatasource:
                  RemoteReservationDetailsDatasource(dio: dio),
              remoteReservationDatasource:
                  RemoteReservationDatasource(dio: dio),
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
                              Flexible(
                                child: ListView.builder(
                                  itemCount: state.hubContentResponseEntity.body
                                      .bicycleList.length,
                                  itemBuilder: (context, index) {
                                    return BicycleInfoCard(
                                      screenHeight: screenHeight,
                                      screenWidth: screenWidth,
                                      hubContent:
                                          state.hubContentResponseEntity,
                                      index: index,
                                      hubId: hubId,
                                      name: name,
                                      hubDescription: hubDescription,
                                      sharedPreferences: sharedPreferences,
                                      dio: dio,
                                    ).animate().scaleXY(
                                        duration: (0.2 * index).seconds,
                                        delay: .3.seconds);
                                  },
                                ),
                              ),
                            ],
                          );
                        } else if (state is HubContentFailure) {
                          return HubContentFailureWidget(
                            screenWidth: screenWidth,
                            failureMessage: state.message,
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
