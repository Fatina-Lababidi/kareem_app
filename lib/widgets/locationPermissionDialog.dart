import 'package:careem_app/core/resources/color.dart';
import 'package:careem_app/core/resources/string.dart';
import 'package:careem_app/widgets/app_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LocationPermissionDialog extends StatelessWidget {
  final VoidCallback onUseMyLocation;
  final VoidCallback onSkipForNow;
  const LocationPermissionDialog(
      {super.key, required this.onUseMyLocation, required this.onSkipForNow});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double screenWidth = MediaQuery.sizeOf(context).width;

    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 100,
            width: 100,
            child: CircularRipples(),
          ),
          Text(
            LocalizationKeys.enableYourLocation.tr(),
            style: const TextStyle(
              fontSize: 24,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            LocalizationKeys.chooseYourLocationA.tr(),
            style:
                const TextStyle(fontSize: 14, color: AppColor.detailsTextColor),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            LocalizationKeys.chooseYourLocationB.tr(),
            style:
                const TextStyle(fontSize: 14, color: AppColor.detailsTextColor),
          ),
          SizedBox(
            height: 10,
          ),
          AppButton(
              onTap: onUseMyLocation,
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              text: LocalizationKeys.useMyLocation.tr(),
              textColor: AppColor.whiteColor,
              containerColor: AppColor.baseColor),
          SizedBox(
            height: 10,
          ),
          TextButton(
            onPressed: onSkipForNow,
            child: Center(
              child: Text(
                LocalizationKeys.skipForNow.tr(),
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColor.skipTextColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CircularRipples extends StatefulWidget {
  const CircularRipples({super.key});
  @override
  _CircularRipplesState createState() => _CircularRipplesState();
}

class _CircularRipplesState extends State<CircularRipples>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  painter: RipplePainter(_controller.value),
                  size: const Size(150, 150),
                );
              },
            ),
          ),
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  blurRadius: 1,
                )
              ],
              shape: BoxShape.circle,
              color: AppColor.baseColor,
            ),
            child: const Center(
              child: Icon(
                Icons.location_on,
                color: AppColor.contentSecondaryTextColor,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RipplePainter extends CustomPainter {
  final double animationValue;

  RipplePainter(this.animationValue);
  final List<RippleConfig> ripples = [
    RippleConfig(
        initialRadius: 40,
        strokeWidth: 10,
        color: AppColor.circularRipple1.withOpacity(0.5)),
    RippleConfig(
        initialRadius: 50,
        strokeWidth: 4,
        color: AppColor.circularRipple2.withOpacity(0.5)),
    RippleConfig(
        initialRadius: 55,
        strokeWidth: 2,
        color: AppColor.circularRipple2.withOpacity(0.2)),
    RippleConfig(
        initialRadius: 60,
        strokeWidth: 2,
        color: AppColor.circularRipple2.withOpacity(0.2)),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    for (var ripple in ripples) {
      final paint = Paint()
        ..color = ripple.color
        //.withOpacity(1 - animationValue),ican add the opacity to color rather than here
        ..style = PaintingStyle.stroke
        ..strokeWidth = ripple.strokeWidth;

      final radius = ripple.initialRadius * animationValue;
      canvas.drawCircle(Offset(size.width / 2, size.height / 2), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class RippleConfig {
  final double initialRadius;
  final double strokeWidth;
  final Color color;

  RippleConfig({
    required this.initialRadius,
    required this.strokeWidth,
    required this.color,
  });
}
