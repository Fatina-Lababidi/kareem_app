import 'package:careem_app/core/config/check_connect.dart';
import 'package:careem_app/core/functions/language.dart';
import 'package:careem_app/core/resources/string.dart';
import 'package:careem_app/pages/on_boarding.dart';
import 'package:careem_app/widgets/app_Scaffold.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
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
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          StreamProvider<NetworkStatus>(
            create: (context) => CheckConnect().statusStream,
            initialData: NetworkStatus.online,
            catchError: (_, __) => NetworkStatus.offline,
            //!! why when i add this line it don't give me the exeption??
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          home://MapPage()
        // MyHomePage(title: 'dd')
       const OnBoarding(),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _changeLanguage() async {
    if (context.locale.languageCode == 'ar') {
      await context.setLocale(const Locale('en'));
    } else {
      await context.setLocale(const Locale('ar'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(LocalizationKeys.bySigningUp.tr()),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            ElevatedButton(
              onPressed: _changeLanguage,
              child: Padding(
                padding: isEnglish(context)
                    ? EdgeInsets.only(right: 10)
                    : EdgeInsets.only(left: 10),
                child: const Icon(Icons.add),
              ),
            )
          ],
        ),
      ),
    );
  }
}


//!? is it normal to but try and catch in mock ?
//!? in the real service how can i now if am getting the correct data ?
//!? in the ui we validate the textfield so what the benifit of the mock here!!
//!? how i will know if the data i send is sending in the correct form ?
//! internet testing in moking it don't work
//!? is it okay to but default case loading in the bloc ?? in register !!
//? the real service in the register ?
//! fix the align in the localization ..
//?? if the categories came from back how we select the image ??
//! the categories needs token ? how we now that from the postman??
//!! why its don't validate in the phone num package ??
