//  double screenWidth = Provider.of<ScreenSizeProvider>(context).screenWidth;
//     double screenHeight = Provider.of<ScreenSizeProvider>(context).screenHeight;

//      Provider.of<ScreenSizeProvider>(context).updateScreenSize(context);

//changeNotifierProvider: in the main
// import 'package:flutter/material.dart';

// class ScreenSizeProvider with ChangeNotifier {
//   double screenWidth = 0;
//   double screenHeight = 0;

//   void updateScreenSize(BuildContext context) {
//     screenWidth = MediaQuery.of(context).size.width;
//     screenHeight = MediaQuery.of(context).size.height;
//     notifyListeners();
//   }
// }
