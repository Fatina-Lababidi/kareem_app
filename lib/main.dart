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
  runApp(EasyLocalization(
    supportedLocales: const [
      Locale('en'),
      Locale('ar'),
    ],
    path: 'assets/translation',
    fallbackLocale: const Locale('en'),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Dio dio = Dio();
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double screenWidth = MediaQuery.sizeOf(context).width;
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
          screenHeight: screenHeight,
          screenWidth: screenWidth,
        ),
      ),
    );
  }
}
//?!!  is it true to make every call contain all this instance ? use singlton?(provider!!)

//log in :
// 0222222222 //paPa12@121212

//? what business logic means ??
//! the interlPhoneField packge not validate ....
//kotlen ??

//TODO:
// don't have an account in log in so navigate to sign up

class NextPage extends StatelessWidget {
  final int id;
  const NextPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text(id.toString()),
      ),
    );
  }
}
