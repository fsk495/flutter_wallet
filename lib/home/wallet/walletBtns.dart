// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wallet/home/wallet/walletIndex.dart';
import 'package:flutter_wallet/plugins/otherDataController.dart';
import 'package:flutter_wallet/plugins/publicData.dart';
import 'package:flutter_wallet/plugins/router.dart';
import 'package:get/get.dart';

// ignore: camel_case_types
class walletBtns extends StatelessWidget {
  const walletBtns({super.key});
  @override
  Widget build(BuildContext context) {
    final OtherDataController otherDataController = Get.find();
    return Container(
      padding: EdgeInsets.all(12.r), // 设置内边距为10.0
      decoration: BoxDecoration(
          border: Border.all(
            color: PublicData.colorD9EFEF, // 设置边框颜色

            width: 2.0, // 设置边框宽度
          ),
          borderRadius: BorderRadius.circular(7.r)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: walletButtonItemList
            .map(
              (item) => InkWell(
                onTap: () {
                  item.onTap(context);
                  if (item.title == "购买") {
                    otherDataController.setHomeIndex(1);
                  }
                },
                child: Column(
                  children: [
                    Image.asset(
                      item.icon,
                      color: Colors.black,
                      width: item.width,
                      height: item.height,
                    ),
                    SizedBox(
                      height: 9.h,
                    ),
                    Text(
                      item.title,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: PublicData.textSize_11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

// ignore: camel_case_types
class walletButtonItem {
  final String title;
  final String icon;
  final double width;
  final double height;
  final Function(BuildContext context) onTap;

  walletButtonItem({
    required this.title,
    required this.icon,
    required this.width,
    required this.height,
    required this.onTap,
  });
}

List<walletButtonItem> walletButtonItemList = [
  walletButtonItem(
    title: "转账",
    icon: "assets/wallet/btn_zhuanzhang.png",
    width: 22.w,
    height: 22.w,
    onTap: (BuildContext context) {
      logger.i("跳转到 转账界面");
      Get.toNamed(RouteJumpConfig.walletTransfer);
    },
  ),
  walletButtonItem(
    title: "收款",
    icon: "assets/wallet/btn_shoukuan.png",
    width: 22.w,
    height: 22.w,
    onTap: (BuildContext context) {
      logger.i("跳转到 收款界面");
      Get.toNamed(RouteJumpConfig.walletPaymentQR);
    },
  ),
  walletButtonItem(
    title: "记录",
    icon: "assets/wallet/btn_record.png",
    width: 22.w,
    height: 22.w,
    onTap: (BuildContext context) {
      logger.i("跳转到 记录界面");
    },
  ),
  walletButtonItem(
    title: "质押",
    icon: "assets/wallet/btn_zhiya.png",
    width: 13.w,
    height: 22.w,
    onTap: (BuildContext context) {
      logger.i("跳转到 质押界面");
    },
  ),
  walletButtonItem(
    title: "购买",
    icon: "assets/wallet/btn_buy.png",
    width: 22.w,
    height: 19.w,
    onTap: (BuildContext context) {
      logger.i("跳转到 购买界面");
    },
  ),
];
