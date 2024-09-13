import 'dart:math';
import 'package:careem_app_clean/core/resources/asset.dart';
import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/resources/string.dart';
import 'package:careem_app_clean/core/widgets/app_button.dart';
import 'package:careem_app_clean/features/home/presentation/view/home_page.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThanksPage extends StatefulWidget {
  final String message;
  final Dio dio;
  final SharedPreferences sharedPreferences;
  const ThanksPage({
    super.key,
    required this.message,
    required this.dio,
    required this.sharedPreferences,
  });

  @override
  State<ThanksPage> createState() => _ThanksPageState();
}

class _ThanksPageState extends State<ThanksPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];
  final int particleCount = 100;
  final GlobalKey _starKey = GlobalKey();

  void _triggerExplosion(Offset position) {
    _particles.clear();

    for (int i = 0; i < particleCount; i++) {
      _particles.add(Particle(position: position));
    }
    _controller.reset();
    _controller.forward();
  }

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _controller.addListener(() {
      setState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox renderBox =
          _starKey.currentContext!.findRenderObject() as RenderBox;
      final size = renderBox.size;
      final center = Offset(size.width / 2, size.height / 2);

      _triggerExplosion(center);
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double screenWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  painter: ParticleExplosionPainter(
                      particles: _particles, progress: _controller.value),
                ),
                Image.asset(
                  AppImages.thinkStart,
                  key: _starKey,
                ).animate(
                  onComplete: (controller) {
                    controller.repeat();
                  },
                ).rotate(duration: 3.seconds, delay: 1.seconds),
                Center(
                  child: Icon(Icons.check_rounded,
                      color: AppColor.checkColor, size: screenWidth * 0.2 //80,
                      ),
                ),
              ],
            ),
            SizedBox(
              height: screenHeight * 0.05,
            ),
            Text(
              textAlign: TextAlign.center,
              LocalizationKeys.thankYou.tr(),
              style: TextStyle(
                  color: AppColor.buttonDetailsColor,
                  fontWeight: FontWeight.w500,
                  fontSize: screenWidth * 0.05 //20,
                  ),
            ),
            SizedBox(
              height: screenHeight * 0.01,
            ),
            Text(
              textAlign: TextAlign.center,
              widget.message,
              style: TextStyle(
                  color: AppColor.buttonDetailsColor,
                  fontWeight: FontWeight.w500,
                  fontSize: screenWidth * 0.03 //12,
                  ),
            ),
            const Spacer(),
            AppButton(
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              text: 'Back home', //LocalizationKeys.confirmRide.tr(),
              textColor: AppColor.whiteColor,
              containerColor: AppColor.buttonColor,
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        child: HomePage(
                          dio: widget.dio,
                          sharedPreferences: widget.sharedPreferences,
                          currentIndex: 4,
                        ),
                        type: PageTransitionType.fade));
              },
            ),
            SizedBox(
              height: screenHeight * 0.05,
            )
          ],
        ),
      ),
    );
  }
}

class Particle {
  final Offset position;
  final Offset velocity;
  final Color color;
  final double radius;
  Particle({required this.position})
      : velocity = Offset((Random().nextDouble() - 0.5) * 2,
                (Random().nextDouble() - 0.5) * 2) *
            500,
        color = Color.fromARGB(225, Random().nextInt(55), Random().nextInt(256),
            Random().nextInt(56)),
        radius = Random().nextDouble() * 5 + 2;
}

class ParticleExplosionPainter extends CustomPainter {
  final List<Particle> particles;
  final double progress;
  ParticleExplosionPainter({
    required this.particles,
    required this.progress,
  });
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();

    for (var particle in particles) {
      paint.color = particle.color.withOpacity(1.0 - progress);
      final currentposition = Offset(
          particle.position.dx + particle.velocity.dx * progress,
          particle.position.dy + particle.velocity.dy * progress);
      canvas.drawCircle(
          currentposition, particle.radius * (1 - progress), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
