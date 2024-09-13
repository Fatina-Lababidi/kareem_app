import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/features/favourite/presentation/view/favourite_page.dart';
import 'package:careem_app_clean/features/home/presentation/view/map_page.dart';
import 'package:careem_app_clean/features/home/presentation/widgets/customNavigationBar_widget.dart';
import 'package:careem_app_clean/features/home/presentation/widgets/drawerWidget.dart';
import 'package:careem_app_clean/features/hub/presentation/view/pages/reservation_details.dart';
import 'package:careem_app_clean/features/home/presentation/view/offer.dart';
import 'package:careem_app_clean/features/wallet/presentation/view/wallet_info_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final Dio dio;
  final SharedPreferences sharedPreferences;
  final int? currentIndex;

  const HomePage({
    super.key,
    required this.dio,
    required this.sharedPreferences,
    this.currentIndex,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int _currentIndex;
  bool _isDrawerOpen = false;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex ?? 0;
    _pages = [
      MapPage(
        sharedPreferences: widget.sharedPreferences,
        dio: widget.dio,
      ),
      FavouritePage(
        sharedPreferences: widget.sharedPreferences,
        dio: widget.dio,
      ),
      WalletInfoPage(
        dio: widget.dio,
        sharedPreferences: widget.sharedPreferences,
      ),
      const OfferPage(),
      ReservationDetails(
        dio: widget.dio,
        sharedPreferences: widget.sharedPreferences,
      ),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _toggleDrawer() {
    setState(() {
      _isDrawerOpen = !_isDrawerOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double screenWidth = MediaQuery.sizeOf(context).width;
    return WillPopScope(
      onWillPop: () async => false,
      // in order to privent navigater back using the phone

      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              _pages[_currentIndex],
              if (_isDrawerOpen)
                Container(
                  color: Colors.black.withOpacity(0.6),
                ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: CustomnavigationbarWidget(
                    screenHeight: screenHeight,
                    isDrawerOpen: _isDrawerOpen,
                    currentIndex: _currentIndex,
                    onItemTapped: _onItemTapped,
                  )
                  //_buildCustomNavigationBar(screenHeight),
                  ),
              Positioned(
                top: 10,
                left: 10,
                child: GestureDetector(
                  onTap: _toggleDrawer,
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColor.progressBackgoundColor,
                    ),
                    child: const Icon(Icons.menu, color: Colors.black),
                  ),
                ),
              ),
              if (_isDrawerOpen)
                //_buildDrawer(screenWidth, screenHeight),
                Drawerwidget(
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                  dio: widget.dio,
                  sharedPreferences: widget.sharedPreferences,
                  toggleDrawer: _toggleDrawer,
                )
            ],
          ),
        ),
      ),
    );
  }
}
