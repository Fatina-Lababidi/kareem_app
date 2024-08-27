import 'package:careem_app_clean/core/functions/language.dart';
import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/resources/string.dart';
import 'package:careem_app_clean/features/favourite/presentation/view/favourite_page.dart';
import 'package:careem_app_clean/features/home/presentation/view/map_page.dart';
import 'package:careem_app_clean/features/home/presentation/widgets/hexagonal.dart';
import 'package:careem_app_clean/features/offer.dart';
import 'package:careem_app_clean/features/settings/presentation/view/settings_page.dart';
import 'package:careem_app_clean/features/wallet/presentation/view/wallet_info_page.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final Dio dio;
  final SharedPreferences sharedPreferences;

  const HomePage({
    super.key,
    required this.dio,
    required this.sharedPreferences,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  bool _isDrawerOpen = false;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
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
      ),
      const OfferPage(),
      const ProfilePage(),
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
      onWillPop: () async {
        // in order int to navigater back using the phone
        return false;
      },
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
                child: _buildCustomNavigationBar(),
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
                      // boxShadow: const [
                      //   BoxShadow(
                      //     color: Colors.black26,
                      //     blurRadius: 4.0,
                      //     spreadRadius: 1.0,
                      //   ),
                      // ],
                    ),
                    child: Icon(Icons.menu, color: Colors.black),
                  ),
                ),
              ),
              if (_isDrawerOpen) _buildDrawer(screenWidth, screenHeight),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomNavigationBar() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: _isDrawerOpen ? Colors.white.withOpacity(0.5) : Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            spreadRadius: 1.0,
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -35,
            left: 0,
            right: 0,
            child: Center(
              child: CustomPaint(
                size: const Size(70, 70),
                painter: HexagonPainter(Color(0xff08B783)),
                child: Container(
                  width: 70,
                  height: 70,
                  child: const Center(
                    child: Icon(Icons.wallet, color: Colors.white, size: 35),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: BottomNavigationBar(
              selectedItemColor: Color(0xff08B783),
              onTap: _onItemTapped,
              currentIndex: _currentIndex,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              elevation: 0,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded),
                  label: LocalizationKeys.home.tr(),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite_outline_outlined),
                  label: LocalizationKeys.favourite.tr(),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.wallet,
                      color: Colors.transparent), // SizedBox.shrink(),
                  label: LocalizationKeys.wallet.tr(),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.money_off_csred_rounded),
                  label: LocalizationKeys.offer.tr(),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_2_outlined),
                  label: LocalizationKeys.profile.tr(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(double screenWidth, double screenHeight) {
    return Positioned(
      top: 0,
      bottom: 0,
      // left: isEnglish(context)?0:screenWidth-230,
      left: 0,
      width: 230, //query
      child: GestureDetector(
        onPanUpdate: (details) {
          if (details.delta.dx < -5) {
            _toggleDrawer();
          }
        },
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(60),
              bottomRight: Radius.circular(60),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: isEnglish(context)
                    ? EdgeInsets.only(
                        left: screenWidth * 0.02, top: screenHeight * 0.01)
                    : EdgeInsets.only(
                        right: screenWidth * 0.02, top: screenHeight * 0.02),
                child: GestureDetector(
                  onTap: () {
                    _toggleDrawer();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(
                        size: 20,
                        Icons.arrow_back_ios_new_outlined,
                        color: AppColor.contentSecondaryTextColor,
                      ),
                      Text(
                        LocalizationKeys.back.tr(),
                        style: const TextStyle(
                            color: AppColor.contentSecondaryTextColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ),
              // SizedBox(
              //   height: 10,
              // ),
              // Container(
              //   margin: EdgeInsets.only(right: 125), //! must have better way ?!
              //   decoration: BoxDecoration(
              //       color: AppColor.circularRipple2,
              //       border: Border.all(color: AppColor.baseColor),
              //       shape: BoxShape.circle),
              //   child: const Center(
              //     child: Icon(
              //       Icons.person,
              //       color: AppColor.baseColor,
              //       size: 65,
              //     ),
              //   ),
              // ),
              SizedBox(
                height: 100,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      child: SettingsPage(
                        dio: widget.dio,
                        sharedPreferences: widget.sharedPreferences,
                      ),
                      type: PageTransitionType.fade,
                    ),
                  );
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.settings,
                      color: AppColor.contentSecondaryTextColor,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      LocalizationKeys.settingsTitle.tr(),
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColor.contentSecondaryTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              ),
              const Divider(
                thickness: 1,
                color: AppColor.dividerColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
