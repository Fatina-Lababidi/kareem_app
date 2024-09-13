import 'package:careem_app_clean/core/functions/language.dart';
import 'package:careem_app_clean/core/network/network_connection.dart';
import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/resources/string.dart';
import 'package:careem_app_clean/core/widgets/back_row_widget.dart';
import 'package:careem_app_clean/features/bicycles/presentation/view/widgets/bikeSpecificationColWidget.dart';
import 'package:careem_app_clean/features/bicycles/presentation/view/widgets/bikeSpecificationsRow_widget.dart';
import 'package:careem_app_clean/features/favourite/data/datasource/remote_add_fav_datasource.dart';
import 'package:careem_app_clean/features/favourite/data/datasource/remote_delete_fav_datasource.dart';
import 'package:careem_app_clean/features/favourite/data/datasource/remote_getFavByClientId_datasource.dart';
import 'package:careem_app_clean/features/favourite/data/repositories/add_fav_repo_imp.dart';
import 'package:careem_app_clean/features/favourite/domain/usecase/add_favourite_usecase.dart';
import 'package:careem_app_clean/features/favourite/presentation/addFav_bloc/add_favourite_bloc.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BuildBikePageWidget extends StatelessWidget {
  final double price;
  final String model;
  final int size;
  final String photoPath;
  final String type;
  final String note;
  final int id;
  final Dio dio;
  final SharedPreferences sharedPreferences;
  const BuildBikePageWidget(
      {super.key,
      required this.price,
      required this.model,
      required this.size,
      required this.photoPath,
      required this.type,
      required this.note,
      required this.id,
      required this.dio,
      required this.sharedPreferences});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenHeight = MediaQuery.sizeOf(context).height;

    return BlocProvider(
      create: (context) => AddFavouriteBloc(
        AddFavouriteUsecase(
          bicycleId: id,
          favouriteRepo: AddFavRepoImp(
            remoteDeleteFavDatasource: RemoteDeleteFavDatasource(dio: dio),
            remoteGetfavbyclientidDatasource:
                RemoteGetfavbyclientidDatasource(dio: dio),
            sharedPreferences: sharedPreferences,
            remoteAddFavDatasource: RemoteAddFavDatasource(dio: dio),
            networkConnection: NetworkConnection(
              internetConnectionChecker: InternetConnectionChecker(),
            ),
          ),
        ),
      ),
      child: Builder(
        builder: (context) {
          return BlocConsumer<AddFavouriteBloc, AddFavouriteState>(
            listener: (context, state) {
              if (state is AddFavouriteSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: AppColor.baseColor,
                    duration: const Duration(seconds: 1),
                    content: Text(LocalizationKeys.success.tr())));
              } else if (state is AddFavouriteFailure) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(state.message),
                  duration: const Duration(seconds: 1),
                ));
              }
            },
            builder: (context, state) {
              return Scaffold(
                backgroundColor: AppColor.whiteColor,
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: isEnglish(context)
                          ? EdgeInsets.only(
                              left: screenWidth * 0.02,
                            )
                          : EdgeInsets.only(
                              right: screenWidth * 0.02,
                            ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const BackWidget(),
                              BlocBuilder<AddFavouriteBloc, AddFavouriteState>(
                                builder: (context, state) {
                                  if (state is AddFavouriteLoding) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        width: screenWidth * 0.04, //10,
                                        height: screenWidth * 0.04,
                                        child: const CircularProgressIndicator(
                                          color: AppColor.snackbarOfflineColor,
                                        ),
                                      ),
                                    );
                                  } else {
                                    return IconButton(
                                      onPressed: () {
                                        context
                                            .read<AddFavouriteBloc>()
                                            .add(AddFav());
                                      },
                                      icon: Icon(Icons.favorite_sharp,
                                          color: AppColor.snackbarOfflineColor,
                                          size: screenWidth * 0.07 //30,
                                          ),
                                    );
                                  }
                                },
                              )
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.02 //20,
                              ),
                          Text(
                            model,
                            style: TextStyle(
                              color: AppColor.buttonDetailsColor,
                              fontSize: screenWidth * 0.06, //24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            type,
                            style: TextStyle(
                                fontSize: screenWidth * 0.035, //14,
                                color: AppColor.skipTextColor,
                                fontWeight: FontWeight.w500),
                          ),
                          Center(
                            child: Image.network(
                              errorBuilder: (context, error, stackTrace) {
                                return Column(
                                  children: [
                                    Image.asset('assets/images/bicycle.png',
                                        width: screenWidth * 0.2 //50,
                                        ),
                                    Text('enable to fetch '), //! localization
                                  ],
                                );
                              },
                              'https://$photoPath',
                              width: screenWidth * 0.5, //200,
                              colorBlendMode: BlendMode.colorBurn,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.04 //5,
                              ),
                          Text(
                            LocalizationKeys.specifications.tr(),
                            style: TextStyle(
                                fontSize: screenWidth * 0.045, //18,
                                fontWeight: FontWeight.w500,
                                color: AppColor.buttonDetailsColor),
                          ), //! Localization
                          SizedBox(height: screenHeight * 0.02 //5,
                              ),
                          BikeSpecificationsRow(
                              screenWidth: screenWidth,
                              model: model,
                              price: price,
                              type: type,
                              size: size),
                          // bikeSpecificationsRow(
                          //     screenWidth, model, price, type, size),
                          SizedBox(
                            height: screenHeight * 0.02, //5,
                          ),
                          Text(LocalizationKeys.bicycleFeatures.tr(),
                              style: TextStyle(
                                  fontSize: screenWidth * 0.045, //18,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.buttonDetailsColor)),
                          SizedBox(height: screenHeight * 0.02 //5,
                              ),
                          BikeSpecificationColWidget(
                              title: LocalizationKeys.type.tr(),
                              text: type,
                              icon: Icons.pedal_bike_outlined),
                          SizedBox(height: screenHeight * 0.015 // 10,
                              ),
                          BikeSpecificationColWidget(
                              title: LocalizationKeys.model.tr(),
                              text: model,
                              icon: Icons.numbers),
                          SizedBox(
                            height: screenHeight * 0.015, // 10,
                          ),
                          BikeSpecificationColWidget(
                            title: LocalizationKeys.price.tr(),
                            text: price.toString(),
                            icon: Icons.attach_money_rounded,
                          ),
                          SizedBox(
                            height: screenHeight * 0.015, //10,
                          ),
                          BikeSpecificationColWidget(
                              title: LocalizationKeys.size.tr(),
                              text: size.toString(),
                              icon: Icons.confirmation_number_sharp),

                          SizedBox(
                            height: screenHeight * 0.05,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
