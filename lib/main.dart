
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wallet/plugins/getXAllControllerBinding.dart';
import 'package:flutter_wallet/plugins/router.dart';
import 'package:flutter_wallet/plugins/theme_data.dart';
import 'package:flutter_wallet/splashScreen.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  // 初始化应用，确保需要提前初始化的插件或依赖能正常使用
  WidgetsFlutterBinding.ensureInitialized();
  // 初始化GetStorage 插件
  await GetStorage.init();

  // 用于设置系统的 UI 覆盖样式。这个方法允许你自定义状态栏、导航栏等系统 UI 元素的外观
  // SystemChrome.setSystemUIOverlayStyle(
  //   const SystemUiOverlayStyle(
  //     // 设置状态栏颜色
  //     statusBarColor: Colors.transparent,
  //     // 设置导航栏颜色
  //     statusBarIconBrightness: Brightness.light,
  //   ),
  // );

  /// 用于设置应用程序支持的屏幕方向 portraitUp:竖屏  portraitDown:横屏
  /// DeviceOrientation.portrait: 竖屏，设备直立。
  /// DeviceOrientation.portraitUp: 竖屏，设备头部朝上。
  /// DeviceOrientation.portraitDown: 竖屏，设备头部朝下。
  /// DeviceOrientation.landscape: 横屏，设备直立。
  /// DeviceOrientation.landscapeLeft: 横屏，设备左侧朝上。
  /// DeviceOrientation.landscapeRight: 横屏，设备右侧朝上。
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // if (Platform.isAndroid) {
    
  //   //.instance = SurfaceAndroidWebView();/* 你的 Android 平台实现 */;
  // } else if (Platform.isIOS) {
  //   InAppWebViewPlatform.instance = /* 你的 iOS 平台实现 */;
  // }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    EasyLoading.instance
      ..radius = 8
      ..maskType = EasyLoadingMaskType.black
      ..displayDuration = const Duration(seconds: 2)
      ..userInteractions = false
      ..indicatorType = EasyLoadingIndicatorType.ring
      ..backgroundColor = const Color(0xFF333333);

    return ScreenUtilInit(
      // 设计尺寸，通常是设计稿的尺寸
      designSize: const Size(360, 780),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return KeyboardVisibilityProvider(
          child: GetMaterialApp(
            // 全局参数的绑定，比如市场行情
            initialBinding: AllControllerBinding(),
            // 用于设置全局默认的页面过渡效果
            defaultTransition: Transition.fade,
            theme: appThemeData,
            // 配置相应的路由规则
            getPages: RouteJumpConfig.getPages,
            // 是否显示Debug标识，false：不显示，true：显示
            debugShowCheckedModeBanner: false,
            // 初始化EasyLoading
            builder: EasyLoading.init(),
            // 设置第一个启动界面
            // initialRoute: !isLogged
            //     ? RouteJumpConfig.loginOrRegister
            //     : RouteJumpConfig.home,
            // 起始页
            home: const SplashScreen(),
          ),
        );
      },
    );
  }
}
