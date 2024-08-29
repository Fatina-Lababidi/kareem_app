import 'package:careem_app_clean/core/network/network_connection.dart';
import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/widgets/back_row_widget.dart';
import 'package:careem_app_clean/core/widgets/failure_widget.dart';
import 'package:careem_app_clean/features/hub/data/datasource/remote_all_hub.dart';
import 'package:careem_app_clean/features/hub/data/datasource/remote_hub_content_datasource.dart';
import 'package:careem_app_clean/features/hub/data/repositories/all_hub_repo_impl.dart';
import 'package:careem_app_clean/features/hub/domain/usecase/all_hub_usecase.dart';
import 'package:careem_app_clean/features/hub/presentation/allHub_bloc/all_hub_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: screenWidth * 0.02, top: screenHeight * 0.01),
                    child: const BackWidget(),
                  ),
                  const Expanded(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(right: 50),
                        child: Text(
                          'Hubs',
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColor.settingsTitleColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
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
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 25),
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                  //  color: AppColor.categoriesContainerColor,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppColor.circularRipple2,
                                    width: 1,
                                  )),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(Icons.pedal_bike_outlined,color: AppColor.baseColor,),
                                  Text(
                                    item.name,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
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
                      return Center(
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
