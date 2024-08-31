import 'dart:developer';
import 'package:careem_app_clean/core/functions/language.dart';
import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/resources/string.dart';
import 'package:careem_app_clean/core/widgets/app_button.dart';
import 'package:careem_app_clean/core/widgets/back_row_widget.dart';
import 'package:careem_app_clean/features/hub/presentation/view/hub_page.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

//to make reservation we need:
// {
//   "bicycleId": 0,
//   "fromHubId": 0,
//   "toHubId": 0,
//   "duration": 0,
//   "startTime": "2024-08-29T14:54:50.152Z",
//   "paymentMethod": "Wallet"
// }

class RentPage extends StatefulWidget {
  final Dio dio;
  final SharedPreferences sharedPreferences;
  final int hubId;
  final String hubName;
  final String hubDescription;
  final int bikeId;
  final String photoPath;
  final String bikeModel;
  const RentPage(
      {super.key,
      required this.dio,
      required this.sharedPreferences,
      required this.hubId,
      required this.hubName,
      required this.hubDescription,
      required this.bikeId,
      required this.photoPath,
      required this.bikeModel});

  @override
  State<RentPage> createState() => _RentPageState();
}

class _RentPageState extends State<RentPage> {
  String selectedHubName = "Tap to select a hub";
  String descriptionText = '';
  Color selectedTextColor = AppColor.skipTextColor;
  final ValueNotifier<int> _durationNotifier = ValueNotifier(1);

  void _incrementDuration() {
    _durationNotifier.value++;
  }

  void _decrementDuration() {
    if (_durationNotifier.value > 1) {
      _durationNotifier.value--;
    }
  }

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

  late Future<Map<String, num>?> _locationFuture;

  @override
  void initState() {
    super.initState();
    _locationFuture = getLatAndLon();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double screenWidth = MediaQuery.sizeOf(context).width;

    return FutureBuilder<Map<String, num>?>(
      future: _locationFuture,
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
              child: locationData == null //!!!
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Location is not enabled. Please enable your location services.',
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: screenHeight * 0.02),
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
                  : Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: screenWidth * 0.02,
                                  top: screenHeight * 0.012),
                              child: const BackWidget(),
                            ),
                            Expanded(
                              child: Center(
                                child: Padding(
                                  padding: isEnglish(context)
                                      ? EdgeInsets.only(
                                          right: screenWidth * 0.03,
                                          top: screenHeight * 0.012)
                                      : EdgeInsets.only(
                                          left: screenWidth * 0.03,
                                          top: screenHeight * 0.012),
                                  child: Text(
                                    LocalizationKeys.requestForRent.tr(),
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.045, //18,
                                      fontWeight: FontWeight.w500,
                                      color: AppColor.settingsTitleColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.06),
                          ],
                        ),
                        SizedBox(
                          height: screenHeight * 0.02,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: AppColor.snackbarFaildColor,
                            ),
                            Column(
                              children: [
                                Text(
                                  widget.hubName,
                                  style: TextStyle(
                                      color: AppColor.buttonDetailsColor,
                                      fontSize: screenWidth * 0.04, // 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  widget.hubDescription,
                                  style: TextStyle(
                                      fontSize: screenWidth * 0.04, //12,
                                      fontWeight: FontWeight.w400,
                                      color: AppColor.skipTextColor),
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: screenHeight * 0.04,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: AppColor.baseColor,
                            ),
                            TextButton(
                              onPressed: () async {
                                final result = await Navigator.push(
                                    context,
                                    PageTransition(
                                        child: HubPage(
                                          dio: widget.dio,
                                          lat: locationData['latitude']!,
                                          lng: locationData['longitude']!,
                                        ),
                                        type: PageTransitionType.fade));

                                if (result != null &&
                                    result is Map<String, dynamic>) {
                                  setState(() {
                                    selectedHubName = result['name'];
                                    descriptionText = result['description'];
                                    selectedTextColor =
                                        AppColor.buttonDetailsColor;
                                  });
                                }
                              },
                              child: Column(
                                children: [
                                  Text(
                                    selectedHubName,
                                    style: TextStyle(
                                        color: selectedTextColor,
                                        fontSize: screenWidth * 0.04, //16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    descriptionText,
                                    style: TextStyle(
                                        fontSize: screenWidth * 0.03, //12,
                                        fontWeight: FontWeight.w400,
                                        color: AppColor.skipTextColor),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: screenHeight * 0.02,
                        ),
                        Container(
                          width: screenWidth * 0.89, //360,
                          height: screenHeight * 0.125, //80,
                          decoration: BoxDecoration(
                            color: AppColor.categoriesContainerColor,
                            border: Border.all(color: AppColor.baseColor),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.bikeModel,
                                  style: TextStyle(
                                      color: AppColor.buttonDetailsColor,
                                      fontSize: screenWidth * 0.04, //16,
                                      fontWeight: FontWeight.w500),
                                ),
                                Center(
                                  child: Image.network(
                                    errorBuilder: (context, error, stackTrace) {
                                      return Column(
                                        children: [
                                          Image.asset(
                                            'assets/images/bicycle.png',
                                            width: screenWidth * 0.12,
                                          ),
                                          Text(
                                              'enable to fetch '), //! localization
                                        ],
                                      );
                                    },
                                    'https://${widget.photoPath}',
                                    width: screenWidth * 0.6, //200,
                                    colorBlendMode: BlendMode.colorBurn,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.02,
                        ),
                        Container(
                          width: screenWidth * 0.89, //360,
                          height: screenHeight * 0.09, //60,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColor.skipTextColor),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: _decrementDuration,
                                icon: Icon(Icons.remove),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ValueListenableBuilder<int>(
                                    valueListenable: _durationNotifier,
                                    builder: (context, value, child) {
                                      return Text('$value');
                                    },
                                  ),
                                  Text(
                                    'duration',
                                    style: TextStyle(
                                        color: AppColor.hintColor,
                                        fontSize: screenWidth * 0.04, // 16,
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                              IconButton(
                                  onPressed: _incrementDuration,
                                  icon: const Icon(Icons.add))
                            ],
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
