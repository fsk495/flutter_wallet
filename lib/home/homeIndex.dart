// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wallet/data/userInfoData.dart';
import 'package:flutter_wallet/home/browse/browseIndex.dart';
import 'package:flutter_wallet/home/market/marketIndex.dart';
import 'package:flutter_wallet/home/mine/mineIndex.dart';
import 'package:flutter_wallet/home/wallet/walletIndex.dart';
import 'package:flutter_wallet/plugins/localDataController.dart';
import 'package:flutter_wallet/plugins/otherDataController.dart';
import 'package:flutter_wallet/plugins/publicData.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

final List<Widget> pages = [
  const WalletIndexPage(),
  const MarketIndexPage(),
  const BrowseIndexPage(),
  const MineIndexPage(),
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final UserInfoData userInfoData = Get.find();
  final LocalDataController saveInfoController = Get.find();
  final OtherDataController otherDataController = Get.find();

  @override
  void initState() {
    super.initState();
    var mnemonic = saveInfoController.loadData("mnemonic");
    if (mnemonic != null) {
      Logger().w("HomePage  mnemonic $mnemonic ");
      userInfoData.setMnemonic(mnemonic);
    }
  }

  final List<String> _imageUnSelectedPaths = [
    "assets/bottomItem/wallet_unselected.png",
    "assets/bottomItem/market_unselected.png",
    "assets/bottomItem/brow_unselected.png",
    "assets/bottomItem/mine_unselected.png",
  ];
  final List<String> _imageSelectedPaths = [
    "assets/bottomItem/wallet_selected.png",
    "assets/bottomItem/market_selected.png",
    "assets/bottomItem/brow_selected.png",
    "assets/bottomItem/mine_selected.png",
  ];

  List<BottomNavigationBarItem> get barItemList {
    return [
      BottomNavigationBarItem(
        icon: Image.asset(
          otherDataController.selectedHomeIndex.value == 0
              ? _imageSelectedPaths[0]
              : _imageUnSelectedPaths[0],
          width: 24.w,
          height: 24.w,
        ),
        label: "钱包",
      ),
      BottomNavigationBarItem(
        icon: Image.asset(
          otherDataController.selectedHomeIndex.value == 1
              ? _imageSelectedPaths[1]
              : _imageUnSelectedPaths[1],
          width: 24.w,
          height: 24.w,
        ),
        label: "市场",
      ),
      BottomNavigationBarItem(
        icon: Image.asset(
          otherDataController.selectedHomeIndex.value == 2
              ? _imageSelectedPaths[2]
              : _imageUnSelectedPaths[2],
          width: 24.w,
          height: 24.w,
        ),
        label: "浏览",
      ),
      BottomNavigationBarItem(
        icon: Image.asset(
          otherDataController.selectedHomeIndex.value == 3
              ? _imageSelectedPaths[3]
              : _imageUnSelectedPaths[3],
          width: 24.w,
          height: 24.w,
        ),
        label: "我",
      ),
    ];
  }

  void setSelectedIndex(int value) {
    otherDataController.setHomeIndex(value);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: pages[otherDataController.selectedHomeIndex.value],
        bottomNavigationBar: BottomNavigationBarTheme(
          data: BottomNavigationBarThemeData(
            selectedItemColor: PublicData.color01888A,
            unselectedItemColor: PublicData.color4DA7A9,
            selectedLabelStyle: TextStyle(
              fontSize: PublicData.textSize_9, // 调整选中状态下的字体大小
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: PublicData.textSize_9, // 调整未选中状态下的字体大小
              fontWeight: FontWeight.normal,
            ),
          ),
          child: SizedBox(
            height: 49.r, // 设置底部导航栏的高度为56
            child: BottomNavigationBar(
              currentIndex: otherDataController.selectedHomeIndex.value,
              items: barItemList,
              onTap: setSelectedIndex,
            ),
          ),
        ),
      ),
    );
  }
}
