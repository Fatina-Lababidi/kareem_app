import 'package:careem_app_clean/core/functions/language.dart';
import 'package:careem_app_clean/core/network/network_connection.dart';
import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/widgets/back_row_widget.dart';
import 'package:careem_app_clean/core/widgets/failure_widget.dart';
import 'package:careem_app_clean/features/bicycles/data/datasource/remote_bicycle_by_category_datasource.dart';
import 'package:careem_app_clean/features/bicycles/data/datasource/remote_bicycle_by_id_datasource.dart';
import 'package:careem_app_clean/features/bicycles/data/datasource/remote_categories_datasource.dart';
import 'package:careem_app_clean/features/bicycles/data/repositories/categories_repo_imp.dart';
import 'package:careem_app_clean/features/bicycles/domain/usecase/bicycle_by_id_usecase.dart';
import 'package:careem_app_clean/features/bicycles/presentation/bicycleById_bloc/bicycle_by_id_bloc.dart';
import 'package:careem_app_clean/features/bicycles/presentation/view/widgets/buildBikePage_widget.dart';
import 'package:dio/dio.dart';
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
                return BuildBikePageWidget(
                    price: bike.modelPrice.price,
                    model: bike.modelPrice.model,
                    size: bike.size,
                    photoPath: bike.photoPath,
                    type: bike.type,
                    note: bike.note,
                    id: id,
                    dio: dio,
                    sharedPreferences: sharedPreferences);
              } else if (state is BicycleByIdInitial) {
                return BuildBikePageWidget(
                    price: price ?? 0.0,
                    model: model ?? '',
                    size: size ?? 0,
                    photoPath: photoPath ?? '',
                    type: type ?? '',
                    note: note ?? '',
                    id: id,
                    dio: dio,
                    sharedPreferences: sharedPreferences);
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
}
