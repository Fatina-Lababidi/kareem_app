import 'package:careem_app_clean/core/resources/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class SearchResultcontainerWidget extends StatelessWidget {
  final List<dynamic> searchResults;
  final MapController mapController;
  final ValueNotifier<List<Marker>> markers;
  final TextEditingController searchController;
  final Function() onClearSearch;

  const SearchResultcontainerWidget(
      {super.key,
      required this.searchResults,
      required this.mapController,
      required this.markers,
      required this.searchController,
      required this.onClearSearch});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: AppColor.whiteColor,
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
                mapController.move(
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
                onClearSearch();
              },
            );
          },
        ),
      ),
    );
  }
}
