import 'package:careem_app_clean/config/dependency_injection.dart';
import 'package:careem_app_clean/features/authentication/data/datasource/remote/remote_user.dart';
import 'package:careem_app_clean/features/authentication/data/repositories/auth_repository_imp.dart';
import 'package:careem_app_clean/features/authentication/domain/usecases/register_user.dart';
import 'package:careem_app_clean/features/authentication/presentation/register_bloc/register_bloc_bloc.dart';
import 'package:careem_app_clean/features/splash/presentation/view/careem_splash_screen.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await setupconfig();
  await config.allReady();
  runApp(
    EasyLocalization(
        supportedLocales: const [
          Locale('en'),
          Locale('ar'),
        ],
        path: 'assets/translation',
        fallbackLocale: const Locale('en'),
        child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Dio dio = Dio();

    final sharedPreferences = config<SharedPreferences>();
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => RegisterBloc(
              RegisterUserUseCase(
                repository: AuthRepositoryImpl(
                  internetConnectionChecker: InternetConnectionChecker(),
                  sharedPreferences: sharedPreferences,
                  remoteDataSource: RemoteUserDataSourceImpl(dio: dio),
                ),
              ),
            ),
          ),
        ],
        child: CareemSplashPage(
          dio: dio,
          sharedPreferences: sharedPreferences,
        ),
      ),
    );
  }
}

//? what business logic means ??
//kotlen ??
//TODO
//? have wallet shared need to fix in better way
//? localization (setting /pop)
//? passing MediaQuery
//?!!  is it true to make every call contain all this instance ? use singlton?(provider!!)

//0222222222// paPa12@121212// securitycode for wallet : paPa12@121212
//0333333333 //maMa22@121212