import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox/src/core/app/my_app.dart';
import 'package:mapbox/src/data/data_sources/local/cache/cache_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  await dotenv.load(fileName: "assets/config/.env");

  runApp(MyApp());
}
