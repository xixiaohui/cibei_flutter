import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CibeiApp extends ConsumerWidget {
  const CibeiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Cibei Space',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(), // Placeholder — replaced in Task 4
      darkTheme: ThemeData.dark(),
      routerConfig: null, // Placeholder — replaced in Task 5
      locale: const Locale('zh'),
      supportedLocales: const [Locale('zh'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
