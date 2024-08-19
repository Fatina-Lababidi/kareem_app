import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/features/bicycles/presentation/view/categories_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapPage extends StatefulWidget {
  final Dio dio;
  const MapPage({super.key, required this.dio});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final markers = ValueNotifier<List<Marker>>([]);
  final List<dynamic> searchResults = [];
  late final MapController _mapController;
  Position? _currentPosition;
  bool isSearchBarVisible = false;
  bool _mapInitialized = false;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    // Initialize with default location (0,0)
    _currentPosition = Position(
      latitude: 0.0,
      longitude: 0.0,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0,
      headingAccuracy: 0,
      altitudeAccuracy: 0,
    );
    final prefs = await SharedPreferences.getInstance();
    final double? lat = prefs.getDouble('latitude');
    final double? lng = prefs.getDouble('longitude');
    print('lat:$lat, long: $lng');

    if (lat != null && lng != null && (lat != 0.0 || lng != 0.0)) {
      // Use saved location if valid
      _currentPosition = Position(
        latitude: lat,
        longitude: lng,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        headingAccuracy: 0,
        altitudeAccuracy: 0,
      );
      _updateMapWithCurrentPosition();
    } else {
      // Request permission if location is (0,0)
      await _checkAndRequestPermission();
    }
  }

  Future<void> _checkAndRequestPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Location services are disabled. Please enable them.')),
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      try {
        _currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        _saveLocation();
      } catch (e) {
        print('Failed to get location: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Failed to get location. Default location will be used.')),
        );
        _currentPosition = Position(
          latitude: 0.0,
          longitude: 0.0,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
          headingAccuracy: 0,
          altitudeAccuracy: 0,
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Location permission denied. Default location will be used.')),
      );
      _currentPosition = Position(
        latitude: 0.0,
        longitude: 0.0,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        headingAccuracy: 0,
        altitudeAccuracy: 0,
      );
    }

    _updateMapWithCurrentPosition();
  }

  void _updateMapWithCurrentPosition() {
    if (_mapInitialized && _currentPosition != null) {
      setState(() {
        _mapController.move(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          15.0,
        );

        if (_currentPosition!.latitude != 0.0 &&
            _currentPosition!.longitude != 0.0) {
          markers.value = [
            Marker(
              point: LatLng(
                  _currentPosition!.latitude, _currentPosition!.longitude),
              child: const Icon(Icons.location_pin,
                  color: AppColor.baseColor, size: 50),
            ),
          ];
        }
      });
    }
  }

  void _saveLocation() async {
    final prefs = await SharedPreferences.getInstance();
    double latitude;
    double longitude;
    if (_currentPosition != null) {
      latitude = _currentPosition!.latitude;
      longitude = _currentPosition!.longitude;
    } else {
      latitude = 0.0;
      longitude = 0.0;
    }
    //to use in the next page , rather latitude in this page

    await prefs.setDouble('latitude2', latitude);
    await prefs.setDouble('longitude2', longitude);
    print('Saved Location2: Latitude = $latitude, Longitude = $longitude');
  }

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

  @override
  Widget build(BuildContext context) {
    final double screenwidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: LatLng(
                        _currentPosition?.latitude ?? 0.0,
                        _currentPosition?.longitude ?? 0.0,
                      ),
                      onLongPress: (point, latLng) => _addMarker(latLng),
                      onMapReady: () {
                        // Set the flag to true once the map is rendered
                        setState(() {
                          _mapInitialized = true;
                        });
                        // Ensure the map is updated with the current position
                        _updateMapWithCurrentPosition();
                      },
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
                    ],
                  ),
                ),
                if (searchResults.isNotEmpty)
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: ListView.separated(
                        shrinkWrap: true,
                        separatorBuilder: (context, index) => const Divider(),
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
        ),
      ),
    );
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
            await _checkAndRequestPermission();
            setState(() {
              _updateMapWithCurrentPosition();
            });
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
                      dio: widget.dio,
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
            hintText: 'Where would you go?',
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
