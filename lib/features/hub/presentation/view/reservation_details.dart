import 'package:careem_app_clean/core/network/network_connection.dart';
import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/widgets/app_button.dart';
import 'package:careem_app_clean/core/widgets/failure_widget.dart';
import 'package:careem_app_clean/features/hub/data/datasource/remote_all_hub.dart';
import 'package:careem_app_clean/features/hub/data/datasource/remote_hub_content_datasource.dart';
import 'package:careem_app_clean/features/hub/data/datasource/remote_reservation_datasource.dart';
import 'package:careem_app_clean/features/hub/data/datasource/remote_reservation_details_datasource.dart';
import 'package:careem_app_clean/features/hub/data/repositories/all_hub_repo_impl.dart';
import 'package:careem_app_clean/features/hub/domain/usecase/reservation_details_usecase.dart';
import 'package:careem_app_clean/features/hub/presentation/reservationDetails_bloc/reservation_details_bloc.dart';
import 'package:careem_app_clean/features/payment/presentation/view/payment_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

//? reservation details:
// {
//   "message": "All reservations found",
//   "status": "OK",
//   "localDateTime": "2024-09-05T09:19:15.0843696",
//   "body": [
//     {
//       "id": 4,
//       "client": "sana",
//       "bicycle": "PUE229",
//       "from": "وزارة التربية",
//       "to": "جامع صلاح الدين",
//       "duration": 1,
//       "startTime": "2024-09-04T04:29:15.319",
//       "endTime": null,
//       "reservationStatus": "PENDING",
//       "price": 900
//     }
//   ]
// }

class ReservationDetails extends StatefulWidget {
  final Dio dio;
  final SharedPreferences sharedPreferences;
  const ReservationDetails(
      {super.key, required this.dio, required this.sharedPreferences});

  @override
  State<ReservationDetails> createState() => _ReservationDetailsState();
}

class _ReservationDetailsState extends State<ReservationDetails> {
  late int cleintId;

  Future _getClientId() async {
    setState(() {
      cleintId = widget.sharedPreferences.getInt('clientId') ?? 0;
    });
  }

  @override
  void initState() {
    super.initState();

    _getClientId();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenHeight = MediaQuery.sizeOf(context).height;
    return BlocProvider(
      create: (context) => ReservationDetailsBloc(ReservationDetailsUsecase(
          hubRepo: AllHubRepoImp(
              remoteAllHubDataSource: RemoteAllHubDataSource(dio: widget.dio),
              networkConnection: NetworkConnection(
                  internetConnectionChecker: InternetConnectionChecker()),
              remoteReservationDatasource:
                  RemoteReservationDatasource(dio: widget.dio),
              remoteHubContentDatasource:
                  RemoteHubContentDatasource(dio: widget.dio),
              remoteReservationDetailsDatasource:
                  RemoteReservationDetailsDatasource(dio: widget.dio))))
        ..add(GetReservationDetails(clientId: cleintId)),
      child: Scaffold(
        backgroundColor: AppColor.whiteColor,
        body: SafeArea(
            child: Column(
          children: [
            SizedBox(
              height: screenHeight * 0.025,
            ),
            Center(
              child: Text(
                'Reservation Details',
                style: TextStyle(
                  fontSize: screenWidth * 0.045, //18,
                  color: AppColor.settingsTitleColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: BlocConsumer<ReservationDetailsBloc,
                    ReservationDetailsState>(
                  listener: (context, state) {
                    if (state is ReservationDetailsFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(state.message),
                        backgroundColor: AppColor.snackbarOfflineColor,
                      ));
                    } else if (state is ReservationDetailsSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            state.reservationDetailsResponseEntity.message),
                        backgroundColor: AppColor.baseColor,
                      ));
                    }
                  },
                  builder: (context, state) {
                    if (state is ReservationDetailsSuccess) {
                      return SizedBox(
                        height: 400,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: state
                                .reservationDetailsResponseEntity.body.length,
                            itemBuilder: (context, index) {
                              final reservation = state
                                  .reservationDetailsResponseEntity.body[index];
                              return Padding(
                                padding: EdgeInsets.only(
                                    bottom: 50, left: 10, right: 10),
                                child: Container(
                                    width: 300,
                                    height: 100,
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColor.categoriesContainerColor,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: AppColor.buttonColor,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Clinet :${reservation.client}',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    AppColor.buttonDetailsColor,
                                              ),
                                            ),
                                            Text(
                                              'Bike : ${reservation.bicycle}',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: AppColor
                                                      .buttonDetailsColor
                                                      .withOpacity(0.8)),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: screenHeight * 0.01,
                                        ),
                                        Divider(),
                                        SizedBox(
                                          height: screenHeight * 0.01,
                                        ),
                                        Text(
                                          'Form hub : ${reservation.from}',
                                          style: TextStyle(),
                                        ),
                                        Text('To hub : ${reservation.to}'),
                                        SizedBox(
                                          height: screenHeight * 0.01,
                                        ),
                                        Divider(),
                                        SizedBox(
                                          height: screenHeight * 0.01,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Duration: ${reservation.duration} hr',
                                              style: TextStyle(),
                                            ),
                                            Text(
                                              'Price: \$${reservation.price}',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: screenHeight * 0.01,
                                        ),
                                        Divider(),
                                        // SizedBox(height: screenHeight * 0.04),
                                        (reservation.reservationStatus ==
                                                'PENDING')
                                            ? Text(
                                                'please confirm your booking :')
                                            : Text(''),
                                        SizedBox(
                                          height: screenHeight * 0.02,
                                        ),
                                        Center(
                                          child: AppButton(
                                            screenWidth: screenWidth * 0.8,
                                            screenHeight: screenHeight,
                                            text: reservation.reservationStatus,
                                            textColor: AppColor.whiteColor,
                                            containerColor: reservation
                                                        .reservationStatus ==
                                                    'PENDING'
                                                ? AppColor.snackbarFaildColor
                                                : AppColor.buttonColor,
                                            borderColor: reservation
                                                        .reservationStatus ==
                                                    'PENDING'
                                                ? AppColor.snackbarFaildColor
                                                : AppColor.buttonColor,
                                            onTap: () {
                                              if (reservation
                                                      .reservationStatus ==
                                                  'PENDING') {
                                                Navigator.push(
                                                    context,
                                                    PageTransition(
                                                        child: PaymentPage(
                                                            reservationId:
                                                                reservation.id,
                                                            bikeModel:
                                                                reservation
                                                                    .bicycle,
                                                            photoPath: '',
                                                            sharedPreferences:
                                                                widget
                                                                    .sharedPreferences,
                                                            dio: widget.dio),
                                                        type: PageTransitionType
                                                            .fade));
                                              }
                                            },
                                          ),
                                          //  Container(
                                          //   padding: const EdgeInsets.symmetric(
                                          //       horizontal: 8, vertical: 4),
                                          //   decoration: BoxDecoration(
                                          //     color: reservation
                                          //                 .reservationStatus ==
                                          //             'PENDING'
                                          //         ? AppColor.snackbarFaildColor
                                          //         : AppColor.buttonColor,
                                          //     borderRadius:
                                          //         BorderRadius.circular(12),
                                          //   ),
                                          //   child: Text(
                                          //     reservation.reservationStatus,
                                          //     style: TextStyle(
                                          //         color: Colors.white),
                                          //   ),
                                          // ),
                                        ),
                                      ],
                                    )),
                              );
                            },
                          ),
                        ),
                      );
                    } else if (state is ReservationDetailsFailure) {
                      return FailureUi(
                        onTap: () {
                          context
                              .read<ReservationDetailsBloc>()
                              .add(GetReservationDetails(clientId: cleintId));
                        },
                      );
                    } else {
                      return const CircularProgressIndicator(
                        color: AppColor.baseColor,
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
