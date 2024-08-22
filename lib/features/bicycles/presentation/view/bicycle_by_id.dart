import 'package:careem_app_clean/core/functions/language.dart';
import 'package:careem_app_clean/core/network/network_connection.dart';
import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/resources/string.dart';
import 'package:careem_app_clean/core/widgets/back_row_widget.dart';
import 'package:careem_app_clean/features/bicycles/presentation/view/widgets/bikeSpecificationColWidget.dart';
import 'package:careem_app_clean/features/bicycles/presentation/view/widgets/bikeSpecificationRoWidget.dart';
import 'package:careem_app_clean/features/favourite/data/datasource/remote_add_fav_datasource.dart';
import 'package:careem_app_clean/features/favourite/data/datasource/remote_getFavByClientId_datasource.dart';
import 'package:careem_app_clean/features/favourite/data/repositories/add_fav_repo_imp.dart';
import 'package:careem_app_clean/features/favourite/domain/usecase/add_favourite_usecase.dart';
import 'package:careem_app_clean/features/favourite/presentation/addFav_bloc/add_favourite_bloc.dart';
import 'package:careem_app_clean/features/hub/presentation/view/hub_page.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BicycleByIdPage extends StatelessWidget {
  final int id;
  final double price;
  final String model;
  final int size;
  final String photoPath;
  final String type;
  final String note;
  final Dio dio;
  final SharedPreferences sharedPreferences;

  const BicycleByIdPage({
    super.key,
    required this.id,
    required this.price,
    required this.model,
    required this.size,
    required this.photoPath,
    required this.type,
    required this.note,
    required this.dio,
    required this.sharedPreferences,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenHeight = MediaQuery.sizeOf(context).height;
    return BlocProvider(
      create: (context) => AddFavouriteBloc(AddFavouriteUsecase(
          bicycleId: id,
          favouriteRepo: AddFavRepoImp(
            remoteGetfavbyclientidDatasource: RemoteGetfavbyclientidDatasource(dio: dio),
              sharedPreferences: sharedPreferences,
              remoteAddFavDatasource: RemoteAddFavDatasource(dio: dio),
              networkConnection: NetworkConnection(
                  internetConnectionChecker: InternetConnectionChecker())))),
      child: Builder(builder: (context) {
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
                            Padding(
                              padding:
                                  EdgeInsets.only(top: screenHeight * 0.01),
                              child: const BackWidget(),
                            ),
                            BlocBuilder<AddFavouriteBloc, AddFavouriteState>(
                              builder: (context, state) {
                                if (state is AddFavouriteLoding) {
                                  return CircularProgressIndicator(
                                    color: AppColor.snackbarOfflineColor,
                                  );
                                } else {
                                  return IconButton(
                                      onPressed: () {
                                        context.read<AddFavouriteBloc>()
                                          ..add(AddFav());
                                      },
                                      icon: Icon(
                                        Icons.favorite_sharp,
                                        color: AppColor.snackbarOfflineColor,
                                      ));
                                }
                              },
                            )
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.02 //20,
                            ),
                        Text(
                          model,
                          style: const TextStyle(
                            color: AppColor.buttonDetailsColor,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          type,
                          style: const TextStyle(
                              fontSize: 14,
                              color: AppColor.skipTextColor,
                              fontWeight: FontWeight.w500),
                        ),
                        Center(
                          child: Image.network(
                            // loadingBuilder: (context, child, loadingProgress) {
                            //   return const CircularProgressIndicator(
                            //     color: AppColor.baseColor,
                            //   );
                            // },
                            errorBuilder: (context, error, stackTrace) {
                              return Column(
                                children: [
                                  Image.asset(
                                    'assets/images/bicycle.png',
                                    width: 50,
                                  ),
                                  Text('enable to fetch '), //! localization
                                ],
                              );
                            },
                            'https://$photoPath',
                            width: 200,
                            colorBlendMode: BlendMode.colorBurn,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.04 //5,
                            ),
                        Text(
                          LocalizationKeys.specifications.tr(),
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: AppColor.buttonDetailsColor),
                        ), //! Localization
                        SizedBox(height: screenHeight * 0.02 //5,
                            ),
                        bikeSpecificationsRow(screenWidth),
                        SizedBox(
                          height: screenHeight * 0.02, //5,
                        ),
                        Text(LocalizationKeys.bicycleFeatures.tr(),
                            style: const TextStyle(
                                fontSize: 18,
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
                        SizedBox(height: screenHeight * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: screenHeight * 0.07, //50,
                              width: screenWidth * 0.4, //170,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColor.buttonColor,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  LocalizationKeys.bookLater.tr(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: AppColor.buttonColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: screenWidth * 0.03,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        child: HubPage(
                                          sharedPreferences: sharedPreferences,
                                          dio: dio,
                                        ),
                                        type: PageTransitionType.fade));
                              },
                              child: Container(
                                height: screenHeight * 0.07, //50,
                                width: screenWidth * 0.4, //170,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: AppColor.buttonColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    LocalizationKeys.rideNow.tr(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: AppColor.whiteColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        //tow buttons : what the diffrence between them ?
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
      }),
    );
  }

  bikeSpecificationsRow(double screenWidth) {
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
