import 'package:careem_app_clean/core/network/network_connection.dart';
import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/resources/string.dart';
import 'package:careem_app_clean/core/widgets/failure_widget.dart';
import 'package:careem_app_clean/features/favourite/data/datasource/remote_add_fav_datasource.dart';
import 'package:careem_app_clean/features/favourite/data/datasource/remote_delete_fav_datasource.dart';
import 'package:careem_app_clean/features/favourite/data/datasource/remote_getFavByClientId_datasource.dart';
import 'package:careem_app_clean/features/favourite/data/repositories/add_fav_repo_imp.dart';
import 'package:careem_app_clean/features/favourite/domain/usecase/delete_fav_useCase.dart';
import 'package:careem_app_clean/features/favourite/domain/usecase/get_fav_by_clientId.dart';
import 'package:careem_app_clean/features/favourite/presentation/deleteFav_bloc/delete_favourite_bloc.dart';
import 'package:careem_app_clean/features/favourite/presentation/favByClientId_bloc/fav_by_client_id_bloc.dart';
import 'package:careem_app_clean/features/favourite/presentation/widgets/favourite_card_widget.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavouritePage extends StatelessWidget {
  final SharedPreferences sharedPreferences;
  final Dio dio;

  const FavouritePage({
    super.key,
    required this.sharedPreferences,
    required this.dio,
  });

  @override
  Widget build(BuildContext context) {
    //  final clientId = sharedPreferences.getInt('client_Id') ?? 0;
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double screenWidth = MediaQuery.sizeOf(context).width;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => FavByClientIdBloc(GetFavByClientidUsecase(
            favouriteRepo: AddFavRepoImp(
                remoteDeleteFavDatasource: RemoteDeleteFavDatasource(dio: dio),
                networkConnection: NetworkConnection(
                    internetConnectionChecker: InternetConnectionChecker()),
                sharedPreferences: sharedPreferences,
                remoteGetfavbyclientidDatasource:
                    RemoteGetfavbyclientidDatasource(dio: dio),
                remoteAddFavDatasource: RemoteAddFavDatasource(dio: dio)),
          ))
            ..add(GetFavByClientid()),
        ),
        BlocProvider(
          create: (context) => DeleteFavouriteBloc(
            DeleteFavouriteUsecase(
              favouriteRepo: AddFavRepoImp(
                remoteAddFavDatasource: RemoteAddFavDatasource(dio: dio),
                sharedPreferences: sharedPreferences,
                networkConnection: NetworkConnection(
                    internetConnectionChecker: InternetConnectionChecker()),
                remoteGetfavbyclientidDatasource:
                    RemoteGetfavbyclientidDatasource(dio: dio),
                remoteDeleteFavDatasource: RemoteDeleteFavDatasource(dio: dio),
              ),
            ),
          ),
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColor.whiteColor,
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: screenHeight * 0.03,
                ),
                Text(
                  LocalizationKeys.favourite.tr(),
                  style: TextStyle(
                    fontSize: screenWidth * 0.05, //18,
                    color: AppColor.settingsTitleColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.05,
                ),
                BlocConsumer<FavByClientIdBloc, FavByClientIdState>(
                  listener: (context, state) {
                    if (state is FavByClientIdSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(LocalizationKeys.success.tr()),
                        backgroundColor: AppColor.baseColor,
                        duration: const Duration(seconds: 1),
                      ));
                    } else if (state is FavByClientIdFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(state.message),
                        backgroundColor: AppColor.snackbarOfflineColor,
                        duration: const Duration(seconds: 1),
                      ));
                    }
                  },
                  builder: (context, state) {
                    if (state is FavByClientIdSuccess) {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: state.addFavResponseEntity.length,
                          itemBuilder: (context, index) {
                            final bike =
                                state.addFavResponseEntity[index].bicycle;
                            return FavouriteCardWidget(
                                favId: state.addFavResponseEntity[index].id,
                                screenHeight: screenHeight,
                                bike: bike,
                                dio: dio,
                                sharedPreferences: sharedPreferences,
                                screenWidth: screenWidth).animate().fade(duration: (.1*index).seconds, delay: (0.1*index).seconds);
                          },
                        ),
                      );
                    } else if (state is FavByClientIdFailure) {
                      return Expanded(
                        child: Center(
                          child: FailureUi(
                            onTap: () {
                              context
                                  .read<FavByClientIdBloc>()
                                  .add(GetFavByClientid());
                            },
                          ),
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
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
