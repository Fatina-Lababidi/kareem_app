import 'package:careem_app_clean/core/network/network_connection.dart';
import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/widgets/failure_widget.dart';
import 'package:careem_app_clean/features/hub/data/datasource/remote_all_hub.dart';
import 'package:careem_app_clean/features/hub/data/datasource/remote_hub_content_datasource.dart';
import 'package:careem_app_clean/features/hub/data/datasource/remote_reservation_datasource.dart';
import 'package:careem_app_clean/features/hub/data/datasource/remote_reservation_details_datasource.dart';
import 'package:careem_app_clean/features/hub/data/repositories/all_hub_repo_impl.dart';
import 'package:careem_app_clean/features/hub/domain/usecase/reservation_details_usecase.dart';
import 'package:careem_app_clean/features/hub/presentation/reservationDetails_bloc/reservation_details_bloc.dart';
import 'package:careem_app_clean/features/hub/presentation/view/widgets/reservationDetailsSuccess_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                        height: screenHeight * 0.55,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: state
                                .reservationDetailsResponseEntity.body.length,
                            itemBuilder: (context, index) {
                              final reservation = state
                                  .reservationDetailsResponseEntity.body[index];
                              return ReservationDetailsSuccessWidget(
                                screenHeight: screenHeight,
                                screenWidth: screenWidth,
                                reservation: reservation,
                                widget: widget,
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
