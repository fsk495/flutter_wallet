// ignore_for_file: file_names, unused_element

import 'package:flutter/material.dart';
import 'package:flutter_wallet/plugins/localDataController.dart';
import 'package:flutter_wallet/plugins/router.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      _navigateToHome();
    });
  }

  _navigateToHome() async {
    bool isLogged = false;
    final LocalDataController localDataController = Get.find();
    // localDataController.cleanData();
    var mnemonic = localDataController.loadData("mnemonic");
    Logger().w("mnemonic  $mnemonic");

    if (mnemonic == null || mnemonic == '') {
      isLogged = false;
    } else {
      isLogged = true;
    }
    Navigator.pushReplacementNamed(context,
        isLogged ? RouteJumpConfig.home : RouteJumpConfig.loginOrRegister);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlutterLogo(size: 100),
            SizedBox(height: 20),
            Text(
              'Welcome to Wallet',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
