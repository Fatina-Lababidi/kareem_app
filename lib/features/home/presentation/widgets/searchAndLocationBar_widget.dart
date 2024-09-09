import 'package:careem_app_clean/core/resources/color.dart';
import 'package:flutter/material.dart';

class SearchAndLocationBarWidgete extends StatelessWidget {
  final VoidCallback onSearchTap;
  final Future<void> Function() onLocationTap;
  final VoidCallback onCategoriesTap;
  const SearchAndLocationBarWidgete(
      {super.key,
      required this.onSearchTap,
      required this.onLocationTap,
      required this.onCategoriesTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onSearchTap,
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
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onLocationTap,
          child: Container(
            padding: const EdgeInsets.all(8.0),
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
            child: const Icon(Icons.location_on, color: Colors.black),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        GestureDetector(
          onTap: onCategoriesTap,
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
}
