import 'package:careem_app_clean/features/splash/presentation/view/onboarding.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CareemSplashPage extends StatefulWidget {
  final SharedPreferences sharedPreferences;
  final Dio dio;
  const CareemSplashPage({super.key, required this.sharedPreferences, required this.dio});

  @override
  State<CareemSplashPage> createState() => _CareemSplashPageState();
}

class _CareemSplashPageState extends State<CareemSplashPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _scaffoldColorAnimation;
  late Animation<double> _bikeOpacityAnimation;
  late Animation<double> _bikegrowAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<Offset> _bikeMoveRightAnimation;
  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 4));

//scaffold color :
    _scaffoldColorAnimation =
        ColorTween(begin: const Color(0xff08B783), end: Colors.white)
            .animate(CurvedAnimation(
                parent: _animationController,
                curve: const Interval(
                  0.0,
                  0.5,
                )));
// bike opacity:
    _bikeOpacityAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.0, 0.2, curve: Curves.bounceInOut)));

    //bike grow:
    _bikegrowAnimation = Tween<double>(begin: 0.5, end: 1.2).animate(
        CurvedAnimation(
            parent: _animationController, curve: const Interval(0.2, 0.3)));

    //text disapear:
    _textOpacityAnimation = Tween<double>(begin: 1, end: 0).animate(
        CurvedAnimation(
            parent: _animationController, curve: const Interval(0.2, 0.3)));
// bike move right :
    _bikeMoveRightAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(10, 0)).animate(
            CurvedAnimation(
                parent: _animationController, curve: const Interval(0.3, 1)));
    Future.delayed(const Duration(milliseconds: 1000), _navigateToNextPage);
    _animationController.forward();
  }

  void _navigateToNextPage() {
    Navigator.of(context).pushReplacement(PageTransition(
      duration: const Duration(seconds: 1),
      type: PageTransitionType.leftToRight,
      child:  OnBoarding(dio: widget.dio,sharedPreferences: widget.sharedPreferences,),
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _scaffoldColorAnimation,
        builder: (context, child) {
          return Container(
            color: _scaffoldColorAnimation.value,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SlideTransition(
                    position: _bikeMoveRightAnimation,
                    child: ScaleTransition(
                      scale: _bikegrowAnimation,
                      child: AnimatedOpacity(
                          duration: const Duration(seconds: 0),
                          opacity: _bikeOpacityAnimation.value,
                          child: SizedBox(
                            width: 200,
                            height: 200,
                            child: Image.asset(
                              'assets/images/bike_anim.png',
                              fit: BoxFit.fill,
                            ),
                          )),
                    ),
                  ),
                  AnimatedOpacity(
                    duration: const Duration(seconds: 0),
                    opacity: _textOpacityAnimation.value,
                    child: const Text(
                      'CAREEM APP',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(color: Colors.grey, offset: Offset(-3, 2))
                          ]),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
