import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:udemy_app/layout/home_screen.dart';
import 'package:udemy_app/shared/cubit_observal.dart';
import 'package:udemy_app/shared/languge/app_localizations.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: const [
        Locale('ar'),
        Locale('en')
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (devicelocale, supportedLocales) {
        for (var locale in supportedLocales) {
          if (devicelocale != null &&
              devicelocale.languageCode == locale.languageCode) {
            print(devicelocale);
            return devicelocale;
          }
          return supportedLocales.first;
        }
      },
      home: HomeLayout(),
      debugShowCheckedModeBanner: false,
    );
  }
}
