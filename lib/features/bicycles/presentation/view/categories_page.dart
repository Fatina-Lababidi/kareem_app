import 'package:careem_app_clean/core/network/network_connection.dart';
import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/resources/string.dart';
import 'package:careem_app_clean/core/widgets/appBar_widget.dart';
import 'package:careem_app_clean/core/widgets/failure_widget.dart';
import 'package:careem_app_clean/features/bicycles/data/datasource/remote_bicycle_by_category_datasource.dart';
import 'package:careem_app_clean/features/bicycles/data/datasource/remote_bicycle_by_id_datasource.dart';
import 'package:careem_app_clean/features/bicycles/data/datasource/remote_categories_datasource.dart';
import 'package:careem_app_clean/features/bicycles/data/repositories/categories_repo_imp.dart';
import 'package:careem_app_clean/features/bicycles/domain/usecase/categories_usecase.dart';
import 'package:careem_app_clean/features/bicycles/presentation/categories_bloc/categories_bloc.dart';
import 'package:careem_app_clean/features/bicycles/presentation/view/widgets/categories_content.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoriesPage extends StatelessWidget {
  final int? id;
  final String? name;
  final Dio dio;
  final SharedPreferences sharedPreferences;
  final String? hubDescription;
  const CategoriesPage({
    super.key,
    required this.dio,
    required this.sharedPreferences,
    this.id,
    this.name,
    this.hubDescription,
  });

  // final Map<String, String> categoryImages = {
  //   "Road_bikes": AppImages.roadBikes,
  //   "Mountain_bikes": AppImages.mountainBikes,
  //   "Hybrid_bikes": AppImages.hybridBikes,
  //   "e_bikes": AppImages.eBikes,
  // };
  // final Map<String, String> categoriesText = {
  //   "Road_bikes": LocalizationKeys.roadBikes.tr(),
  //   "Mountain_bikes": LocalizationKeys.mountainBikes.tr(),
  //   "Hybrid_bikes": LocalizationKeys.hybridBikes.tr(),
  //   "e_bikes": LocalizationKeys.eBikes.tr(),
  // };
  // final String defaultImage = AppImages.defaultBike;
  // final String defultText = LocalizationKeys.defaultBike.tr();
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double screenWidth = MediaQuery.sizeOf(context).width;
    return BlocProvider(
      create: (context) => CategoriesBloc(GetCategoriesUsecase(
          categoriesRepo: CategoriesRepoImp(
              remoteBicycleByIdDatasource:
                  RemoteBicycleByIdDatasource(dio: dio),
              remoteBicycleByCategoryDatasource:
                  RemoteBicycleByCategoryDatasource(dio: dio),
              remoteCategoriesDatasource: RemoteCategoriesDatasource(dio: dio),
              networkConnection: NetworkConnection(
                  internetConnectionChecker: InternetConnectionChecker()))))
        ..add(GetCategories()),
      child: Scaffold(
        backgroundColor: AppColor.whiteColor,
        body: SafeArea(
          child: BlocListener<CategoriesBloc, CategoriesState>(
            listener: (context, state) {
              if (state is CategoriesFailure) {
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
                AppBarWidget(
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  textTitle: LocalizationKeys.allBicycleCategories.tr(),
                ).animate().fade(duration: .2.seconds, delay: .1.seconds),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    LocalizationKeys.allBicycleCategories.tr(),
                    style: TextStyle(
                        fontSize: screenWidth * 0.07, //24,
                        fontWeight: FontWeight.w600,
                        color: AppColor.buttonDetailsColor),
                  ),
                ).animate().fade(duration: .3.seconds, delay: .15.seconds),
                const SizedBox(height: 20),
                BlocBuilder<CategoriesBloc, CategoriesState>(
                    builder: (context, state) {
                  if (state is CategoriesSuccess) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: GridView.builder(
                          itemCount: state.categories.body.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemBuilder: (context, index) {
                            final category = state.categories.body[index];
                            // final imageUrl =
                            //     categoryImages[category] ?? defaultImage;
                            // final text = categoriesText[category] ?? defultText;
                            return CategoriesContainer(
                              sharedPreferences: sharedPreferences,
                              dio: dio,
                              categoryKey: category,
                              catergory: category,
                              id: id,
                              name: name,
                              hubDescription: hubDescription,
                            ).animate().fade(
                                duration: (0.2 * index).seconds,
                                delay: .2.seconds);
                          },
                        ),
                      ),
                    );
                  } else if (state is CategoriesFailure) {
                    print(state.message);
                    return Expanded(
                      child: FailureUi(
                        onTap: () {
                          context.read<CategoriesBloc>().add(GetCategories());
                        },
                      ),
                    );
                  } else {
                    return const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColor.baseColor,
                        ),
                      ),
                    );
                  }
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
