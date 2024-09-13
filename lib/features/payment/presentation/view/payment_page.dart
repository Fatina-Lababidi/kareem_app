import 'package:careem_app_clean/core/functions/language.dart';
import 'package:careem_app_clean/core/network/network_connection.dart';
import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/resources/string.dart';
import 'package:careem_app_clean/core/widgets/appBar_widget.dart';
import 'package:careem_app_clean/core/widgets/app_button.dart';
import 'package:careem_app_clean/core/widgets/app_textFormField.dart';
import 'package:careem_app_clean/features/home/presentation/view/home_page.dart';
import 'package:careem_app_clean/features/payment/data/datasource/remote_payment_datasource.dart';
import 'package:careem_app_clean/features/payment/data/repositories_imp/payment_repo_imp.dart';
import 'package:careem_app_clean/features/payment/domain/entities/payment_entity.dart';
import 'package:careem_app_clean/features/payment/domain/usecases/payment_usecase.dart';
import 'package:careem_app_clean/features/payment/presentation/payment_bloc/payment_bloc.dart';
import 'package:careem_app_clean/features/payment/presentation/widgets/bike_detailsWidget.dart';
import 'package:careem_app_clean/features/payment/presentation/widgets/payment_noWallet.dart';
import 'package:careem_app_clean/features/thanks_page.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Not enough wallet, please charge your wallet first then try again

class PaymentPage extends StatefulWidget {
  final int reservationId;
  final String bikeModel;
  final String photoPath;
  final SharedPreferences sharedPreferences;
  final Dio dio;
  const PaymentPage(
      {super.key,
      required this.reservationId,
      required this.bikeModel,
      required this.photoPath,
      required this.sharedPreferences,
      required this.dio});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _passwordController = TextEditingController();

  bool obscurepassword = true;

  bool walletExists = false;
  Future _isThereAWallet() async {
    bool? haveWallet = widget.sharedPreferences.getBool('haveWallet');
    setState(() {
      walletExists = haveWallet ?? true; //false !!//!! need to change
    });
  }

  @override
  void initState() {
    super.initState();
    _isThereAWallet();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double screenWidth = MediaQuery.sizeOf(context).width;
    return BlocProvider(
      create: (context) => PaymentBloc(PaymentUsecase(
          paymentRepo: PaymentRepoImp(
              remotePaymentDatasource: RemotePaymentDatasource(dio: widget.dio),
              networkConnection: NetworkConnection(
                  internetConnectionChecker: InternetConnectionChecker())))),
      child: BlocListener<PaymentBloc, PaymentState>(
        listener: (context, state) {
          if (state is PaymentFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: AppColor.snackbarOfflineColor,
              duration: const Duration(seconds: 1),
            ));
            if (state.message ==
                "Not enough wallet, please charge your wallet first then try again") {
              Navigator.push(
                context,
                PageTransition(
                  child: HomePage(
                    dio: widget.dio,
                    sharedPreferences: widget.sharedPreferences,
                    currentIndex: 2,
                  ),
                  type: PageTransitionType.fade,
                ),
              );
            }
          } else if (state is PaymentSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColor.baseColor,
                duration: const Duration(seconds: 1),
              ),
            );
            Navigator.push(
                context,
                PageTransition(
                    child: ThanksPage(
                      message: state.message,
                      sharedPreferences: widget.sharedPreferences,
                      dio: widget.dio,
                    ),
                    type: PageTransitionType.fade));
          }
        },
        child: Scaffold(
          backgroundColor: AppColor.whiteColor,
          body: SafeArea(
            child: walletExists
                ? Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AppBarWidget(
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                            textTitle:
                                LocalizationKeys.payment.tr() //'Payment',
                            ),
                        SizedBox(
                          height: screenHeight * 0.09,
                        ),
                        Padding(
                          padding: isEnglish(context)
                              ? EdgeInsets.only(left: screenWidth * 0.07)
                              : EdgeInsets.only(right: screenWidth * 0.07),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                LocalizationKeys.reservationId.tr(),
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: AppColor.buttonDetailsColor),
                              ),
                              Text(
                                '${widget.reservationId}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: AppColor.buttonDetailsColor,
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.02,
                        ),
                        BikeDetailsWidget(
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                          bikeModel: widget.bikeModel,
                          photoPath: widget.photoPath,
                        ),
                        SizedBox(
                          height: screenHeight * 0.02,
                        ),
                        Align(
                          alignment: isEnglish(context)
                              ? Alignment.topLeft
                              : Alignment.topRight,
                          child: Padding(
                            padding: isEnglish(context)
                                ? EdgeInsets.only(left: screenWidth * 0.07)
                                : EdgeInsets.only(right: screenWidth * 0.07),
                            child: Text(
                              LocalizationKeys.enterWalletPassword.tr(),
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.buttonDetailsColor),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.02,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.02),
                          child: AppTextFormField(
                            //focusNode: _passwordFocusNode,
                            obscurepassword: obscurepassword,
                            secretPasswordIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  obscurepassword = !obscurepassword;
                                });
                              },
                              icon: obscurepassword == false
                                  ? const Icon(Icons.visibility_off)
                                  : const Icon(Icons.visibility),
                              color: AppColor.detailsTextColor,
                            ),
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                            hintText: LocalizationKeys.enterYourPassword.tr(),
                            textColor: Colors.black,
                            hintColor: Colors.grey,
                            containerColor: Colors.white,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return LocalizationKeys.passwordValidate.tr();
                              } else if (value.length < 8) {
                                return LocalizationKeys.passwordTooShort.tr();
                              } else if (!RegExp(
                                      r'^(?=.*?[A-Za-z])(?=.*?[0-9]).{8,}$')
                                  .hasMatch(value)) {
                                return LocalizationKeys.passwordInvalid.tr();
                              }
                              return null;
                            },
                            controller: _passwordController,
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.05,
                        ),
                        const Spacer(),
                        BlocBuilder<PaymentBloc, PaymentState>(
                          builder: (context, state) {
                            if (state is PaymentLoading) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: AppColor.buttonColor,
                                ),
                              );
                            } else {
                              return AppButton(
                                screenWidth: screenWidth,
                                screenHeight: screenHeight,
                                text: LocalizationKeys.pay.tr(),
                                textColor: AppColor.whiteColor,
                                containerColor: AppColor.buttonColor,
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {
                                    // context.read().add(pay());
                                    PaymentRequestEntity paymentRequestEntity =
                                        PaymentRequestEntity(
                                            walletPassword:
                                                _passwordController.text,
                                            reservationID:
                                                widget.reservationId);
                                    print(paymentRequestEntity.walletPassword);
                                    print(paymentRequestEntity.reservationID);
                                    context.read<PaymentBloc>().add(
                                        PayForYourReservation(
                                            paymentRequestEntity:
                                                paymentRequestEntity));
                                  }
                                },
                              );
                            }
                          },
                        ),
                        SizedBox(
                          height: screenHeight * 0.05,
                        ),
                      ],
                    ),
                  )
                : PaymentWithNoWalletWidget(
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                    widget: widget),
          ),
        ),
      ),
    );
  }
}
