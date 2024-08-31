import 'package:careem_app_clean/core/functions/language.dart';
import 'package:careem_app_clean/core/network/network_connection.dart';
import 'package:careem_app_clean/core/resources/asset.dart';
import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/resources/string.dart';
import 'package:careem_app_clean/core/widgets/app_button.dart';
import 'package:careem_app_clean/core/widgets/back_row_widget.dart';
import 'package:careem_app_clean/core/widgets/failure_widget.dart';
import 'package:careem_app_clean/features/wallet/data/datasource/remote_add_money_datasource.dart';
import 'package:careem_app_clean/features/wallet/data/datasource/remote_create_wallet_datasource.dart';
import 'package:careem_app_clean/features/wallet/data/datasource/remote_getWalletInfo_datasource.dart';
import 'package:careem_app_clean/features/wallet/data/datasource/remote_valid_code_datasource.dart';
import 'package:careem_app_clean/features/wallet/data/repositories/wallet_repo_imp.dart';
import 'package:careem_app_clean/features/wallet/domain/usecase/add_money_usecase.dart';
import 'package:careem_app_clean/features/wallet/domain/usecase/get_valid_code_usecase.dart';
import 'package:careem_app_clean/features/wallet/presentation/addMoney_bloc/add_money_bloc.dart';
import 'package:careem_app_clean/features/wallet/presentation/validCode_bloc/valid_code_bloc.dart';
import 'package:careem_app_clean/features/wallet/presentation/view/wallet_info_page.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:page_transition/page_transition.dart';

class AddMoneyPage extends StatefulWidget {
  final Dio dio;
  const AddMoneyPage({super.key, required this.dio});

  @override
  State<AddMoneyPage> createState() => _AddMoneyPageState();
}

class _AddMoneyPageState extends State<AddMoneyPage> {
  String text = 'choose the code';
  num finalAmount = 0;
  Color textColor = AppColor.hintColor;

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double screenWidth = MediaQuery.sizeOf(context).width;
    return MultiBlocProvider(
      providers: [
        BlocProvider<ValidCodeBloc>(
          create: (context) => ValidCodeBloc(GetValidCodeUsecase(
              walletRepo: WalletRepoImp(
                  remoteAddMoneyDatasource:
                      RemoteAddMoneyDatasource(dio: widget.dio),
                  remoteGetwalletinfoDatasource:
                      RemoteGetwalletinfoDatasource(dio: widget.dio),
                  remoteCreateWalletDatasource:
                      RemoteCreateWalletDatasource(dio: widget.dio),
                  remoteValidCodeDatasource:
                      RemoteValidCodeDatasource(dio: widget.dio),
                  networkConnection: NetworkConnection(
                      internetConnectionChecker: InternetConnectionChecker()))))
            ..add(GetValidCode()),
        ),
        BlocProvider<AddMoneyBloc>(
          create: (context) => AddMoneyBloc(AddMoneyUsecase(
              walletRepo: WalletRepoImp(
                  remoteGetwalletinfoDatasource:
                      RemoteGetwalletinfoDatasource(dio: widget.dio),
                  remoteCreateWalletDatasource:
                      RemoteCreateWalletDatasource(dio: widget.dio),
                  remoteValidCodeDatasource:
                      RemoteValidCodeDatasource(dio: widget.dio),
                  remoteAddMoneyDatasource:
                      RemoteAddMoneyDatasource(dio: widget.dio),
                  networkConnection: NetworkConnection(
                      internetConnectionChecker:
                          InternetConnectionChecker())))),
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColor.whiteColor,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: screenWidth * 0.02, top: screenHeight * 0.01),
                    child: const BackWidget(),
                  ),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: isEnglish(context)
                            ? EdgeInsets.only(
                                right: screenWidth * 0.125,
                                top: screenHeight * 0.01)
                            : EdgeInsets.only(
                                left: screenWidth * 0.125,
                                top: screenHeight * 0.01),
                        child: Text(
                          'Amount',
                          style: TextStyle(
                              color: AppColor.settingsTitleColor,
                              fontSize: screenWidth * 0.048, //18,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                height: screenHeight * 0.075, //60,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColor.skipTextColor,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    text,
                    style: TextStyle(
                        color: textColor,
                        fontSize: screenWidth * 0.042, //16,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.01,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.04),
                  child: Text(
                    'Select the Code',
                    style: TextStyle(
                        color: AppColor.contentSecondaryTextColor,
                        fontSize: screenWidth * 0.04, //16,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              BlocBuilder<ValidCodeBloc, ValidCodeState>(
                  builder: (context, state) {
                if (state is ValidCodeSuccess) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: state.validCodeEntity.body.length,
                      itemBuilder: (context, index) {
                        String code = state.validCodeEntity.body[index].code;
                        int id = state.validCodeEntity.body[index].id;
                        num amount = state.validCodeEntity.body[index].amount;
                        return buildTextContainer(
                            code, id, amount, screenWidth, screenHeight);
                      },
                    ),
                  );
                } else if (state is ValidCodeFailure) {
                  return Expanded(
                    child: Center(
                      child: FailureUi(
                        onTap: () {
                          context.read<ValidCodeBloc>().add(GetValidCode());
                        },
                      ),
                    ),
                  );
                } else {
                  return const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColor.baseColor,
                      ),
                    ),
                  );
                }
              }),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              AppButton(
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  text: 'Confirm',
                  textColor: AppColor.whiteColor,
                  containerColor: AppColor.buttonColor,
                  onTap: () {
                    if (text != 'choose the code') {
                      showDialog(
                        context: context,
                        barrierColor:
                            AppColor.buttonDetailsColor.withOpacity(0.4),
                        barrierDismissible: false,
                        builder: (context) {
                          return BlocProvider(
                            create: (context) => AddMoneyBloc(AddMoneyUsecase(
                                walletRepo: WalletRepoImp(
                                    remoteGetwalletinfoDatasource:
                                        RemoteGetwalletinfoDatasource(
                                            dio: widget.dio),
                                    remoteCreateWalletDatasource:
                                        RemoteCreateWalletDatasource(
                                            dio: widget.dio),
                                    remoteValidCodeDatasource:
                                        RemoteValidCodeDatasource(
                                            dio: widget.dio),
                                    remoteAddMoneyDatasource:
                                        RemoteAddMoneyDatasource(
                                            dio: widget.dio),
                                    networkConnection: NetworkConnection(
                                        internetConnectionChecker:
                                            InternetConnectionChecker())))),
                            child: Builder(builder: (context) {
                              return Dialog(
                                backgroundColor: AppColor.whiteColor,
                                child: BlocBuilder<AddMoneyBloc, AddMoneyState>(
                                  builder: (context, state) {
                                    if (state is AddMoneyInitial) {
                                      return SizedBox(
                                          width: screenWidth * 0.53, //200,
                                          height: screenHeight * 0.36, //300,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 10),
                                            child: Column(
                                              children: [
                                                Icon(
                                                    Icons.question_mark_rounded,
                                                    color: AppColor.buttonColor,
                                                    size:
                                                        screenWidth * 0.21 //80,
                                                    ),
                                                Text(
                                                  textAlign: TextAlign.center,
                                                  'Are you sure you need to add:',
                                                  style: TextStyle(
                                                    color: AppColor
                                                        .buttonDetailsColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: screenWidth *
                                                        0.04, //16,
                                                  ),
                                                ),
                                                Text(
                                                  textAlign: TextAlign.center,
                                                  '$finalAmount',
                                                  style: TextStyle(
                                                    color: AppColor
                                                        .buttonDetailsColor,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: screenWidth *
                                                        0.04, //16,
                                                  ),
                                                ),
                                                Text(
                                                  textAlign: TextAlign.center,
                                                  'from:',
                                                  style: TextStyle(
                                                    color: AppColor
                                                        .buttonDetailsColor,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: screenWidth *
                                                        0.04, //16,
                                                  ),
                                                ),
                                                Text(
                                                  text,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: AppColor
                                                          .buttonDetailsColor,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      fontSize: screenWidth *
                                                          0.04 //16,
                                                      ),
                                                ),
                                                Expanded(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      //here will be the put bloc...
                                                      GestureDetector(
                                                        onTap: () {
                                                          context
                                                              .read<
                                                                  AddMoneyBloc>()
                                                              .add(AddMoney(
                                                                  code: text));
                                                        },
                                                        child: Container(
                                                          height: screenHeight *
                                                              0.05, // 40,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10),
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                              color: AppColor
                                                                  .buttonColor),
                                                          child: Center(
                                                            child: Text(
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              'confirm',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      screenWidth *
                                                                          0.04, //15,
                                                                  color: AppColor
                                                                      .whiteColor),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            screenWidth * 0.04,
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                          textAlign:
                                                              TextAlign.center,
                                                          'cancel',
                                                          style: TextStyle(
                                                            color: AppColor
                                                                .buttonColor,
                                                            fontSize:
                                                                screenWidth *
                                                                    0.04, // 15
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ));
                                    } else if (state is AddMoneySuccess) {
                                      return SizedBox(
                                        width: screenWidth * 0.533,
                                        height: screenHeight * 0.369,
                                        child: Column(
                                          children: [
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: IconButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  icon: const Icon(
                                                    Icons.close_rounded,
                                                    color: AppColor
                                                        .buttonDetailsColor,
                                                  )),
                                            ),
                                            Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Image.asset(
                                                  AppImages.thinkStart,
                                                ).animate(
                                                  onComplete: (controller) {
                                                    controller.repeat();
                                                  },
                                                ).rotate(
                                                    duration: 3.seconds,
                                                    delay: 1.seconds),
                                                Center(
                                                  child: Icon(
                                                    Icons.check_rounded,
                                                    color: AppColor.checkColor,
                                                    size: screenWidth * 0.213,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              textAlign: TextAlign.center,
                                              'Add Success',
                                              style: TextStyle(
                                                  color: AppColor
                                                      .buttonDetailsColor,
                                                  fontSize: screenWidth *
                                                      0.058, // 22,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Text(
                                              textAlign: TextAlign.center,
                                              'your money has been add successfully',
                                              style: TextStyle(
                                                  color: AppColor.addTextColor,
                                                  fontSize:
                                                      screenWidth * 0.032, //12,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Text(
                                              textAlign: TextAlign.center,
                                              '$finalAmount',
                                              style: TextStyle(
                                                  color: AppColor
                                                      .buttonDetailsColor,
                                                  fontSize:
                                                      screenWidth * 0.032, //12,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            SizedBox(
                                              height: screenHeight * 0.01,
                                            ),
                                            AppButton(
                                                onTap: () {
                                                  //navigate to home? or to the wallet info??
                                                  Navigator.push(
                                                    context,
                                                    PageTransition(
                                                        child: WalletInfoPage(
                                                          dio: widget.dio,
                                                        ),
                                                        type: PageTransitionType
                                                            .fade),
                                                  );
                                                },
                                                screenWidth: screenWidth / 1.2,
                                                screenHeight:
                                                    screenHeight / 1.1,
                                                text: 'Back Home',
                                                textColor: AppColor.whiteColor,
                                                containerColor:
                                                    AppColor.buttonColor),
                                            SizedBox(
                                              height: screenHeight * 0.01,
                                            )
                                          ],
                                        ),
                                      );
                                    } else if (state is AddMoneyFailure) {
                                      return SizedBox(
                                        width: screenWidth * 0.533,
                                        height: screenHeight * 0.369,
                                        child: Column(
                                          children: [
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: IconButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  icon: const Icon(
                                                    Icons.close_rounded,
                                                    color: AppColor
                                                        .buttonDetailsColor,
                                                  )),
                                            ),
                                            Text(
                                              state.message,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: AppColor
                                                      .buttonDetailsColor,
                                                  fontSize:
                                                      screenWidth * 0.058, //22,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Expanded(
                                              child: Center(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    context
                                                        .read<AddMoneyBloc>()
                                                        .add(AddMoney(
                                                            code: text));
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                      color: AppColor.baseColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child: Text(
                                                      textAlign:
                                                          TextAlign.center,
                                                      LocalizationKeys.tryAgain
                                                          .tr(),
                                                      style: TextStyle(
                                                          color: AppColor
                                                              .whiteColor,
                                                          fontSize:
                                                              screenWidth *
                                                                  0.053 //20,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        // child: FailureUi(
                                        //   onTap: () {
                                        //     context
                                        //         .read<AddMoneyBloc>()
                                        //         .add(AddMoney(code: text));
                                        //   },
                                        // ),
                                      );
                                    } else {
                                      return SizedBox(
                                        width: screenWidth * 0.533,
                                        height: screenHeight * 0.369,
                                        child: const Center(
                                          child: CircularProgressIndicator(
                                            color: AppColor.baseColor,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              );
                            }),
                          );
                        },
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('please choose the code first'),
                        backgroundColor: AppColor.snackbarOfflineColor,
                      ));
                    }
                  }),
              SizedBox(
                height: screenHeight * 0.03,
              )
              //button >> to put the amount
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextContainer(String code, int id, num amount, double screenWidth,
      double screenHeight) {
    return GestureDetector(
      onTap: () {
        setState(() {
          text = code;
          finalAmount = amount;
          textColor = AppColor.buttonDetailsColor;
        });
      },
      child: Container(
        height: screenHeight * 0.075, //60,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: AppColor.categoriesContainerColor,
          border: Border.all(color: AppColor.baseColor),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.qr_code,
                    color: AppColor.buttonDetailsColor,
                    size: screenWidth * 0.02 // 15,
                    ),
                SizedBox(
                  width: screenWidth * 0.02,
                ),
                Text(
                  textAlign: TextAlign.center,
                  code,
                  style: TextStyle(
                      color: AppColor.buttonDetailsColor,
                      fontSize: screenWidth * 0.035, //14,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Text(
              textAlign: TextAlign.center,
              'amount: $amount',
              style: TextStyle(
                  color: AppColor.skipTextColor,
                  fontWeight: FontWeight.w600,
                  fontSize: screenWidth * 0.04 //16,
                  ),
            )
          ],
        ),
      ),
    );
  }
}
