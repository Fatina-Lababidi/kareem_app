import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/resources/string.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class BicycleByIdPage extends StatelessWidget {
  final int id;
  final double price;
  final String model;
  final int size;
  final String photoPath;
  final String type;
  final String note;

  const BicycleByIdPage(
      {super.key,
      required this.id,
      required this.price,
      required this.model,
      required this.size,
      required this.photoPath,
      required this.type,
      required this.note});

  @override
  Widget build(BuildContext context) {
   // final double screenWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 12,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Row(
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
                SizedBox(
                  height: 20,
                ),
                Text(
                  model,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  type,
                  style: const TextStyle(
                      fontSize: 12, color: AppColor.skipTextColor),
                ),
                Center(
                  child: Image.network(
                    // loadingBuilder: (context, child, loadingProgress) {
                    //   return const CircularProgressIndicator(
                    //     color: AppColor.baseColor,
                    //   );
                    // },
                    errorBuilder: (context, error, stackTrace) {
                      return Column(
                        children: [
                          Image.asset(
                            'assets/images/bicycle.png',
                            width: 50,
                          ),
                          Text('enable to fetch image'), //! localization
                        ],
                      );
                    },
                    'https://' + photoPath,
                    width: 200,
                    colorBlendMode: BlendMode.colorBurn,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Specifications',
                  style: TextStyle(fontSize: 18),
                ), //! Localization
                SizedBox(
                  height: 5,
                ),
                bikeSpecificationsRow(),
                SizedBox(
                  height: 5,
                ),
                Text('bicycle features', style: TextStyle(fontSize: 18)),
                SizedBox(
                  height: 5,
                ),
                BikeSpecificationColWidget(
                    title: 'type: ',
                    text: type,
                    icon: Icons.pedal_bike_outlined),
                SizedBox(
                  height: 10,
                ),
                BikeSpecificationColWidget(
                    title: 'model: ', text: model, icon: Icons.numbers),
                SizedBox(
                  height: 10,
                ),
                BikeSpecificationColWidget(
                  title: 'price: ',
                  text: price.toString(),
                  icon: Icons.attach_money_rounded,
                ),
                SizedBox(
                  height: 10,
                ),
                BikeSpecificationColWidget(
                    title: 'size: ',
                    text: size.toString(),
                    icon: Icons.confirmation_number_sharp),
                SizedBox(
                  height: 10,
                ),

                //tow buttons : what the diffrence between them ?
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row bikeSpecificationsRow() {
    return Row(
      children: [
        SizedBox(
          width: 5,
        ),
        BikeSpecificationRoWidget(text: type, icon: Icons.pedal_bike_outlined),
        SizedBox(
          width: 10,
        ),
        BikeSpecificationRoWidget(text: model, icon: Icons.numbers),
        SizedBox(
          width: 10,
        ),
        BikeSpecificationRoWidget(
          text: price.toString(),
          icon: Icons.attach_money_rounded,
        ),
        SizedBox(
          width: 10,
        ),
        BikeSpecificationRoWidget(
            text: size.toString(), icon: Icons.confirmation_number_sharp),
        SizedBox(
          width: 5,
        ),
      ],
    );
  }
}

//!
class BikeSpecificationColWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final String title;
  const BikeSpecificationColWidget({
    super.key,
    required this.icon,
    required this.text,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: EdgeInsets.all(5),
      height: 50,
      decoration: BoxDecoration(
          color: AppColor.categoriesContainerColor,
          border: Border.all(
            color: AppColor.baseColor,
          ),
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: AppColor.contentSecondaryTextColor,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Text(
            text,
            style: const TextStyle(color: AppColor.contentSecondaryTextColor),
          ),
        ],
      ),
    );
  }
}
//!

class BikeSpecificationRoWidget extends StatelessWidget {
  const BikeSpecificationRoWidget({
    super.key,
    required this.text,
    required this.icon,
  });

  final String text;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      //! query
      width: 80,
      height: 80,
      decoration: BoxDecoration(
          color: AppColor.categoriesContainerColor,
          border: Border.all(
            color: AppColor.baseColor,
          ),
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: AppColor.contentSecondaryTextColor,
          ),
          Text(
            text,
            style: const TextStyle(
                color: AppColor.contentSecondaryTextColor, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
