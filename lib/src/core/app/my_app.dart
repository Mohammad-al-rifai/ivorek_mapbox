import 'package:flutter/material.dart';

import '../../presentation/views/splash/splash_view.dart';
import '../themes/themes_manager.dart';
import '../utils/resources/strings_manager.dart';

class MyApp extends StatefulWidget {
  // named Constructor

  const MyApp._internal();

  static const MyApp _instance =
      MyApp._internal(); // Singleton or Single Instance.

  factory MyApp() => _instance; //factory

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.ivorekMap,
      debugShowCheckedModeBanner: false,
      theme: getApplicationTheme(),
      home: const SplashView(),
    );
  }
}
