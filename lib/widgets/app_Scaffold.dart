import 'package:careem_app/core/config/check_connect.dart';
import 'package:careem_app/core/resources/asset.dart';
import 'package:careem_app/core/resources/color.dart';
import 'package:careem_app/core/resources/string.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppScaffold extends StatelessWidget {
  AppScaffold({super.key, required this.child});

  final Widget child;
  @override
  Widget build(BuildContext context) {
    var connection = Provider.of<Status>(context);

    return Scaffold(
      body: (connection == Status.offline)
          ? Column(
              children: [
                Image.asset(AppImages.offline),
                Text(
                  LocalizationKeys.offline.tr(),
                  style: TextStyle(color: AppColor.baseColor),
                )
              ],
            )
          : child,
    );
  }
}
