import 'package:careem_app_clean/core/network/network_connection.dart';
import 'package:careem_app_clean/core/resources/asset.dart';
import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/resources/string.dart';
import 'package:careem_app_clean/core/widgets/failure_widget.dart';
import 'package:careem_app_clean/features/wallet/data/datasource/remote_add_money_datasource.dart';
import 'package:careem_app_clean/features/wallet/data/datasource/remote_create_wallet_datasource.dart';
import 'package:careem_app_clean/features/wallet/data/datasource/remote_getWalletInfo_datasource.dart';
import 'package:careem_app_clean/features/wallet/data/datasource/remote_valid_code_datasource.dart';
import 'package:careem_app_clean/features/wallet/data/repositories/wallet_repo_imp.dart';
import 'package:careem_app_clean/features/wallet/domain/usecase/get_wallet_info_usecase.dart';
import 'package:careem_app_clean/features/wallet/presentation/view/add_money_page.dart';
import 'package:careem_app_clean/features/wallet/presentation/view/create_new_wallet_page.dart';
import 'package:careem_app_clean/features/wallet/presentation/walletInfo_bloc/wallet_info_bloc.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:page_transition/page_transition.dart';

class WalletInfoPage extends StatelessWidget {
  final Dio dio;
  const WalletInfoPage({super.key, required this.dio});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double screenWidth = MediaQuery.sizeOf(context).width;
    return BlocProvider(
      create: (context) => WalletInfoBloc(GetWalletInfoUsecase(
          walletRepo: WalletRepoImp(
              remoteAddMoneyDatasource: RemoteAddMoneyDatasource(dio: dio),
              remoteValidCodeDatasource: RemoteValidCodeDatasource(dio: dio),
              remoteCreateWalletDatasource:
                  RemoteCreateWalletDatasource(dio: dio),
              remoteGetwalletinfoDatasource:
                  RemoteGetwalletinfoDatasource(dio: dio),
              networkConnection: NetworkConnection(
                  internetConnectionChecker: InternetConnectionChecker()))))
        ..add(GetWalletInfo()),
      child: Scaffold(
        backgroundColor: AppColor.whiteColor,
        body: SafeArea(
          child: BlocConsumer<WalletInfoBloc, WalletInfoState>(
            listener: (context, state) {
              if (state is WalletInfoFailure) {
                print("message: ${state.message}");
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColor.snackbarOfflineColor,
                  ),
                );
              } else if (state is WalletInfoSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('success'),
                    backgroundColor: AppColor.baseColor,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is WalletInfoSuccess) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: screenHeight * 0.05,
                      ),
                      addMoneyContainer(screenWidth, screenHeight, context)
                          .animate()
                          .fade(duration: .2.seconds, delay: .1.seconds),
                      SizedBox(
                        height: screenHeight * 0.04,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // the first container
                          moneyDetailsContainer(
                            screenHeight,
                            screenWidth,
                            state.walletInfoEntity.body.balance.toString(),
                            LocalizationKeys.availableBalance.tr(),
                          ),
                          // second container
                          moneyDetailsContainer(
                            screenHeight,
                            screenWidth,
                            '00', //!!from where?
                            LocalizationKeys.totalExpend.tr(),
                          ),
                        ],
                      ).animate().fade(duration: .4.seconds, delay: .2.seconds),
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                      Text(
                        LocalizationKeys.transections.tr(),
                        style: TextStyle(
                            color: AppColor.contentSecondaryTextColor,
                            fontSize: screenWidth * 0.04, //16,
                            fontWeight: FontWeight.w500),
                      ).animate().fade(duration: .6.seconds, delay: .3.seconds),
                      //this history?? or what ?
                    ],
                  ),
                );
              } else if (state is WalletInfoFailure) {
                if (state.message == 'PLEASE CREATE WALLET FIRST') {
                  return noWalletFailureUi(screenHeight, screenWidth, context);
                } else {
                  return Center(
                    child: FailureUi(
                      onTap: () {
                        context.read<WalletInfoBloc>().add(GetWalletInfo());
                      },
                    ),
                  );
                }
              } else {
                return const Center(
                    child: CircularProgressIndicator(
                  color: AppColor.baseColor,
                ));
              }
            },
          ),
        ),
      ),
    );
  }

//? Add money button:

  Align addMoneyContainer(
      double screenWidth, double screenHeight, BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        width: screenWidth * 0.48, //170,
        height: screenHeight * 0.08, //54,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColor.buttonColor,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: InkWell(
          onTap: () {
            //navigate to the add page
            Navigator.push(
                context,
                PageTransition(
                    child: AddMoneyPage(
                      dio: dio,
                    ),
                    type: PageTransitionType.fade));
          },
          child: Center(
            child: Text(
              textAlign: TextAlign.center,
              LocalizationKeys.addMoney.tr(),
              style: TextStyle(
                  color: AppColor.buttonColor,
                  fontSize: screenWidth * 0.04, //16,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }

//? row buttons:

  Container moneyDetailsContainer(double screenHeight, double screenWidth,
      String textMoney, String textDiscription) {
    return Container(
      width: screenWidth * 0.45, //170,
      height: screenHeight * 0.21, //145,
      decoration: BoxDecoration(
          color: AppColor.categoriesContainerColor,
          border: Border.all(color: AppColor.baseColor),
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            textAlign: TextAlign.center,
            textMoney,
            //   state.walletInfoEntity.body.balance.toString(),
            style: TextStyle(
                color: AppColor.buttonDetailsColor,
                fontSize: screenWidth * 0.07, //28,
                fontWeight: FontWeight.w500),
          ), //from back
          Text(
            textAlign: TextAlign.center,
            textDiscription,
            //LocalizationKeys.availableBalance.tr(),
            style: TextStyle(
                color: AppColor.buttonDetailsColor,
                fontSize: screenWidth * 0.035, //14,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

//? failure because don't having wallet:

  Center noWalletFailureUi(
      double screenHeight, double screenWidth, BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Image.asset(
          AppImages.walletImage,
          width: screenWidth * 0.27, //100,
        ).animate().shake(duration: .5.seconds, delay: .1.seconds),
        SizedBox(
          height: screenHeight * 0.04,
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                PageTransition(
                    child: CreateNewWalletPage(dio: dio),
                    type: PageTransitionType.fade));
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColor.baseColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              textAlign: TextAlign.center,
              'create wallet',
              style: TextStyle(
                  color: AppColor.whiteColor, fontSize: screenWidth * 0.05 //20,
                  ),
            ),
          ),
        ),
      ]),
    );
  }
}
