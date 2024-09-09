import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/resources/string.dart';
import 'package:careem_app_clean/features/home/presentation/widgets/hexagonal.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CustomnavigationbarWidget extends StatelessWidget {
  final double screenHeight;
  final bool isDrawerOpen;
  final int currentIndex;
  final void Function(int) onItemTapped;
  const CustomnavigationbarWidget(
      {super.key,
      required this.screenHeight,
      required this.isDrawerOpen,
      required this.currentIndex,
      required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenHeight * 0.1, //80,
      decoration: BoxDecoration(
        color: isDrawerOpen ? Colors.white.withOpacity(0.5) : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        boxShadow: const [
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
                painter: HexagonPainter(AppColor.baseColor),
                child: const SizedBox(
                  //! have we change this? or its good??
                  width: 70,
                  height: 70,
                  child: Center(
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
              selectedItemColor: AppColor.baseColor,
              onTap: onItemTapped,
              currentIndex: currentIndex,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              elevation: 0,
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.home_rounded),
                  label: LocalizationKeys.home.tr(),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.favorite_outline_outlined),
                  label: LocalizationKeys.favourite.tr(),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.wallet,
                      color: Colors.transparent), // SizedBox.shrink(),
                  label: LocalizationKeys.wallet.tr(),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.money_off_csred_rounded),
                  label: LocalizationKeys.offer.tr(),
                ),
                BottomNavigationBarItem(
                    icon: const Icon(Icons.event),
                    label: LocalizationKeys.reservation
                        .tr() //LocalizationKeys.profile.tr(),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
