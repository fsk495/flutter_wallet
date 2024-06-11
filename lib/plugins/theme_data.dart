import 'package:flutter/material.dart';
import 'package:flutter_wallet/plugins/publicData.dart';

/// 设置应用全局的背景颜色以及其他样式
ThemeData get appThemeData => ThemeData(
      // primarySwatch: createMaterialColor(MColor.white),
      appBarTheme: appBarTheme,
      // 设置应用的背景颜色
      scaffoldBackgroundColor:
          PublicData.colorF2F9F9, 
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      // // 设置底部导航栏的样式
      // bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      //   // 背景颜色
      //   backgroundColor: Color.fromRGBO(20, 25, 37, 1.0),
      //   // 阴影高度
      //   elevation: 8.0,
      //   // 设置图标的样式
      //   selectedIconTheme: IconThemeData(
      //     color: Colors.white,
      //     size: 30.0,
      //   ),
      //   unselectedIconTheme: IconThemeData(
      //     color: Colors.green,
      //     size: 30.0,
      //   ),
      // ),
    );

AppBarTheme get appBarTheme => const AppBarTheme();
