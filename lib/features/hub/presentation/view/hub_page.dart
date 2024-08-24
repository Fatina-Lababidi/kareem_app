import 'dart:developer';
import 'package:careem_app_clean/core/network/network_connection.dart';
import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/resources/string.dart';
import 'package:careem_app_clean/core/widgets/app_button.dart';
import 'package:careem_app_clean/core/widgets/back_row_widget.dart';
import 'package:careem_app_clean/core/widgets/failure_widget.dart';
import 'package:careem_app_clean/features/hub/data/datasource/remote_all_hub.dart';
import 'package:careem_app_clean/features/hub/data/repositories/all_hub_repo_impl.dart';
import 'package:careem_app_clean/features/hub/domain/usecase/all_hub_usecase.dart';
import 'package:careem_app_clean/features/hub/presentation/allHub_bloc/all_hub_bloc.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

//to make reservation we need:
// "bicycleId": 0, we can take it from the privous page >>done
// "fromHubId": 0,
// "toHubId": 0,
// "duration": 0,
// "startTime": "2024-08-23T07:23:11.539Z",
// "endTime": "2024-08-23T07:23:11.539Z",
// "reservationStatus": "string",NOT_STARTED //FINISHED
// "paymentMethod": "Wallet"

class HubPage extends StatefulWidget {
  final Dio dio;
  final SharedPreferences sharedPreferences;
  const HubPage(
      {super.key, required this.dio, required this.sharedPreferences});

  @override
  State<HubPage> createState() => _HubPageState();
}

class _HubPageState extends State<HubPage> {
  String selectedHubName = "Tap to select a hub";
  final ValueNotifier<bool> isExpandedNotifier = ValueNotifier(false);

  Future<Map<String, num>?> getLatAndLon() async {
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
          const SnackBar(
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
              const Text(
                'Location permission is permanently denied.',
                style: TextStyle(fontSize: 10),
              ),
              TextButton(
                onPressed: () {
                  Geolocator.openAppSettings();
                },
                child: const Text(
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
          const SnackBar(
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
          return const Center(
            child: CircularProgressIndicator(color: AppColor.baseColor),
          );
        } else if (snapshot.hasError) {
          return const Center(child: Text('Failed to load location'));
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
                          const Text(
                            'Location is not enabled. Please enable your location services.',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          AppButton(
                            screenHeight: screenHeight,
                            screenWidth: screenWidth,
                            text: 'Enable Location',
                            textColor: AppColor.whiteColor,
                            containerColor: AppColor.buttonColor,
                            onTap: _checkAndRequestPermission,
                          ),
                        ],
                      ),
                    )
                  : BlocProvider(
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
                      )..add(GetAllHub()),
                      child: BlocBuilder<AllHubBloc, AllHubState>(
                        builder: (context, state) {
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: screenWidth * 0.02,
                                        top: screenHeight * 0.01),
                                    child: const BackWidget(),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        LocalizationKeys.requestForRent.tr(),
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: AppColor.settingsTitleColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: screenWidth * 0.06),
                                ],
                              ),
                              HubSelector(
                                isExpandedNotifier: isExpandedNotifier,
                                selectedHubName: selectedHubName,
                                onSelect: (hubName) {
                                  setState(() {
                                    selectedHubName = hubName;
                                    // Collapse the list after selection
                                    isExpandedNotifier.value = false;
                                  });
                                },
                              ),
                              if (state is AllHubFailure) const FailureUi(),
                              // if (state is! AllHubSuccess &&
                              //     state is! AllHubFailure)
                              //   const Center(
                              //     child: CircularProgressIndicator(
                              //         color: AppColor.baseColor),
                              //   ),
                            ],
                          );
                        },
                      ),
                    ),
            ),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    isExpandedNotifier.dispose();
    super.dispose();
  }
}

class HubSelector extends StatelessWidget {
  final ValueNotifier<bool> isExpandedNotifier;
  final String selectedHubName;
  final Function(String) onSelect;

  const HubSelector({
    Key? key,
    required this.isExpandedNotifier,
    required this.selectedHubName,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isExpandedNotifier,
      builder: (context, isExpanded, _) {
        return Column(
          children: [
            GestureDetector(
              onTap: () {
                // Toggle the expanded state
                isExpandedNotifier.value = !isExpanded;
              },
              child: Container(
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  selectedHubName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            if (isExpanded)
              Container(
                height: 200, // Set a fixed height or use other constraints
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                child: BlocBuilder<AllHubBloc, AllHubState>(
                  builder: (context, state) {
                    if (state is AllHubSuccess) {
                      return ListView.builder(
                        itemCount: state.allHubEntity.body.length,
                        itemBuilder: (context, index) {
                          final hubName = state.allHubEntity.body[index].name;
                          return ListTile(
                            title: Text(hubName),
                            onTap: () {
                              // Notify parent about the selection
                              onSelect(hubName);
                            },
                          );
                        },
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}
