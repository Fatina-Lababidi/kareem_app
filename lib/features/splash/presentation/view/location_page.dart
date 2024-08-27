import 'package:careem_app_clean/features/home/presentation/view/home_page.dart';
import 'package:careem_app_clean/features/splash/presentation/view/welcom_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationPage extends StatefulWidget {
  final Dio dio;
  final SharedPreferences sharedPreferences;
  const LocationPage({
    super.key,
    required this.dio,
    required this.sharedPreferences,
  });

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  Position? _currentPosition;
  @override
  void initState() {
    super.initState();
    _checkPermissionsAndNavigate();
  }

  Future<void> _checkPermissionsAndNavigate() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _navigateToNextPage();
      return;
    }
    //permissions are already granted:
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      _getCurrentPosition();
    } else {
      // request permission:
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        _getCurrentPosition();
      } else if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _navigateToNextPage();
      }
    }
  }

  Future<void> _getCurrentPosition() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      setState(() {
        _currentPosition = position;
      });
      _navigateToNextPage();
    } catch (e) {
      print('failed to get location: $e');
      _navigateToNextPage();
    }
  }

  void _navigateToNextPage() async {
    await _saveLocation();
    Navigator.push(
      context,
      PageTransition(
        child: HomePage(
          dio: widget.dio,
          sharedPreferences: widget.sharedPreferences,
        ),
        // child: WelcomePage(
        //   sharedPreferences: widget.sharedPreferences,
        //   dio: widget.dio,
        // ),
        type: PageTransitionType.fade,
      ),
    );
  }

  Future<void> _saveLocation() async {
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
    await prefs.setDouble('latitude', latitude);
    await prefs.setDouble('longitude', longitude);
    print('Saved Location 1: Latitude = $latitude, Longitude = $longitude');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/map.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ],
      )),
    );
  }
}



//? how to use the store location:

  // Future<void> _loadSavedLocation() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final double? lat = prefs.getDouble('latitude');
  //   final double? lng = prefs.getDouble('longitude');

  //   if (lat != null && lng != null) {
  //     setState(() {
  //       _currentPosition = Position(
  //           latitude: lat,
  //           longitude: lng,
  //           timestamp: DateTime.now(),
  //           accuracy: 0,
  //           altitude: 0,
  //           heading: 0,
  //           speed: 0,
  //           speedAccuracy: 0);
  //       _locationStatus = 'Last saved location: $lat, $lng';
  //     });
  //     print('Loaded Location: Latitude = $lat, Longitude = $lng');
  //   } else {
  //     setState(() {
  //       _locationStatus = 'No saved location available.';
  //     });
  //     print('No saved location found.');
  //   }
  // }
