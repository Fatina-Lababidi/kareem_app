import 'package:careem_app_clean/core/network/network_connection.dart';
import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/resources/string.dart';
import 'package:careem_app_clean/core/widgets/failure_widget.dart';
import 'package:careem_app_clean/features/bicycles/presentation/view/bicycle_by_id.dart';
import 'package:careem_app_clean/features/favourite/data/datasource/remote_add_fav_datasource.dart';
import 'package:careem_app_clean/features/favourite/data/datasource/remote_getFavByClientId_datasource.dart';
import 'package:careem_app_clean/features/favourite/data/repositories/add_fav_repo_imp.dart';
import 'package:careem_app_clean/features/favourite/domain/usecase/get_fav_by_clientId.dart';
import 'package:careem_app_clean/features/favourite/presentation/favByClientId_bloc/fav_by_client_id_bloc.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:page_transition/page_transition.dart';
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
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: screenHeight * 0.03,
              ),
              Text(
                LocalizationKeys.favourite.tr(),
                style: const TextStyle(
                  fontSize: 18,
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
              }, builder: (context, state) {
                if (state is FavByClientIdSuccess) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: state.addFavResponseEntity.length,
                      itemBuilder: (context, index) {
                        final bike = state.addFavResponseEntity[index].bicycle;

                        return Container(
                            height: screenHeight * 0.095,
                            padding: const EdgeInsets.all(2),
                            margin: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColor.circularRipple2,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        child: BicycleByIdPage(
                                          id: bike.id,
                                          dio: dio,
                                          sharedPreferences: sharedPreferences,
                                        ),
                                        type: PageTransitionType.fade));
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.pedal_bike,
                                        color: AppColor.snackbarOfflineColor,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        bike.modelPrice.model,
                                      ),
                                      const Spacer(),
                                      IconButton(
                                          onPressed: () {
                                            //delete event
                                          },
                                          icon: const Icon(
                                            Icons.stop_circle,
                                            color: AppColor.snackbarFaildColor,
                                          ))
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "${bike.type}|${bike.modelPrice.price}|${bike.note}",
                                        style: const TextStyle(
                                            fontSize: 10,
                                            color: AppColor.skipTextColor,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ));
                      },
                    ),
                  );
                } else if (state is FavByClientIdFailure) {
                  return Expanded(child: Center(child: FailureUi(
                    onTap: () {
                      context.read<FavByClientIdBloc>()
                        ..add(GetFavByClientid());
                    },
                  )));
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
    );
  }
}
