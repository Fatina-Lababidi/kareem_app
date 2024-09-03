import 'package:careem_app_clean/core/network/network_connection.dart';
import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/resources/string.dart';
import 'package:careem_app_clean/core/widgets/failure_widget.dart';
import 'package:careem_app_clean/features/favourite/data/datasource/remote_add_fav_datasource.dart';
import 'package:careem_app_clean/features/favourite/data/datasource/remote_getFavByClientId_datasource.dart';
import 'package:careem_app_clean/features/favourite/data/repositories/add_fav_repo_imp.dart';
import 'package:careem_app_clean/features/favourite/domain/usecase/get_fav_by_clientId.dart';
import 'package:careem_app_clean/features/favourite/presentation/favByClientId_bloc/fav_by_client_id_bloc.dart';
import 'package:careem_app_clean/features/favourite/presentation/widgets/favourite_card_widget.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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
    return BlocProvider(
      create: (context) => FavByClientIdBloc(GetFavByClientidUsecase(
        favouriteRepo: AddFavRepoImp(
            networkConnection: NetworkConnection(
                internetConnectionChecker: InternetConnectionChecker()),
            sharedPreferences: sharedPreferences,
            remoteGetfavbyclientidDatasource:
                RemoteGetfavbyclientidDatasource(dio: dio),
            remoteAddFavDatasource: RemoteAddFavDatasource(dio: dio)),
      ))
        ..add(GetFavByClientid()),
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
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('success'),
                        backgroundColor: AppColor.baseColor,
                      ));
                    } else if (state is FavByClientIdFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(state.message),
                        backgroundColor: AppColor.snackbarOfflineColor,
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
                                screenHeight: screenHeight,
                                bike: bike,
                                dio: dio,
                                sharedPreferences: sharedPreferences,
                                screenWidth: screenWidth);
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
