import 'package:careem_app_clean/core/network/network_connection.dart';
import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/resources/string.dart';
import 'package:careem_app_clean/core/widgets/appBar_widget.dart';
import 'package:careem_app_clean/core/widgets/failure_widget.dart';
import 'package:careem_app_clean/features/hub/data/datasource/remote_all_hub.dart';
import 'package:careem_app_clean/features/hub/data/datasource/remote_hub_content_datasource.dart';
import 'package:careem_app_clean/features/hub/data/datasource/remote_reservation_datasource.dart';
import 'package:careem_app_clean/features/hub/data/datasource/remote_reservation_details_datasource.dart';
import 'package:careem_app_clean/features/hub/data/repositories/all_hub_repo_impl.dart';
import 'package:careem_app_clean/features/hub/domain/usecase/all_hub_usecase.dart';
import 'package:careem_app_clean/features/hub/presentation/allHub_bloc/all_hub_bloc.dart';
import 'package:careem_app_clean/features/hub/presentation/view/widgets/hubsContainerWidget.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class HubPage extends StatelessWidget {
  final Dio dio;
  final num lat;
  final num lng;
  const HubPage(
      {super.key, required this.dio, required this.lat, required this.lng});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double screenWidth = MediaQuery.sizeOf(context).width;
    return BlocProvider(
      create: (context) => AllHubBloc(
        AllHubUsecase(
          hubRepo: AllHubRepoImp(
            remoteReservationDetailsDatasource:
                RemoteReservationDetailsDatasource(dio: dio),
            remoteReservationDatasource: RemoteReservationDatasource(dio: dio),
            remoteHubContentDatasource: RemoteHubContentDatasource(dio: dio),
            remoteAllHubDataSource: RemoteAllHubDataSource(dio: dio),
            networkConnection: NetworkConnection(
              internetConnectionChecker: InternetConnectionChecker(),
            ),
          ),
          latitude: lat,
          longitude: lng,
        ),
      )..add(GetAllHub()),
      child: Scaffold(
        backgroundColor: AppColor.whiteColor,
        body: SafeArea(
          child: Column(
            children: [
              AppBarWidget(
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  textTitle: LocalizationKeys.hubs.tr() //'Hubs',
                  ),
              SizedBox(
                height: screenHeight * 0.05,
              ),
              Expanded(
                child: BlocBuilder<AllHubBloc, AllHubState>(
                  builder: (context, state) {
                    if (state is AllHubSuccess) {
                      return ListView.builder(
                        itemCount: state.allHubEntity.body.length,
                        itemBuilder: (context, index) {
                          final item = state.allHubEntity.body[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.pop(context, {
                                'id': item.id,
                                'name': item.name,
                                'description': item.description
                              });
                            },
                            child: HubsContainer(
                                    screenHeight: screenHeight,
                                    screenWidth: screenWidth,
                                    item: item)
                                .animate()
                                .scaleXY(
                                    delay:(0.08*index).seconds,
                                    duration: (0.09* index).seconds),
                          );
                        },
                      );
                    } else if (state is AllHubFailure) {
                      return FailureUi(
                        onTap: () {
                          context.read<AllHubBloc>().add(GetAllHub());
                        },
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColor.baseColor,
                        ),
                      );
                    }
                  },
                ),
              ),
              SizedBox(
                height: screenHeight * 0.02,
              )
            ],
          ),
        ),
      ),
    );
  }
}
