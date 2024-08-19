import 'package:careem_app_clean/core/network/network_connection.dart';
import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/widgets/back_row_widget.dart';
import 'package:careem_app_clean/features/hub/data/datasource/remote_all_hub.dart';
import 'package:careem_app_clean/features/hub/data/repositories/all_hub_repo_impl.dart';
import 'package:careem_app_clean/features/hub/domain/usecase/all_hub_usecase.dart';
import 'package:careem_app_clean/features/hub/presentation/allHub_bloc/all_hub_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HubPage extends StatefulWidget {
  final Dio dio;
  const HubPage({super.key, required this.dio});

  @override
  State<HubPage> createState() => _HubPageState();
}

class _HubPageState extends State<HubPage> {
  Future<Map<String, double>> getLatAndLon() async {
    final prefs = await SharedPreferences.getInstance();
    final double? lat = prefs.getDouble('latitude');
    final double? lng = prefs.getDouble('longitude');

    // Return a map with the lat and lng values
    return {
      'latitude': lat ?? 0.0, // Provide a default value of 0.0 if null
      'longitude': lng ?? 0.0,
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, double>>(
      future: getLatAndLon(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: AppColor.baseColor),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Failed to load location'));
        } else if (snapshot.hasData) {
          final latitude = snapshot.data!['latitude']!;
          final longitude = snapshot.data!['longitude']!;
          print('hub hub');
          return BlocProvider(
            create: (context) => AllHubBloc(AllHubUsecase(
                hubRepo: AllHubRepoImp(
                    remoteAllHubDataSource:
                        RemoteAllHubDataSource(dio: widget.dio),
                    networkConnection: NetworkConnection(
                        internetConnectionChecker:
                            InternetConnectionChecker())),
                latitude: latitude,
                longitude: longitude))
              ..add(GetAllHub(lat: latitude, lng: longitude)),
            child: Scaffold(
              backgroundColor: AppColor.whiteColor,
              body: SafeArea(
                child: Column(
                  children: [
                    const BackWidget(),
                    const Text(
                      'Hub',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: BlocBuilder<AllHubBloc, AllHubState>(
                        builder: (context, state) {
                          if (state is AllHubSuccess) {
                            return ListView.builder(
                              itemCount: state.allHubEntity.body.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading:
                                      Text(state.allHubEntity.body[index].name),
                                );
                              },
                            );
                          } else if (state is AllHubFailure) {
                            return Text('Failure');
                          } else {
                            return Center(
                              child: CircularProgressIndicator(
                                color: AppColor.baseColor,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Center(child: Text('No location data available'));
        }
      },
    );
  }
}
