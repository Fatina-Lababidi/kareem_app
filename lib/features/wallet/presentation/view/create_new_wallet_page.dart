import 'package:careem_app_clean/core/network/network_connection.dart';
import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/resources/string.dart';
import 'package:careem_app_clean/core/widgets/app_button.dart';
import 'package:careem_app_clean/core/widgets/app_textFormField.dart';
import 'package:careem_app_clean/core/widgets/back_row_widget.dart';
import 'package:careem_app_clean/features/wallet/data/datasource/remote_add_money_datasource.dart';
import 'package:careem_app_clean/features/wallet/data/datasource/remote_create_wallet_datasource.dart';
import 'package:careem_app_clean/features/wallet/data/datasource/remote_getWalletInfo_datasource.dart';
import 'package:careem_app_clean/features/wallet/data/datasource/remote_valid_code_datasource.dart';
import 'package:careem_app_clean/features/wallet/data/repositories/wallet_repo_imp.dart';
import 'package:careem_app_clean/features/wallet/domain/entities/create_wallet_entity.dart';
import 'package:careem_app_clean/features/wallet/domain/usecase/create_wallet_usecase.dart';
import 'package:careem_app_clean/features/wallet/presentation/createWallet_bloc/create_wallet_bloc.dart';
import 'package:careem_app_clean/features/wallet/presentation/view/wallet_info_page.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateNewWalletPage extends StatefulWidget {
  final Dio dio;
  final SharedPreferences sharedPreferences;
  const CreateNewWalletPage(
      {super.key, required this.dio, required this.sharedPreferences});

  @override
  State<CreateNewWalletPage> createState() => _CreateNewWalletPageState();
}

class _CreateNewWalletPageState extends State<CreateNewWalletPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _securityCodeController = TextEditingController();
  final TextEditingController _confirmSecurityCodeController =
      TextEditingController();
  final TextEditingController _bankAccount = TextEditingController();

  bool securityCodeObscure = true;
  bool confirmSecurityCodeObscure = true;

  @override
  void dispose() {
    _securityCodeController.dispose();
    _confirmSecurityCodeController.dispose();
    _bankAccount.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    await widget.sharedPreferences.setBool('haveWallet', true);
    print(widget.sharedPreferences.getBool('haveWallet'));
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double screenWidth = MediaQuery.sizeOf(context).width;
    return BlocProvider(
      create: (context) => CreateWalletBloc(CreateWalletUsecase(
          walletRepo: WalletRepoImp(
              remoteAddMoneyDatasource:
                  RemoteAddMoneyDatasource(dio: widget.dio),
              remoteValidCodeDatasource:
                  RemoteValidCodeDatasource(dio: widget.dio),
              remoteGetwalletinfoDatasource:
                  RemoteGetwalletinfoDatasource(dio: widget.dio),
              remoteCreateWalletDatasource:
                  RemoteCreateWalletDatasource(dio: widget.dio),
              networkConnection: NetworkConnection(
                  internetConnectionChecker: InternetConnectionChecker())))),
      child: Scaffold(
        backgroundColor: AppColor.whiteColor,
        body: SafeArea(
          child: BlocListener<CreateWalletBloc, CreateWalletState>(
            listener: (context, state) {
              if (state is CreateWalletFailure) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColor.snackbarOfflineColor,
                ));
              } else if (state is CreateWalletSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColor.baseColor,
                ));
                // save a boolean to use it in the payment page:
                _save();
                Navigator.push(
                    context,
                    PageTransition(
                        child: WalletInfoPage(
                          dio: widget.dio,
                          sharedPreferences: widget.sharedPreferences,
                        ),
                        type: PageTransitionType.fade));
              }
            },
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: screenWidth * 0.02, top: screenHeight * 0.01),
                    child: const BackWidget(),
                  ),
                  Text(
                    LocalizationKeys.createNewWallet.tr(),
                    style: TextStyle(
                        fontSize: screenWidth / 375 * 24, //24,
                        fontWeight: FontWeight.w600,
                        color: AppColor.buttonDetailsColor),
                  ).animate().fade(duration: .2.seconds, delay: .1.seconds),
                  SizedBox(
                    height: screenHeight * 0.03,
                  ),
                  AppTextFormField(
                    obscurepassword: securityCodeObscure,
                    secretPasswordIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          securityCodeObscure = !securityCodeObscure;
                        });
                      },
                      icon: securityCodeObscure == false
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility),
                      color: AppColor.detailsTextColor,
                    ),
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                    hintText: LocalizationKeys.enterYourSecurityCode.tr(),
                    textColor: Colors.black,
                    hintColor: Colors.grey,
                    containerColor: Colors.white,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return LocalizationKeys.securityValidate
                            .tr(); //change this
                      } else if (value.length < 8) {
                        return LocalizationKeys.securityCodeTooShort.tr();
                      } else if (!RegExp(r'^(?=.*?[A-Za-z])(?=.*?[0-9]).{8,}$')
                          .hasMatch(value)) {
                        return LocalizationKeys.securityCodeInvalid.tr();
                      }
                      return null;
                    },
                    controller: _securityCodeController,
                  ).animate().fade(duration: .4.seconds, delay: .2.seconds),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  AppTextFormField(
                    obscurepassword: confirmSecurityCodeObscure,
                    secretPasswordIcon: IconButton(
                      onPressed: () {
                        setState(
                          () {
                            confirmSecurityCodeObscure =
                                !confirmSecurityCodeObscure;
                          },
                        );
                      },
                      icon: confirmSecurityCodeObscure == false
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility),
                      color: AppColor.detailsTextColor,
                    ),
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                    hintText:
                        LocalizationKeys.enterYourConfirmSecurityCode.tr(),
                    textColor: Colors.black,
                    hintColor: Colors.grey,
                    containerColor: Colors.white,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return LocalizationKeys.confirmSecurityValidate.tr();
                      } else if (value != _securityCodeController.text) {
                        return LocalizationKeys.securityCodeMisMatch.tr();
                      }
                      return null;
                    },
                    controller: _confirmSecurityCodeController,
                  ).animate().fade(duration: .6.seconds, delay: .3.seconds),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  AppTextFormField(
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                    hintText: LocalizationKeys.enterYourBankAccount.tr(),
                    textColor: Colors.black,
                    hintColor: Colors.grey,
                    containerColor: Colors.white,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return LocalizationKeys.bankAccountValidate.tr();
                      }
                      return null;
                    },
                    controller: _bankAccount,
                  ).animate().fade(duration: .8.seconds, delay: .4.seconds),
                  SizedBox(
                    height: screenHeight * 0.03,
                  ),
                  BlocBuilder<CreateWalletBloc, CreateWalletState>(
                      builder: (context, state) {
                    if (state is CreateWalletLoding) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColor.buttonColor,
                        ),
                      );
                    } else {
                      return AppButton(
                        screenHeight: screenHeight,
                        screenWidth: screenWidth,
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            print('Form is valid');
                            CreateWalletEntity wallet = CreateWalletEntity(
                                securityCode: _securityCodeController.text,
                                confirmSecurityCode:
                                    _confirmSecurityCodeController.text,
                                bankAccount: _bankAccount.text);
                            print('${wallet.securityCode}\n ${wallet.confirmSecurityCode}\n${wallet.bankAccount}');
                            context
                                .read<CreateWalletBloc>()
                                .add(CreateNewWallet(wallet: wallet));
                            // context.read<ChangePasswordBloc>().add(
                            //     ChangeUserPasswordEvent(
                            //         currentPassword:
                            //             _currentPasswordController
                            //                 .text,
                            //         newPassword:
                            //             _newpasswordController.text,
                            //         confirmPassword:
                            //             _confirmPasswordController
                            //                 .text));
                          }
                        },
                        text: LocalizationKeys.create.tr(),
                        textColor: AppColor.whiteColor,
                        containerColor: AppColor.buttonColor,
                      ).animate().fade(duration: 1.seconds, delay: .5.seconds);
                    }
                  })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
