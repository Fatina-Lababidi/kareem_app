import 'dart:developer';
import 'package:careem_app_clean/core/network/network_connection.dart';
import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/widgets/back_row_widget.dart';
import 'package:careem_app_clean/core/widgets/failure_widget.dart';
import 'package:careem_app_clean/features/hub/data/datasource/remote_all_hub.dart';
import 'package:careem_app_clean/features/hub/data/repositories/all_hub_repo_impl.dart';
import 'package:careem_app_clean/features/hub/domain/usecase/all_hub_usecase.dart';
import 'package:careem_app_clean/features/hub/presentation/allHub_bloc/all_hub_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HubPage extends StatefulWidget {
  final Dio dio;
  final SharedPreferences sharedPreferences;
  const HubPage(
      {super.key, required this.dio, required this.sharedPreferences});

  @override
  State<HubPage> createState() => _HubPageState();
}

class _HubPageState extends State<HubPage> {
  Future<Map<String, num>?> getLatAndLon() async {
    // final prefs = await SharedPreferences.getInstance();
    final num? lat = widget.sharedPreferences.getDouble('latitude2');
    final num? lng = widget.sharedPreferences.getDouble('longitude2');
    log('Retrieved latitude: $lat');
    log('Retrieved longitude: $lng');
    print('ln2:$lng lat2:$lat');
    if (lat == null || lng == null || lat == 0.0 || lng == 0.0) {
      return null;
    }
    return {
      'latitude': lat,
      'longitude': lng,
    };
  }

  Future<void> _checkAndRequestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Location permission denied.'),
          ),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Text(
                'Location permission is permanently denied.',
                style: TextStyle(fontSize: 10),
              ),
              TextButton(
                onPressed: () {
                  Geolocator.openAppSettings();
                },
                child: Text(
                  'Open Settings',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
      return;
    }
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      try {
        Position position = await Geolocator.getCurrentPosition();
        LatLng(position.latitude, position.longitude);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setDouble('latitude2', position.latitude);
        await prefs.setDouble('longitude2', position.longitude);
        setState(() {});
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to get location.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenHeight = MediaQuery.sizeOf(context).height;
    return FutureBuilder<Map<String, num>?>(
      future: getLatAndLon(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: AppColor.baseColor),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Failed to load location'));
        } else {
          final locationData = snapshot.data;
          return Scaffold(
            backgroundColor: AppColor.whiteColor,
            body: SafeArea(
              child: locationData == null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Location is not enabled. Please enable your location services.',
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _checkAndRequestPermission,
                            child: Text('Enable Location'),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: screenWidth * 0.02,
                              top: screenHeight * 0.01),
                          child: const BackWidget(),
                        ),
                        const Text(
                          'Hub',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: BlocProvider(
                            create: (context) => AllHubBloc(
                              AllHubUsecase(
                                hubRepo: AllHubRepoImp(
                                  remoteAllHubDataSource:
                                      RemoteAllHubDataSource(dio: widget.dio),
                                  networkConnection: NetworkConnection(
                                    internetConnectionChecker:
                                        InternetConnectionChecker(),
                                  ),
                                ),
                                latitude: locationData['latitude']!,
                                longitude: locationData['longitude']!,
                              ),
                            )..add(GetAllHub(
                                lat: locationData['latitude']!,
                                lng: locationData['longitude']!,
                              )),
                            child: BlocBuilder<AllHubBloc, AllHubState>(
                              builder: (context, state) {
                                if (state is AllHubSuccess) {
                                  return ListView.builder(
                                    itemCount: state.allHubEntity.body.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        leading: Text(state
                                            .allHubEntity.body[index].name),
                                      );
                                    },
                                  );
                                } else if (state is AllHubFailure) {
                                  return const FailureUi();
                                } else {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      color: AppColor.baseColor,
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          );
        }
      },
    );
  }
}
