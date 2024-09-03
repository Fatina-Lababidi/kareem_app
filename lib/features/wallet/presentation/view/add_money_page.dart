import 'package:careem_app_clean/core/network/network_connection.dart';
import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/widgets/app_button.dart';
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
import 'package:careem_app_clean/features/wallet/presentation/widgets/addMoney_appBar.dart';
import 'package:careem_app_clean/features/wallet/presentation/widgets/failure_dailog.dart';
import 'package:careem_app_clean/features/wallet/presentation/widgets/inital_dialog.dart';
import 'package:careem_app_clean/features/wallet/presentation/widgets/loading_dialog.dart';
import 'package:careem_app_clean/features/wallet/presentation/widgets/success_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

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
              AddMoneyAppBar(screenWidth: screenWidth, screenHeight: screenHeight),
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
                                      return InitialDialogAddMoney(
                                          screenWidth: screenWidth,
                                          screenHeight: screenHeight,
                                          finalAmount: finalAmount,
                                          text: text);
                                    } else if (state is AddMoneySuccess) {
                                      return SuccessDialogAddMoney(
                                          screenWidth: screenWidth,
                                          screenHeight: screenHeight,
                                          finalAmount: finalAmount);
                                    } else if (state is AddMoneyFailure) {
                                      return FailureDialogAddMoney(
                                          errorMessage: state.message,
                                          screenWidth: screenWidth,
                                          screenHeight: screenHeight,
                                          text: text);
                                    } else {
                                      return LoadingDialogAddMoney(
                                          screenWidth: screenWidth,
                                          screenHeight: screenHeight);
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
        height: screenHeight * 0.09, //60,
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
                    size: screenWidth * 0.02),
                SizedBox(
                  width: screenWidth * 0.02,
                ),
                Text(
                  overflow: TextOverflow.ellipsis,
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
              overflow: TextOverflow.ellipsis,
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
