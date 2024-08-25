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
  // final sharedPreferences = await SharedPreferences.getInstance();
  // final dio = Dio();
  // await init();
  await setupconfig();
  await config.allReady();
  runApp(EasyLocalization(
    supportedLocales: const [
      Locale('en'),
      Locale('ar'),
    ],
    path: 'assets/translation',
    fallbackLocale: const Locale('en'),
    child: MyApp(
        // sharedPreferences: sharedPreferences,
        // dio: dio,
        ),
  ));
}

class MyApp extends StatelessWidget {
  // final Dio dio;
  // final SharedPreferences sharedPreferences;
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

//! log in :
// 0222222222 //paPa12@121212
//work:
//0444444444 //saSA@11112222
//emoliter:
//0111111111// Satasa!111111
//? what business logic means ??
//! the interlPhoneField packge not validate ....
//kotlen ??

//TODO:
// don't have an account in log in so navigate to sign up
// contact us :exist in back and ui

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
