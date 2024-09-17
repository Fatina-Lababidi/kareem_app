import 'package:careem_app_clean/core/network/network_connection.dart';
import 'package:careem_app_clean/core/resources/color.dart';
import 'package:careem_app_clean/core/resources/string.dart';
import 'package:careem_app_clean/core/widgets/appBar_widget.dart';
import 'package:careem_app_clean/features/authentication/data/datasource/remote/remote_user.dart';
import 'package:careem_app_clean/features/authentication/data/repositories/auth_repository_imp.dart';
import 'package:careem_app_clean/features/authentication/domain/usecases/change_password.dart';
import 'package:careem_app_clean/features/authentication/presentation/changePassword_bloc/change_password_bloc.dart';
import 'package:careem_app_clean/features/authentication/presentation/view/changePassword.dart';
import 'package:careem_app_clean/features/settings/data/datasource/remote_policy.dart';
import 'package:careem_app_clean/features/settings/data/repositories/policy_repo_imp.dart';
import 'package:careem_app_clean/features/settings/domain/usecase/get_policy.dart';
import 'package:careem_app_clean/features/settings/presentation/policy_bloc/policy_bloc.dart';
import 'package:careem_app_clean/features/settings/presentation/view/change_language.dart';
import 'package:careem_app_clean/features/settings/presentation/view/delete_page.dart';
import 'package:careem_app_clean/features/settings/presentation/view/policy_page.dart';
import 'package:careem_app_clean/features/settings/presentation/view/widgets/settings_options.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  final Dio dio;
  final SharedPreferences sharedPreferences;
  const SettingsPage({
    super.key,
    required this.dio,
    required this.sharedPreferences,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double screenWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: SafeArea(
        child: RefreshIndicator(
          backgroundColor: AppColor.whiteColor,
          color: AppColor.baseColor,
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1));
            setState(() {

            });
          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                AppBarWidget(
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                  textTitle: LocalizationKeys.settingsTitle.tr(),
                ).animate().fade(duration: .2.seconds, delay: .1.seconds),
                SizedBox(
                  height: screenHeight * 0.05,
                ),
                SettingsOption(
                  dio: widget.dio,
                  sharedPreferences: widget.sharedPreferences,
                  text: LocalizationKeys.changePasswordTitle.tr(),
                  child: BlocProvider(
                    create: (context) => ChangePasswordBloc(
                      ChangePasswordUseCase(
                        repository: AuthRepositoryImpl(
                          internetConnectionChecker:
                              InternetConnectionChecker(),
                          remoteDataSource: RemoteUserDataSourceImpl(dio: widget.dio),
                          sharedPreferences: widget.sharedPreferences,
                        ),
                      ),
                    ),
                    child: const ChangePasswordPage(),
                  ),
                ).animate().scaleXY(duration: .25.seconds, delay: .15.seconds),
                SizedBox(
                  height: screenHeight * 0.025,
                ),
                SettingsOption(
                  dio: widget.dio,
                  sharedPreferences: widget.sharedPreferences,
                  text: LocalizationKeys.changeLanguage.tr(),
                  child: ChangeLanguage(
                    sharedPreferences: widget.sharedPreferences,
                  ),
                ).animate().scaleXY(duration: .3.seconds, delay: .2.seconds),
                SizedBox(
                  height: screenHeight * 0.025,
                ),
                SettingsOption(
                  dio: widget.dio,
                  sharedPreferences: widget.sharedPreferences,
                  text: LocalizationKeys.privacyPolicy.tr(),
                  child: BlocProvider<PolicyBloc>(
                    create: (context) => PolicyBloc(
                      GetPolicyUseCase(
                        policyRepo: PolicyRepoImp(
                          remotePolicyDataSource:
                              RemotePolicyDataSource(dio: widget.dio),
                          networkConnection: NetworkConnection(
                            internetConnectionChecker:
                                InternetConnectionChecker(),
                          ),
                        ),
                      ),
                    )..add(GetPolicy()),
                    child: const PolicyPage(),
                  ),
                ).animate().scaleXY(duration: .35.seconds, delay: .25.seconds),
                SizedBox(
                  height: screenHeight * 0.025,
                ),
                SettingsOption(
                        dio: widget.dio,
                        sharedPreferences: widget.sharedPreferences,
                        text: LocalizationKeys.deleteAccount.tr(),
                        child: DeletePage(
                          sharedPreferences: widget.sharedPreferences,
                        ))
                    .animate()
                    .scaleXY(duration: .4.seconds, delay: .35.seconds)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
