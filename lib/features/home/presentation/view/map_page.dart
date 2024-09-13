import 'dart:developer';
import 'package:careem_app_clean/core/functions/language.dart';
import 'package:careem_app_clean/core/network/network_connection.dart';
import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/resources/string.dart';
import 'package:careem_app_clean/features/bicycles/presentation/view/categories_page.dart';
import 'package:careem_app_clean/features/home/presentation/widgets/searchAndLocationBar_widget.dart';
import 'package:careem_app_clean/features/home/presentation/widgets/searchBarWidget.dart';
import 'package:careem_app_clean/features/home/presentation/widgets/searchResultContainer_widget.dart';
import 'package:careem_app_clean/features/hub/data/datasource/remote_all_hub.dart';
import 'package:careem_app_clean/features/hub/data/datasource/remote_hub_content_datasource.dart';
import 'package:careem_app_clean/features/hub/data/datasource/remote_reservation_datasource.dart';
import 'package:careem_app_clean/features/hub/data/datasource/remote_reservation_details_datasource.dart';
import 'package:careem_app_clean/features/hub/data/repositories/all_hub_repo_impl.dart';
import 'package:careem_app_clean/features/hub/domain/entities/all_hub_entity.dart';
import 'package:careem_app_clean/features/hub/domain/usecase/all_hub_usecase.dart';
import 'package:careem_app_clean/features/hub/presentation/allHub_bloc/all_hub_bloc.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:latlong2/latlong.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

//! we have to make sure that the map initalized before the move !!
class MapPage extends StatefulWidget {
  final Dio dio;
  final SharedPreferences sharedPreferences;
  const MapPage({
    super.key,
    required this.dio,
    required this.sharedPreferences,
  });

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final markers = ValueNotifier<List<Marker>>([]);
  final List<dynamic> searchResults = [];
  late final MapController _mapController;
  final LatLng _initialPosition = const LatLng(33.5138, 36.2765); //damascus
  LatLng? _savedPosition;
  bool isSearchBarVisible = false;
  bool _locationCheck = false;
  bool _isMapReady = false;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _loadSavedLocation();
  }

  Future<void> _loadSavedLocation() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    double? lat = widget.sharedPreferences.getDouble('latitude');
    double? lng = widget.sharedPreferences.getDouble('longitude');

    if (lat != null && lng != null && lat != 0.0 && lng != 0.0) {
      _savedPosition = LatLng(lat, lng);
      _moveToPosition(_savedPosition!);
      markers.value = [
        Marker(
          point: LatLng(_savedPosition!.latitude, _savedPosition!.longitude),
          child: const Icon(Icons.location_pin,
              color: AppColor.baseColor, size: 50),
        ),
      ];
      setState(() {
        _locationCheck = true;
      });
    }
  }

  void _moveToPosition(LatLng position) {
    if (_isMapReady) _mapController.move(position, 14);
  }

  Future<void> _checkAndRequestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _savedLocation(const LatLng(0.0, 0.0));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: AppColor.snackbarOfflineColor,
              duration: const Duration(seconds: 1),
              content:
                  Text(LocalizationKeys.locationPermissionDeniedSnackBar.tr())),
        );
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      _savedLocation(const LatLng(0.0, 0.0));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 1),
          backgroundColor: AppColor.snackbarOfflineColor,
          content: Row(
            children: [
              Text(
                LocalizationKeys.locationPermissionPermanentlyDenied.tr(),
                style: const TextStyle(fontSize: 10),
              ),
              TextButton(
                onPressed: () {
                  Geolocator.openAppSettings();
                },
                child: Text(
                  LocalizationKeys.openSettings.tr(),
                  style: const TextStyle(color: AppColor.whiteColor),
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
        LatLng currentPosition = LatLng(position.latitude, position.longitude);
        markers.value = [
          Marker(
            point: LatLng(position.latitude, position.longitude),
            child: const Icon(Icons.location_pin,
                color: AppColor.baseColor, size: 50),
          ),
        ];
        _savedLocation(currentPosition);
        _moveToPosition(currentPosition);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColor.snackbarOfflineColor,
            duration: const Duration(seconds: 1),
            content: Text(LocalizationKeys.failedToGetLocation.tr()),
            //! ?set defualt one? or just move it to the initial point?
          ),
        );
        _mapController.move(_initialPosition, 15);
        _savedLocation(const LatLng(0.0, 0.0));
      }
    }
  }

// //? saved new current location to use it in hub:

  Future<void> _savedLocation(LatLng position) async {
    await widget.sharedPreferences.setDouble('latitude2', position.latitude);
    await widget.sharedPreferences.setDouble('longitude2', position.longitude);
    ;
    log('Saved Location2: Latitude = ${position.latitude}, Longitude = ${position.longitude}');
    setState(() {
      _savedPosition = position;
    });
  }

// //? search :

  Future<void> _searchPlaces(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults.clear();
      });
      return;
    }
    final url =
        'https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=5';
    try {
      final response = await Dio().get(url);
      final data = response.data;

      if (data.isNotEmpty) {
        setState(() {
          searchResults.clear();
          searchResults.addAll(data);
        });
      } else {
        setState(() {
          searchResults.clear();
        });
      }
    } catch (e) {
      print('Failed to load data: $e');
    }
  }

//? for the hubs:
  // int selectedHubCount = 0;
  // LatLng? firstHub;
  List<Marker> _buildHubMarkers(
      List<PlaceEntity> places, BuildContext context) {
    if (_locationCheck == true) {
      markers.value = [
        Marker(
          point: LatLng(_savedPosition!.latitude, _savedPosition!.longitude),
          child: const Icon(Icons.location_pin,
              color: AppColor.baseColor, size: 50),
        ),
      ];
    }
    return places.map((place) {
      return Marker(
        point: LatLng(place.latitude.toDouble(), place.longitude.toDouble()),
        child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                      child: CategoriesPage(
                        id: place.id,
                        name: place.name,
                        hubDescription: place.description,
                        dio: widget.dio,
                        sharedPreferences: widget.sharedPreferences,
                      ),
                      type: PageTransitionType.fade));
              //TODO:
              // ? to draw line:
              //       if (selectedHubCount == 0) {
              //   firstHub = LatLng(place.latitude.toDouble(), place.longitude.toDouble());
              //   selectedHubCount++;
              // } else if (selectedHubCount == 1 && firstHub != null) {
              //   final secondHub = LatLng(place.latitude.toDouble(), place.longitude.toDouble());
              //   _addHubLine(firstHub!, secondHub);
              //   selectedHubCount = 0; // Reset count after drawing the line
              //   firstHub = null;
              //   }},
            },
            child: const Icon(Icons.pedal_bike, color: Colors.red, size: 40)),
      );
    }).toList();
  }

  void _updateHubMarkers(List<PlaceEntity> places) {
    markers.value = _buildHubMarkers(places, context);
  }

  void _addMarker(LatLng point) {
    markers.value = [
      Marker(
        point: point,
        child: const Icon(Icons.location_pin, color: Colors.blue, size: 40),
      ),
    ];
  }

//ToDO:
// to draw line :
  List<Polyline> polyLines = [];

  void _addHubLine(LatLng hub1, LatLng hub2) {
    final polyline =
        Polyline(points: [hub1, hub2], strokeWidth: 4, color: Colors.blue);
    setState(() {
      polyLines = [polyline];
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;

    return BlocProvider(
      create: (context) {
        final lat = _savedPosition?.latitude ?? _initialPosition.latitude;
        final lng = _savedPosition?.longitude ?? _initialPosition.longitude;
        return AllHubBloc(AllHubUsecase(
            hubRepo: AllHubRepoImp(
                remoteReservationDetailsDatasource:
                    RemoteReservationDetailsDatasource(dio: widget.dio),
                remoteReservationDatasource:
                    RemoteReservationDatasource(dio: widget.dio),
                remoteHubContentDatasource:
                    RemoteHubContentDatasource(dio: widget.dio),
                remoteAllHubDataSource: RemoteAllHubDataSource(dio: widget.dio),
                networkConnection: NetworkConnection(
                    internetConnectionChecker: InternetConnectionChecker())),
            latitude: lat,
            longitude: lng))
          ..add(GetAllHub());
      },
      child: Scaffold(
        body: SafeArea(
          child: BlocConsumer<AllHubBloc, AllHubState>(
            listener: (context, state) {
              if (state is AllHubSuccess) {
                _updateHubMarkers(state.allHubEntity.body);
              } else if (state is AllHubFailure) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(state.message),
                  duration:const Duration(seconds: 1),
                  backgroundColor: AppColor.snackbarOfflineColor,
                ));
              }
            },
            builder: (context, state) {
              return Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: FlutterMap(
                          mapController: _mapController,
                          options: MapOptions(
                            onMapReady: () {
                              setState(() {
                                _isMapReady = true;
                              });
                            },
                            initialCenter: _initialPosition,
                            onLongPress: (point, latLng) => _addMarker(latLng),
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.example.app',
                            ),
                            PolylineLayer(polylines: polyLines),
                            ValueListenableBuilder<List<Marker>>(
                              valueListenable: markers,
                              builder: (context, markerList, _) {
                                return MarkerLayer(
                                  markers: markerList,
                                );
                              },
                            ),
                            if (state is AllHubSuccess)
                              MarkerLayer(
                                  markers: _buildHubMarkers(
                                      state.allHubEntity.body, context))
                          ],
                        ),
                      ),
                      if (searchResults.isNotEmpty)
                        SearchResultcontainerWidget(
                            searchResults: searchResults,
                            mapController: _mapController,
                            markers: markers,
                            searchController: _searchController,
                            onClearSearch: () {
                              setState(() {
                                searchResults.clear();
                                _searchController.clear();
                              });
                            })
                    ],
                  ),
                  if (isSearchBarVisible)
                    SearchBarWidget(
                      controller: _searchController,
                      onChanged: _searchPlaces,
                      onClear: () {
                        setState(() {
                          _searchController.clear();
                          searchResults.clear();
                          isSearchBarVisible = false;
                        });
                      },
                    ),
                  Positioned(
                      top: 10,
                      left:isEnglish(context)? screenWidth / 1.2: null,
                      right:isEnglish(context)? 0:screenWidth / 1.2,
                      child: SearchAndLocationBarWidgete(
                        onSearchTap: () {
                          setState(() {
                            isSearchBarVisible = !isSearchBarVisible;
                          });
                        },
                        onLocationTap: () async {
                          log('location');
                          await _checkAndRequestPermission();
                        },
                        onCategoriesTap: () {
                          // Navigate to bicycle categories page
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: CategoriesPage(
                                    sharedPreferences: widget.sharedPreferences,
                                    dio: widget.dio,
                                  ),
                                  type: PageTransitionType.fade));
                        },
                      )),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
