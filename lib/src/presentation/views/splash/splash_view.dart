import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/utils/constants/constants_manager.dart';
import '../../../core/utils/resources/assets_manager.dart';
import '../../../core/utils/resources/color_manager.dart';
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
    super.initState();
  }

  // MAP BOX Initialize

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
