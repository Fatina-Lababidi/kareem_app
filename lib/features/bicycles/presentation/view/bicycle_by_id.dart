import 'package:careem_app_clean/core/functions/language.dart';
import 'package:careem_app_clean/core/network/network_connection.dart';
import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/resources/string.dart';
import 'package:careem_app_clean/core/widgets/back_row_widget.dart';
import 'package:careem_app_clean/core/widgets/failure_widget.dart';
import 'package:careem_app_clean/features/bicycles/data/datasource/remote_bicycle_by_category_datasource.dart';
import 'package:careem_app_clean/features/bicycles/data/datasource/remote_bicycle_by_id_datasource.dart';
import 'package:careem_app_clean/features/bicycles/data/datasource/remote_categories_datasource.dart';
import 'package:careem_app_clean/features/bicycles/data/repositories/categories_repo_imp.dart';
import 'package:careem_app_clean/features/bicycles/domain/usecase/bicycle_by_id_usecase.dart';
import 'package:careem_app_clean/features/bicycles/presentation/bicycleById_bloc/bicycle_by_id_bloc.dart';
import 'package:careem_app_clean/features/bicycles/presentation/view/widgets/bikeSpecificationColWidget.dart';
import 'package:careem_app_clean/features/bicycles/presentation/view/widgets/bikeSpecificationRoWidget.dart';
import 'package:careem_app_clean/features/favourite/data/datasource/remote_add_fav_datasource.dart';
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

class BicycleByIdPage extends StatelessWidget {
  final int id;
  final double? price;
  final String? model;
  final int? size;
  final String? photoPath;
  final String? type;
  final String? note;
  final Dio dio;
  final SharedPreferences sharedPreferences;

  const BicycleByIdPage({
    super.key,
    required this.id,
    this.price,
    this.model,
    this.size,
    this.photoPath,
    this.type,
    this.note,
    required this.dio,
    required this.sharedPreferences,
  });

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double screenWidth = MediaQuery.sizeOf(context).width;
    return BlocProvider(
      create: (context) => BicycleByIdBloc(
        BicycleByIdUsecase(
          categoriesRepo: CategoriesRepoImp(
              remoteBicycleByCategoryDatasource:
                  RemoteBicycleByCategoryDatasource(dio: dio),
              remoteCategoriesDatasource: RemoteCategoriesDatasource(dio: dio),
              remoteBicycleByIdDatasource:
                  RemoteBicycleByIdDatasource(dio: dio),
              networkConnection: NetworkConnection(
                  internetConnectionChecker: InternetConnectionChecker())),
          id: id,
        ),
      ),
      child: Builder(
        builder: (context) {
          if (price == null ||
              model == null ||
              size == null ||
              photoPath == null ||
              type == null ||
              note == null) {
            context.read<BicycleByIdBloc>().add(GetBicycleById());
          }

          return BlocBuilder<BicycleByIdBloc, BicycleByIdState>(
            builder: (context, state) {
              if (state is BicycleByIdLoding) {
                return Scaffold(
                  backgroundColor: AppColor.whiteColor,
                  body: SafeArea(
                    child: Column(
                      children: [
                        Padding(
                          padding: isEnglish(context)
                              ? EdgeInsets.only(
                                  right: screenWidth * 0.02,
                                  left: screenHeight * 0.01)
                              : EdgeInsets.only(
                                  right: screenWidth * 0.02,
                                  top: screenHeight * 0.01),
                          child: const BackWidget(),
                        ),
                        const Expanded(
                          child: Center(
                              child: CircularProgressIndicator(
                            color: AppColor.baseColor,
                          )),
                        ),
                      ],
                    ),
                  ),
                );
              // } else if (state is BicycleByIdFailure) {
              //   return Scaffold(
              //     backgroundColor: AppColor.whiteColor,
              //     body: SafeArea(
              //       child: Column(
              //         children: [
              //           Padding(
              //             padding: isEnglish(context)
              //                 ? EdgeInsets.only(
              //                     right: screenWidth * 0.02,
              //                     top: screenHeight * 0.0125)
              //                 : EdgeInsets.only(
              //                     left: screenWidth * 0.02,
              //                     top: screenHeight * 0.0125),
              //             child: const BackWidget(),
              //           ),
              //           Text(state.message),
              //           Expanded(
              //             child: Center(child: FailureUi(
              //               onTap: () {
              //                 context
              //                     .read<BicycleByIdBloc>()
              //                     .add(GetBicycleById());
              //               },
              //             )),
              //           ),
              //         ],
              //       ),
              //     ),
              //   );
              } else if (state is BicycleByIdSuccess) {
                final bike = state.bicycleByIdEntity.body;
                return buildBicyclePage(
                  context,
                  bike.modelPrice.price,
                  bike.modelPrice.model,
                  bike.size,
                  bike.photoPath,
                  bike.type,
                  bike.note,
                );
              } else if (state is BicycleByIdInitial) {
                return buildBicyclePage(
                  context,
                  price ?? 0.0,
                  model ?? '',
                  size ?? 0,
                  photoPath ?? '',
                  type ?? '',
                  note ?? '',
                );
              } else {
                return Scaffold(
                  body: SafeArea(
                    child: Column(
                      children: [
                        Padding(
                          padding: isEnglish(context)
                              ? EdgeInsets.only(
                                  right: screenWidth * 0.02,
                                  top: screenHeight * 0.0125)
                              : EdgeInsets.only(
                                  right: screenWidth * 0.02,
                                  top: screenHeight * 0.0125),
                          child: const BackWidget(),
                        ),
                        Expanded(
                          child: Center(child: FailureUi(
                            onTap: () {
                              context
                                  .read<BicycleByIdBloc>()
                                  .add(GetBicycleById());
                            },
                          )),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }

  Widget buildBicyclePage(BuildContext context, double price, String model,
      int size, String photoPath, String type, String note) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenHeight = MediaQuery.sizeOf(context).height;

    return BlocProvider(
      create: (context) => AddFavouriteBloc(
        AddFavouriteUsecase(
          bicycleId: id,
          favouriteRepo: AddFavRepoImp(
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
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    backgroundColor: AppColor.baseColor,
                    content: Text('success')));
              } else if (state is AddFavouriteFailure) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message)));
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
                                    return SizedBox(
                                      width: screenWidth * 0.03, //10,
                                      height: screenWidth * 0.03,
                                      child: const CircularProgressIndicator(
                                        color: AppColor.snackbarOfflineColor,
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
                          bikeSpecificationsRow(
                              screenWidth, model, price, type, size),
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

  bikeSpecificationsRow(
      double screenWidth, String model, double price, String type, int size) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: screenWidth * 0.01 // 5,
              ),
          BikeSpecificationRoWidget(
              text: type, icon: Icons.pedal_bike_outlined),
          SizedBox(width: screenWidth * 0.02 //10,
              ),
          BikeSpecificationRoWidget(text: model, icon: Icons.numbers),
          SizedBox(
            width: screenWidth * 0.02, //10,
          ),
          BikeSpecificationRoWidget(
            text: price.toString(),
            icon: Icons.attach_money_rounded,
          ),
          SizedBox(width: screenWidth * 0.02 //10,
              ),
          BikeSpecificationRoWidget(
              text: size.toString(), icon: Icons.confirmation_number_sharp),
          SizedBox(width: screenWidth * 0.01 // 5,
              ),
        ],
      ),
    );
  }
}
