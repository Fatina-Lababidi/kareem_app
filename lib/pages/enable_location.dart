import 'package:careem_app/core/functions/permissions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  MapController controller = MapController(
    initPosition: GeoPoint(latitude: 33.5138, longitude: 36.2765), //syria
    areaLimit: BoundingBox(
      east: 10.4922941,
      north: 47.8084648,
      south: 45.817995,
      west: 5.9559113,
    ),
  );

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestPermissionAndShowDialog();
      //?if we call this without the widget it might be too early,so it save to call it like these
    });
  }

  Future<void> _requestPermissionAndShowDialog() async {
    bool granted = await PermissionService.requestLocationPermission(context);
    print(granted);
    if (granted) {
      await controller.enableTracking();
      GeoPoint? currentLocation = await getCurrentLocation();
      if (currentLocation != null) {
        print(
            'Current location: ${currentLocation.latitude}, ${currentLocation.longitude}');

        await controller.goToLocation(currentLocation);
      } else {
        print('Failed to get current location.');
      }
      // Navigator.of(context)
      //     .push(MaterialPageRoute(builder: (context) => const WelcomePage()));
    } else {
      // Navigator.of(context)
      //     .push(MaterialPageRoute(builder: (context) => const WelcomePage()));
    }
  }

  Future<GeoPoint?> getCurrentLocation() async {
    try {
      GeoPoint currentLocation = await controller.myLocation();
      return currentLocation;
    } catch (e) {
      print('Error getting current location: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: OSMFlutter(

          //mapIsLoading:
          controller: controller,
          osmOption: OSMOption(
            userTrackingOption: const UserTrackingOption(
              enableTracking: true,
              unFollowUser: false,
            ),
            zoomOption: const ZoomOption(
              initZoom: 8,
              minZoomLevel: 3,
              maxZoomLevel: 19,
              stepZoom: 1.0,
            ),
            userLocationMarker: UserLocationMaker(
              personMarker: const MarkerIcon(
                icon: Icon(
                  Icons.location_history_rounded,
                  color: Colors.red,
                  size: 48,
                ),
              ),
              directionArrowMarker: const MarkerIcon(
                icon: Icon(
                  Icons.double_arrow,
                  size: 48,
                ),
              ),
            ),
            roadConfiguration: const RoadOption(
              roadColor: Colors.yellowAccent,
            ),
          )),
    );
  }
}
