import 'package:careem_app_clean/core/network/network_connection.dart';
import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/resources/string.dart';
import 'package:careem_app_clean/core/widgets/back_row_widget.dart';
import 'package:careem_app_clean/core/widgets/failure_widget.dart';
import 'package:careem_app_clean/features/bicycles/data/datasource/remote_bicycle_by_category_datasource.dart';
import 'package:careem_app_clean/features/bicycles/data/datasource/remote_bicycle_by_id_datasource.dart';
import 'package:careem_app_clean/features/bicycles/data/datasource/remote_categories_datasource.dart';
import 'package:careem_app_clean/features/bicycles/data/repositories/categories_repo_imp.dart';
import 'package:careem_app_clean/features/bicycles/domain/usecase/bicycle_by_category_usecase.dart';
import 'package:careem_app_clean/features/bicycles/presentation/bicylceByCategory_bloc/bicycle_by_category_bloc.dart';
import 'package:careem_app_clean/features/bicycles/presentation/view/widgets/bicycle_by_category_success_ui.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BicycleByCategoryPage extends StatelessWidget {
  final String category;
  final Dio dio;
  final SharedPreferences sharedPreferences;
  final double screenHeight;
  final double screenWidth;
  const BicycleByCategoryPage(
      {super.key,
      required this.category,
      required this.dio,
      required this.sharedPreferences,
      required this.screenHeight,
      required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BicycleByCategoryBloc(BicycleByCategoryUsecase(
          category: category,
          categoriesRepo: CategoriesRepoImp(
              remoteBicycleByIdDatasource:
                  RemoteBicycleByIdDatasource(dio: dio),
              remoteBicycleByCategoryDatasource:
                  RemoteBicycleByCategoryDatasource(dio: dio),
              remoteCategoriesDatasource: RemoteCategoriesDatasource(dio: dio),
              networkConnection: NetworkConnection(
                  internetConnectionChecker: InternetConnectionChecker()))))
        ..add(GetBicycleByCategor()),
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
                  Padding(
                      padding: EdgeInsets.only(
                          left: screenWidth * 0.02, top: screenHeight * 0.01),
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
                            return BicycleByCategorySuccessUi(
                              screenHeight: screenHeight,
                              screenWidth: screenWidth,
                              sharedPreferences: sharedPreferences,
                              dio: dio,
                              bicycleByCtegoryEntity:
                                  state.bicycleByCtegoryEntity,
                            );
                          case BicycleByCategoryFailure():
                            return FailureUi(
                              onTap: () {
                                context
                                    .read<BicycleByCategoryBloc>()
                                    .add(GetBicycleByCategor());
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
