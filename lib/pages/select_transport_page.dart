import 'package:careem_app/bloc/categories_bloc/categories_bloc.dart';
import 'package:careem_app/core/resources/asset.dart';
import 'package:careem_app/core/resources/color.dart';
import 'package:careem_app/core/resources/string.dart';
import 'package:careem_app/pages/bicycle_by_category.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

class SelectTransportPage extends StatelessWidget {
  SelectTransportPage({super.key});

  final Map<String, String> categoryImages = {
    "Road_bikes": AppImages.roadBikes,
    "Mountain_bikes": AppImages.mountainBikes,
    "Hybrid_bikes": AppImages.hybridBikes,
    "e_bikes": AppImages.eBikes,
  };
  final Map<String, String> categoriesText = {
    "Road_bikes": LocalizationKeys.roadBikes.tr(),
    "Mountain_bikes": LocalizationKeys.mountainBikes.tr(),
    "Hybrid_bikes": LocalizationKeys.hybridBikes.tr(),
    "e_bikes": LocalizationKeys.eBikes.tr(),
  };
  final String defaultImage = AppImages.defaultBike;
  final String defultText = LocalizationKeys.defaultBike.tr();
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double screenWidth = MediaQuery.sizeOf(context).width;

    return BlocProvider(
      create: (context) => CategoriesBloc()..add(FetchCategories()),
      child: Scaffold(
        backgroundColor: AppColor.whiteColor,
        body: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      size: 16,
                      Icons.arrow_back_ios_new_outlined,
                      color: AppColor.contentSecondaryTextColor,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    LocalizationKeys.back.tr(),
                    style: const TextStyle(
                        color: AppColor.contentSecondaryTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                  const Spacer(),
                  Text(
                    LocalizationKeys.selectTransport.tr(),
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                  const Spacer(
                    flex: 2,
                  ),
                ],
              ).animate().fade(duration: .2.seconds, delay: .1.seconds),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  LocalizationKeys.selectYourTrasport.tr(),
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: AppColor.buttonDetailsColor),
                ),
              ).animate().fade(duration: .3.seconds, delay: .15.seconds),
              const SizedBox(height: 20),
              BlocBuilder<CategoriesBloc, CategoriesState>(
                  builder: (context, state) {
                switch (state) {
                  case CategoriesSuccess():
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: GridView.builder(
                          itemCount: state.categoriesResponseModel.body.length,
                          // 4,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemBuilder: (context, index) {
                            final category =
                                state.categoriesResponseModel.body[index];
                            final imageUrl =
                                categoryImages[category] ?? defaultImage;
                            final text = categoriesText[category] ?? defultText;
                            return CategoriesContainer(
                              categoryKey: category,
                              imageUrl: imageUrl,
                              catergory: text,
                              screenHeight: screenHeight,
                              screenWidth: screenWidth,
                            ).animate().fade(
                                duration: (0.2 * index).seconds,
                                delay: .2.seconds);
                          },
                        ),
                      ),
                    );
                  case CategoriesFailed():
                    return Center(
                      child: Text(state.message),
                    );
                  case CategoriesOffline():
                    return Center(
                      child: Text(state.message),
                    );
                  default:
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColor.baseColor,
                      ),
                    );
                }
              })
            ],
          ),
        ),
      ),
    );
  }
}

class CategoriesContainer extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;
  final String catergory;
  final String imageUrl;
  final String categoryKey;
  const CategoriesContainer({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.catergory,
    required this.imageUrl,
    required this.categoryKey,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
            child: BicycleByCategoryPage(//! we have to get this
              latitude: 30,
              longitude: 20,
              category: categoryKey,
            ),
            type: PageTransitionType.fade,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColor.categoriesContainerColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColor.baseColor),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Image.asset(
                imageUrl,
                height: screenHeight * 0.15,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              catergory,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
