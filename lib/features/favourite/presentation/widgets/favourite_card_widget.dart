import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/features/bicycles/presentation/view/bicycle_by_id.dart';
import 'package:careem_app_clean/features/favourite/domain/entities/add_fav_response_entity.dart';
import 'package:careem_app_clean/features/favourite/presentation/deleteFav_bloc/delete_favourite_bloc.dart';
import 'package:careem_app_clean/features/favourite/presentation/favByClientId_bloc/fav_by_client_id_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavouriteCardWidget extends StatefulWidget {
  const FavouriteCardWidget({
    super.key,
    required this.screenHeight,
    required this.bike,
    required this.dio,
    required this.sharedPreferences,
    required this.screenWidth,
    required this.favId,
  });

  final double screenHeight;
  final BicyclesWithNullPhotoEntity bike;
  final Dio dio;
  final SharedPreferences sharedPreferences;
  final double screenWidth;
  final int favId;

  @override
  State<FavouriteCardWidget> createState() => _FavouriteCardWidgetState();
}

class _FavouriteCardWidgetState extends State<FavouriteCardWidget> {
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _isLoading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeleteFavouriteBloc, DeleteFavouriteState>(
      listener: (context, state) {
        if (state is DeleteFavouriteSuccess) {
          context.read<FavByClientIdBloc>().add(GetFavByClientid());
        }
      },
      child: Container(
        height: widget.screenHeight * 0.12,
        padding: const EdgeInsets.all(3),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColor.circularRipple2,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                PageTransition(
                    child: BicycleByIdPage(
                      id: widget.bike.id,
                      dio: widget.dio,
                      sharedPreferences: widget.sharedPreferences,
                    ),
                    type: PageTransitionType.fade));
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.pedal_bike,
                    color: AppColor.snackbarOfflineColor,
                    size: widget.screenWidth * 0.08,
                  ),
                  SizedBox(
                    width: widget.screenWidth * 0.02,
                  ),
                  Text(
                    widget.bike.modelPrice.model,
                  ),
                  const Spacer(),
                  ValueListenableBuilder<bool>(
                    valueListenable: _isLoading,
                    builder: (context, isLoading, child) {
                      return isLoading
                          ? SizedBox(
                              width: widget.screenWidth * 0.04,
                              height: widget.screenWidth * 0.04,
                              child: const CircularProgressIndicator(
                                color: AppColor.snackbarFaildColor,
                              ),
                            )
                          : IconButton(
                              onPressed: () {
                                // Set the loading state to true
                                _isLoading.value = true;

                                // Trigger the delete event
                                context.read<DeleteFavouriteBloc>().add(
                                      DeleteFavouriteBike(favId: widget.favId),
                                    );
                              },
                              icon: Icon(
                                Icons.stop_circle,
                                color: AppColor.snackbarFaildColor,
                                size: widget.screenWidth * 0.08,
                              ),
                            );
                    },
                  ),
                ],
              ),
              //     BlocConsumer<DeleteFavouriteBloc, DeleteFavouriteState>(
              //       listener: (context, state) {
              //         if (state is DeleteFavouriteSuccess) {
              //           context.read<FavByClientIdBloc>().add(GetFavByClientid());
              //         }
              //       },
              //       builder: (context, state) {
              //         if (state is DeleteFavouriteLoading) {
              //           return const Center(
              //             child: CircularProgressIndicator(
              //               color: AppColor.snackbarFaildColor,
              //             ),
              //           );
              //         } else {
              //           return IconButton(
              //             onPressed: () {
              //               //delete event
              //               context
              //                   .read<DeleteFavouriteBloc>()
              //                   .add(DeleteFavouriteBike(favId: widget.favId));
              //             },
              //             icon: Icon(
              //               Icons.stop_circle,
              //               color: AppColor.snackbarFaildColor,
              //               size: widget.screenWidth * 0.08,
              //             ),
              //           );
              //         }
              //       },
              //     ),
              //   ],
              // ),
              Row(
                children: [
                  Text(
                    "${widget.bike.type}|${widget.bike.modelPrice.price}|${widget.bike.note}",
                    style: TextStyle(
                        fontSize: widget.screenWidth * 0.025, //10,
                        color: AppColor.skipTextColor,
                        fontWeight: FontWeight.bold),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
