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
    child:const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          StreamProvider(
            create: (context) => CheckConnect().connection.stream,
            initialData: Status.online,
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const OnBoarding(),
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

  void _incrementCounter() async {
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
            Text(LocalizationKeys.onboardingDescription1A.tr()),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            ElevatedButton(
              onPressed: _incrementCounter,
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: LocalizationKeys.skip.tr(),
      //   child: Padding(
      //     padding: isEnglish(context)
      //         ? EdgeInsets.only(right: 10)
      //         : EdgeInsets.only(left: 10),
      //     child: const Icon(Icons.add),
      //   ),
      // ),
    );
  }
}
//IntroductionScreen



