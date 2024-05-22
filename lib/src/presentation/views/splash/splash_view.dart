import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';

import '../../../core/utils/constants/constants_manager.dart';
import '../../../core/utils/resources/assets_manager.dart';
import '../../../core/utils/resources/color_manager.dart';
import '../../../data/data_sources/local/cache/cache_helper.dart';
import '../../../data/data_sources/local/cache/keys.dart';
import '../../layouts/home_layout/home_layout.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  Timer? _timer;

  _startDelay() {
    _timer = Timer(
      const Duration(seconds: Constants.splashDelay),
      _goNext,
    );
  }

  _goNext() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const HomeLayout()));
  }

  @override
  void initState() {
    _startDelay();
    initializeLocationAndSave();
    super.initState();
  }

  // MAP BOX Initialize
  void initializeLocationAndSave() async {
    // Ensure all permissions are collected for Locations
    Location location = Location();
    bool? serviceEnabled;
    PermissionStatus? permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
    }

    // Get capture the current user location
    LocationData locationData = await location.getLocation();

    // Store the user location in sharedPreferences

    CacheHelper.saveData(
      key: CacheHelperKeys.latitude,
      value: locationData.latitude!,
    );
    CacheHelper.saveData(
      key: CacheHelperKeys.longitude,
      value: locationData.longitude!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        backgroundColor: ColorManager.white,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: ColorManager.white,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: ColorManager.white,
          systemNavigationBarDividerColor: ColorManager.white,
        ),
      ),
      body: const Center(
        child: Image(
          image: AssetImage(
            ImageAssets.splashLogo,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
