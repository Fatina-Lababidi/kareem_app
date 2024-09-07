import 'dart:developer';
import 'package:careem_app_clean/core/network/network_connection.dart';
import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/resources/string.dart';
import 'package:careem_app_clean/core/widgets/appBar_widget.dart';
import 'package:careem_app_clean/core/widgets/app_button.dart';
import 'package:careem_app_clean/features/hub/data/datasource/remote_all_hub.dart';
import 'package:careem_app_clean/features/hub/data/datasource/remote_hub_content_datasource.dart';
import 'package:careem_app_clean/features/hub/data/datasource/remote_reservation_datasource.dart';
import 'package:careem_app_clean/features/hub/data/datasource/remote_reservation_details_datasource.dart';
import 'package:careem_app_clean/features/hub/data/repositories/all_hub_repo_impl.dart';
import 'package:careem_app_clean/features/hub/domain/entities/reservation_entity.dart';
import 'package:careem_app_clean/features/hub/domain/usecase/reservation_usecase.dart';
import 'package:careem_app_clean/features/hub/presentation/reservation_bloc/reservation_bloc.dart';
import 'package:careem_app_clean/features/hub/presentation/view/pages/hub_page.dart';
import 'package:careem_app_clean/features/hub/presentation/view/widgets/bike_details.dart';
import 'package:careem_app_clean/features/payment/presentation/view/payment_page.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:latlong2/latlong.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

//?? the returned data:
// {
//   "message": "Reservation created, but now it's in PENDING status, Complete payment processing to confirm your reservation",
//   "status": "CREATED",
//   "localDateTime": "2024-09-04T06:31:09.8710505",
//   "body": {
//     "id": 4,
//     "client": "sana",
//     "bicycle": "PUE229",
//     "from": "وزارة التربية",
//     "to": "جامع صلاح الدين",
//     "duration": 1,
//     "startTime": "2024-09-04T04:29:15.319",
//     "endTime": null,
//     "reservationStatus": "PENDING",
//     "price": 900
//   }
// }

//??  to make reservation we need:
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
  DateTime? _selectedStartTime;
  String paymentMethod = "Wallet";
  int toHubId = 0;

  void _confirmReservation() {
    setState(() {
      _selectedStartTime = DateTime.now();
    });
  }

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
                  : BlocProvider(
                      create: (context) => ReservationBloc(ReservationUsecase(
                          hubRepo: AllHubRepoImp(
                              remoteReservationDetailsDatasource:
                                  RemoteReservationDetailsDatasource(
                                      dio: widget.dio),
                              remoteAllHubDataSource:
                                  RemoteAllHubDataSource(dio: widget.dio),
                              networkConnection: NetworkConnection(
                                  internetConnectionChecker:
                                      InternetConnectionChecker()),
                              remoteReservationDatasource:
                                  RemoteReservationDatasource(dio: widget.dio),
                              remoteHubContentDatasource:
                                  RemoteHubContentDatasource(
                                      dio: widget.dio)))),
                      child: BlocListener<ReservationBloc, ReservationState>(
                        listener: (context, state) {
                          if (state is ReservationFailure) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(state.message),
                              backgroundColor: AppColor.snackbarOfflineColor,
                            ));
                          } else if (state is ReservationSuccess) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  Text(state.reservationResponseEntity.message),
                              backgroundColor: AppColor.baseColor,
                            ));
                            //reservationId:  state.reservationResponseEntity.body.id;
                            //TODO:
                            // //? shall we make it navigate to the payment page and then after payment it will came packe to the thanksPage?
                            Navigator.push(
                              context,
                              PageTransition(
                                child: PaymentPage(
                                  reservationId:
                                      state.reservationResponseEntity.body.id,
                                  bikeModel: widget.bikeModel,
                                  photoPath: widget.photoPath,
                                  sharedPreferences: widget.sharedPreferences,
                                  dio: widget.dio,
                                  // message:
                                  //     state.reservationResponseEntity.message,
                                ),
                                type: PageTransitionType.fade,
                              ),
                            );
                          }
                        },
                        child: Column(
                          children: [
                            AppBarWidget(
                              screenWidth: screenWidth,
                              screenHeight: screenHeight,
                              textTitle: LocalizationKeys.requestForRent.tr(),
                            ),
                            SizedBox(
                              height: screenHeight * 0.02,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
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
                            ),
                            SizedBox(
                              height: screenHeight * 0.04,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
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
                                          toHubId = result['id'];
                                          selectedHubName = result['name'];
                                          descriptionText =
                                              result['description'];
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
                                              fontSize:
                                                  screenWidth * 0.04, //16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          descriptionText,
                                          style: TextStyle(
                                              fontSize:
                                                  screenWidth * 0.03, //12,
                                              fontWeight: FontWeight.w400,
                                              color: AppColor.skipTextColor),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: screenHeight * 0.02,
                            ),
                            BikeDetailsForRent(
                                screenWidth: screenWidth,
                                screenHeight: screenHeight,
                                widget: widget),
                            SizedBox(
                              height: screenHeight * 0.02,
                            ),
                            Container(
                              width: screenWidth * 0.89, //360,
                              height: screenHeight * 0.09, //60,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: AppColor.skipTextColor),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                            // SizedBox(
                            //   height: screenHeight * 0.3,
                            // ),
                            Spacer(),
                            BlocBuilder<ReservationBloc, ReservationState>(
                              builder: (context, state) {
                                if (state is ReservationLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      color: AppColor.baseColor,
                                    ),
                                  );
                                } else {
                                  return AppButton(
                                    screenWidth: screenWidth,
                                    screenHeight: screenHeight,
                                    text: 'Confirm Booking',
                                    textColor: AppColor.whiteColor,
                                    containerColor: AppColor.buttonColor,
                                    onTap: () {
                                      if (toHubId != 0) {
                                        _confirmReservation();
                                        final reservation =
                                            ReservationRequestEntity(
                                                bicycleId: widget.bikeId,
                                                fromHubId: widget.hubId,
                                                toHubId: toHubId,
                                                duration:
                                                    _durationNotifier.value,
                                                startTime: _selectedStartTime!,
                                                paymentMethod: paymentMethod);
                                        print(
                                            'Reservation Details:\n Bicycle ID: ${reservation.bicycleId} \n From Hub ID: ${reservation.fromHubId} \n To Hub ID: ${reservation.toHubId} \n Duration: ${reservation.duration}\n Start Time: ${reservation.startTime}\n start time2: ${reservation.startTime.toIso8601String()}, \nPayment Method: ${reservation.paymentMethod}');

                                        context.read<ReservationBloc>().add(
                                            MakeReservation(
                                                requestEntity: reservation));
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content:
                                                    Text('please choose hub')));
                                        setState(() {
                                          selectedTextColor =
                                              AppColor.snackbarFaildColor;
                                        });
                                      }
                                    },
                                  );
                                }
                              },
                            ),
                            SizedBox(
                              height: screenHeight * 0.03,
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          );
        }
      },
    );
  }
}
