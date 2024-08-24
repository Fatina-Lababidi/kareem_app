import 'dart:developer';
import 'package:careem_app_clean/core/network/network_connection.dart';
import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/resources/string.dart';
import 'package:careem_app_clean/features/bicycles/presentation/view/categories_page.dart';
import 'package:careem_app_clean/features/hub/data/datasource/remote_all_hub.dart';
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
  const MapPage(
      {super.key, required this.dio, required this.sharedPreferences});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final markers = ValueNotifier<List<Marker>>([]);
  final List<dynamic> searchResults = [];
  late final MapController _mapController;
  LatLng _initialPosition = LatLng(33.5138, 36.2765); //damascus
  LatLng? _savedPosition;
  bool isSearchBarVisible = false;
  bool _locationCheck = false;
  bool _isMapReady = false;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _loadSavedLocation();
    //  _initalizeBloc();
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
    if(_isMapReady)
    _mapController.move(position, 14);
  }

  Future<void> _checkAndRequestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        _savedLocation(LatLng(0.0, 0.0));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Location permission denied.'),
          ),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _savedLocation(LatLng(0.0, 0.0));
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
            content: Text('Failed to get location.'),
            //set defualt one?
          ),
        );
        _mapController.move(_initialPosition, 15);
        _savedLocation(LatLng(0.0, 0.0));
      }
    }
  }

// //? saved new current location to use it in hub:

  Future<void> _savedLocation(LatLng position) async {
    // final prefs = await SharedPreferences.getInstance();

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

  List<Marker> _buildHubMarkers(List<PlaceEntity> places) {
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
        child: Icon(Icons.pedal_bike, color: Colors.red, size: 40),
      );
    }).toList();
  }

  void _updateHubMarkers(List<PlaceEntity> places) {
    markers.value = _buildHubMarkers(places);
  }

  @override
  Widget build(BuildContext context) {
    final double screenwidth = MediaQuery.sizeOf(context).width;
    return BlocProvider(
        create: (context) {
          final lat = _savedPosition?.latitude ?? _initialPosition.latitude;
          final lng = _savedPosition?.longitude ?? _initialPosition.longitude;
          return AllHubBloc(AllHubUsecase(
              hubRepo: AllHubRepoImp(
                  remoteAllHubDataSource:
                      RemoteAllHubDataSource(dio: widget.dio),
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
                              onLongPress: (point, latLng) =>
                                  _addMarker(latLng),
                              //  onMapReady: () {},
                            ),
                            children: [
                              TileLayer(
                                urlTemplate:
                                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                userAgentPackageName: 'com.example.app',
                              ),
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
                                        state.allHubEntity.body))
                            ],
                          ),
                        ),
                        if (searchResults.isNotEmpty)
                          Expanded(
                            child: Container(
                              color: Colors.white,
                              child: ListView.separated(
                                shrinkWrap: true,
                                separatorBuilder: (context, index) =>
                                    const Divider(),
                                itemCount: searchResults.length,
                                itemBuilder: (context, index) {
                                  final result = searchResults[index];
                                  return ListTile(
                                    title: Text(result['display_name']),
                                    onTap: () {
                                      final lat = double.parse(result['lat']);
                                      final lon = double.parse(result['lon']);
                                      _mapController.move(
                                        LatLng(lat, lon),
                                        15.0,
                                      );
                                      markers.value = [
                                        Marker(
                                          point: LatLng(lat, lon),
                                          child: const Icon(Icons.location_pin,
                                              color: Colors.red, size: 40),
                                        ),
                                      ];
                                      setState(() {
                                        searchResults.clear();
                                        _searchController.clear();
                                      });
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (isSearchBarVisible) _buildSearchBar(),
                    Positioned(
                      top: 10,
                      left: screenwidth / 1.2,
                      right: 0,
                      child: _buildSearchAndLocationBar(),
                    ),
                  ],
                );
              },
            ),
          ),
        ));
  }

  Widget _buildSearchAndLocationBar() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isSearchBarVisible = !isSearchBarVisible;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4.0,
                  spreadRadius: 1.0,
                ),
              ],
            ),
            child: const Icon(Icons.search, color: Colors.black),
          ),
        ),
        SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            log('location');
            await _checkAndRequestPermission();
            // setState(() {
            //   // _updateMapWithCurrentPosition();
            // });
          },
          child: Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: AppColor.whiteColor,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4.0,
                  spreadRadius: 1.0,
                ),
              ],
            ),
            child: Icon(Icons.location_on, color: Colors.black),
          ),
        ),
        SizedBox(
          height: 8,
        ),
        GestureDetector(
          onTap: () {
            // Navigate to bicycle categories page
            Navigator.push(
                context,
                PageTransition(
                    child: CategoriesPage(
                      sharedPreferences: widget.sharedPreferences,
                      dio:widget.dio,
                    ),
                    type: PageTransitionType.fade));
          },
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4.0,
                  spreadRadius: 1.0,
                ),
              ],
            ),
            child: const Icon(Icons.pedal_bike_outlined, color: Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Positioned(
      top: 11,
      left: 20,
      right: 20,
      child: Container(
        height: 39,
        margin: EdgeInsets.symmetric(horizontal: 40),
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Color(0xffE2F5ED),
          borderRadius: BorderRadius.circular(5),
          boxShadow: const [
            BoxShadow(
              color: Color(0xff08B783),
              blurRadius: 4.0,
              spreadRadius: 1.0,
            ),
          ],
        ),
        child: TextField(
          cursorColor: AppColor.baseColor,
          controller: _searchController,
          onChanged: _searchPlaces,
          decoration: InputDecoration(
            hintText: LocalizationKeys.whereWouldYouGo.tr(),
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _searchController.clear();
                  searchResults.clear();
                  isSearchBarVisible = false;
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  void _addMarker(LatLng point) {
    markers.value = [
      Marker(
        point: point,
        child: Icon(Icons.location_pin, color: Colors.blue, size: 40),
      ),
    ];
  }
}
