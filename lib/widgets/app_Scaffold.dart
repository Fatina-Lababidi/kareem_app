import 'package:careem_app/core/config/check_connect.dart';
import 'package:careem_app/core/resources/asset.dart';
import 'package:careem_app/core/resources/color.dart';
import 'package:careem_app/core/resources/string.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({super.key, required this.child});

  final Widget child;
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    const double fontSize = 50;

    var connection = Provider.of<NetworkStatus>(context);

    return Scaffold(
      body: (connection == NetworkStatus.offline)
          ? Center(
              child: Column(
                children: [
                  const Spacer(),
                  Image.asset(
                    AppImages.offline,
                    width: screenWidth * 0.5,
                  ),
                  const Spacer(),
                  Text(
                    LocalizationKeys.offline.tr(),
                    style: const TextStyle(
                        color: AppColor.baseColor, fontSize: fontSize),
                  ),
                  const Spacer(
                    flex: 2,
                  ),
                ],
              ),
            )
          : child,
    );
  }
}
