// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wallet/plugins/publicData.dart';
import 'package:flutter_wallet/plugins/router.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

var textStyle = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.w400,
  fontSize: PublicData.textSize_14,
);

class MineIndexPage extends StatelessWidget {
  const MineIndexPage({super.key});

  Widget ButtonItem(MineButtonItem data) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        data.onPressed();
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        padding: EdgeInsets.all(10.r),
        child: Padding(
          padding: EdgeInsets.only(left: 25.w, right: 25.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    data.imageUrl,
                    width: data.width,
                    height: data.height,
                  ),
                  SizedBox(
                    width: 20.w,
                  ),
                  Text(
                    data.name,
                    style: textStyle,
                  ),
                ],
              ),
              Image.asset(
                "assets/browse/browse_right.png",
                width: 8.w,
                height: 12.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<MineButtonItem> btnListLevel1 = getListByLevel(0);
    List<MineButtonItem> btnListLevel2 = getListByLevel(1);
    List<MineButtonItem> btnListLevel3 = getListByLevel(2);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(),
            Text(
              "我",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: PublicData.textSize_16,
                color: PublicData.color131313,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Image.asset(
                "assets/mine/icon_message.png",
                width: 16.w,
                height: 17.h,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        color: PublicData.colorF2F9F9,
        child: SingleChildScrollView(
          primary: true,
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    btnListLevel1.map((item) => ButtonItem(item)).toList(),
              ),
              SizedBox(
                height: 15.h,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    btnListLevel2.map((item) => ButtonItem(item)).toList(),
              ),
              SizedBox(
                height: 15.h,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    btnListLevel3.map((item) => ButtonItem(item)).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MineButtonItem {
  final String name;
  final String imageUrl;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final int level;

  MineButtonItem({
    required this.name,
    required this.imageUrl,
    required this.onPressed,
    required this.width,
    required this.height,
    required this.level,
  });
}

List<MineButtonItem> allButtonList = [
  MineButtonItem(
    name: '管理钱包',
    imageUrl: 'assets/mine/icon_wallet_management.png',
    onPressed: () {
      Logger().i("管理钱包");
      Get.toNamed(RouteJumpConfig.manageWalletsPage);
    },
    width: 21.w,
    height: 21.w,
    level: 0,
  ),
  MineButtonItem(
    name: '地址本',
    imageUrl: 'assets/mine/icon_adress.png',
    onPressed: () {
      Logger().i("地址本");
      Get.toNamed(RouteJumpConfig.addressBook);
    },
    width: 21.w,
    height: 21.w,
    level: 1,
  ),
  MineButtonItem(
    name: '使用设置',
    imageUrl: 'assets/mine/icon_set.png',
    onPressed: () {
      Logger().i("使用设置");
    },
    width: 21.w,
    height: 21.w,
    level: 1,
  ),
  MineButtonItem(
    name: '探索',
    imageUrl: 'assets/mine/icon_explore.png',
    onPressed: () {
      Logger().i("探索");
    },
    width: 21.w,
    height: 17.h,
    level: 1,
  ),
  MineButtonItem(
    name: '帮助与反馈',
    imageUrl: 'assets/mine/icon_help.png',
    onPressed: () {
      Logger().i("帮助与反馈");
    },
    width: 21.w,
    height: 19.h,
    level: 2,
  ),
  MineButtonItem(
    name: '钱包指南',
    imageUrl: 'assets/mine/icon_wallet_guide.png',
    onPressed: () {
      Logger().i("钱包指南");
    },
    width: 21.w,
    height: 21.w,
    level: 2,
  ),
  MineButtonItem(
    name: '用户协议',
    imageUrl: 'assets/mine/icon_user.png',
    onPressed: () {
      Logger().i("用户协议");
    },
    width: 21.w,
    height: 21.h,
    level: 2,
  ),
  MineButtonItem(
    name: '关于我们',
    imageUrl: 'assets/mine/icon_about_us.png',
    onPressed: () {
      Logger().i("关于我们");
    },
    width: 21.w,
    height: 21.w,
    level: 2,
  ),
];
List<MineButtonItem> getListByLevel(int level) {
  final List<MineButtonItem> tempList = [];
  for (MineButtonItem item in allButtonList) {
    if (item.level == level) {
      tempList.add(item);
    }
  }
  return tempList;
}
