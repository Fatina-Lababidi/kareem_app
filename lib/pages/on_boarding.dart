import 'package:careem_app/core/resources/asset.dart';
import 'package:careem_app/core/resources/color.dart';
import 'package:careem_app/core/resources/string.dart';
import 'package:careem_app/widgets/app_Scaffold.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  List photo = [
    AppImages.onboarding1,
    AppImages.onboarding2,
    AppImages.onboarding3,
  ];
  List titles = [
    LocalizationKeys.onboardingTilte1,
    LocalizationKeys.onboardingTilte2,
    LocalizationKeys.onboardingTilte3,
  ];
  List description = [
    LocalizationKeys.onboardingDescription1A,
    LocalizationKeys.onboardingDescription1B,
    LocalizationKeys.onboardingDescription1C,
  ];
  @override
  Widget build(BuildContext context) {
    int onTap = 0;
   
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return AppScaffold(child: Builder(builder: (context) {
      return PageView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
       return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      onPressed: (){
                        //Navigate to the map page
                      },
                     child: Text( LocalizationKeys.skip.tr(),
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    )),
                  )
                ],
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: SizedBox(
                  height: 208,
                  width: 373,
                  child: Image.asset(photo[index]),
                ),
              ),
              Spacer(),
              ListTile(
                title: Center(
                    child: Text(
                  titles[index],
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: AppColor.contentSecondaryTextColor),
                )),
                subtitle: Center(
                  child: Text(
                    description[index],
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColor.detailsTextColor),
                  ),
                ),
              ),
              const SizedBox(
                height: 170,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: FloatingActionButton(
                  onPressed: () {
                    setState(() {
                    onTap += onTap; 
                        if (onTap==0) {
                      index=0;
                    } else if(onTap==1) {
                      index=1;
                    }else if(onTap==2){
                      index=2;
                    }
                    });
                  },
                  child: const CircularProgressIndicator(
                    value: 0.33,
                    color: AppColor.baseColor,
                    backgroundColor: AppColor.progressBackgoundColor,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        AppColor.baseColor),
                      
                  ),
                ),
              ),
            ],
          );
        },
      );
    }));
  }
}
