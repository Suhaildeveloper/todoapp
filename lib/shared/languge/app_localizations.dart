import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale? locale;

  AppLocalizations({this.locale});

  static AppLocalizations? of(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations);

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationDelegate();

  late Map<String, String> _localizedString;

  Future loadJsonLanguage() async {
    String jsonString =
        await rootBundle.loadString("assets/lang/${locale!.languageCode}.json");

    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedString =
        jsonMap.map((key, value) => MapEntry(key, value.toString()));
  }

  String translate(String key) => _localizedString[key] ?? "";
}

// class Delegate for translate

class _AppLocalizationDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationDelegate();
  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale: locale);
    await localizations.loadJsonLanguage();
    return localizations;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}

extension TranslateX on String {
  String tr(BuildContext context) => AppLocalizations.of(context)!.translate(this);
}
