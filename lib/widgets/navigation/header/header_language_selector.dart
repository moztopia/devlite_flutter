import 'package:flutter/material.dart';
import 'package:devlite_flutter/everything.dart';

class HeaderLanguageSelector extends StatelessWidget {
  const HeaderLanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final LocalizationService localizationService = LocalizationService();
    final Configuration config = Configuration();

    final List<String> availableLanguages =
        (config.getKey('language.available') as List?)?.cast<String>() ?? [];

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: PopupMenuButton<String>(
        onSelected: (String selectedLanguage) {
          mozPrint(
              'Selected language: $selectedLanguage', 'LANGUAGE', 'SELECTOR');
          localizationService.setCurrentLocale(selectedLanguage);
        },
        itemBuilder: (BuildContext context) {
          return availableLanguages.map((String langCode) {
            return PopupMenuItem<String>(
              value: langCode,
              child: Text(langCode.toUpperCase()),
            );
          }).toList();
        },
        child: ValueListenableBuilder<String>(
          valueListenable: localizationService.localeNotifier,
          builder: (context, currentLangCode, child) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                currentLangCode.toUpperCase(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
