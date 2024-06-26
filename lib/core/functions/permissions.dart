import 'package:careem_app/pages/welcom.dart';
import 'package:careem_app/widgets/locationPermissionDialog.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<bool> requestLocationPermission(BuildContext context) async {
    if (await Permission.location.isGranted) {
      return true;
    }
    //else {
      // // bool shouldShowRationale = await Permission.location.shouldShowRequestRationale;

      // return await showDialog(
      //   context: context,
      //   barrierDismissible: false,
      //   builder: (context) => LocationPermissionDialog(
      //     onUseMyLocation: () {
      //       Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) => WelcomePage(),
      //           ));
      //       //Navigator.of(context).pop(true);
      //     },
      //     onSkipForNow: () {
      //       Navigator.of(context).pop(false);
      //     },
      //   ),
      // ).then((result) async {
      //   if (result == true) {
      //     final statusPermission = await Permission.location.request();
      //     return statusPermission == PermissionStatus.granted;
      //   }
        return false;
      }
     // );
    //}
 // }
}
