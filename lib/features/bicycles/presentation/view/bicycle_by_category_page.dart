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

  const BicycleByCategoryPage({
    super.key,
    required this.category,
    required this.dio,
    required this.sharedPreferences,
  });

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double screenWidth = MediaQuery.sizeOf(context).width;
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
                      padding: isEnglish(context)
                          ? EdgeInsets.only(
                              left: screenWidth * 0.02,
                              top: screenHeight * 0.0125)
                          : EdgeInsets.only(
                              right: screenWidth * 0.02,
                              top: screenHeight * 0.0125),
                      child: const BackWidget()),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  Text(
                    LocalizationKeys.availableBikesForRide.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: screenWidth * 0.06, //24,
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
