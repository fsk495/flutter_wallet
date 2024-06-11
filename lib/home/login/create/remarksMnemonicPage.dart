// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wallet/data/userInfoData.dart';
import 'package:flutter_wallet/plugins/publicData.dart';
import 'package:flutter_wallet/plugins/publicUtils.dart';
import 'package:flutter_wallet/plugins/router.dart';
import 'package:get/get.dart';

Widget intervalSizedBox = SizedBox(
  height: 10.h,
);

class RemarksMnemonicPage extends StatelessWidget {
  const RemarksMnemonicPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 获取屏幕宽度
    double screenWidth = MediaQuery.of(context).size.width;
    // 设定容器宽度和高度
    double containerWidth = screenWidth - (20.w * 2);
    double containerHeight = containerWidth / 1.8; // 保持1.8倍的宽高比
    UserInfoData userInfoData = Get.find();
    Widget getGrid() {
      var words = userInfoData.localMnemonic.value.split(' ');

      BorderRadius isCircularByIndex(int index) {
        BorderRadius radius = BorderRadius.zero;
        if (index == 0 || index == 2 || index == 9 || index == 11) {
          if (index == 0) {
            radius = BorderRadius.only(topLeft: Radius.circular(10.r));
          } else if (index == 2) {
            radius = BorderRadius.only(topRight: Radius.circular(10.r));
          } else if (index == 9) {
            radius = BorderRadius.only(bottomLeft: Radius.circular(10.r));
          } else if (index == 11) {
            radius = BorderRadius.only(bottomRight: Radius.circular(10.r));
          }
        }

        return radius;
      }

      return Container(
        width: containerWidth,
        height: containerHeight,
        decoration: BoxDecoration(
          color: PublicData.colorE7F5F5,
          borderRadius: BorderRadius.circular(10.r), // 圆角矩形
        ),
        // padding: const EdgeInsets.all(2), // 宽松的内边距
        child: Wrap(
          spacing: 0, // 水平间距
          runSpacing: 0, // 垂直间距
          children: List.generate(12, (index) {
            return Container(
              width: containerWidth / 3 - 1, // 每个格子的宽度
              height: containerHeight / 4 - 1, // 每个格子的高度
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: PublicData.colorB9DFE0,
                ),
                borderRadius: isCircularByIndex(index),
              ),
              child: Text(
                words[index], // 显示每个单词
                style: TextStyle(
                  fontSize: PublicData.textSize_16,
                  fontWeight: FontWeight.bold,
                  color: PublicData.color333333,
                ),
              ),
            );
          }),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: getBackLastInterfaceButton(),
        actions: [getHelPanelpButton(height: 19.w, width: 18.w)],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    intervalSizedBox,
                    Text(
                      "备份助记词",
                      style: TextStyle(
                        color: PublicData.color333333,
                        fontWeight: FontWeight.w400,
                        fontSize: PublicData.textSize_17,
                      ),
                    ),
                    intervalSizedBox,
                    Text(
                      "请按顺序抄写助记词，确保备份正确。",
                      style: TextStyle(
                        color: PublicData.color01888A,
                        fontWeight: FontWeight.w400,
                        fontSize: PublicData.textSize_13,
                      ),
                    ),
                    intervalSizedBox,
                    intervalSizedBox,
                    getGrid(),
                    intervalSizedBox,
                    intervalSizedBox,
                    Text(
                      "·  妥善保管助记词至隔离网络的安全地方。",
                      style: TextStyle(
                        color: PublicData.color01888A,
                        fontWeight: FontWeight.w400,
                        fontSize: PublicData.textSize_14,
                      ),
                    ),
                    intervalSizedBox,
                    Text(
                      "·  请勿将助记词在联网环境下分享和存储，比如 邮件、相册、社交应用等",
                      style: TextStyle(
                        color: PublicData.color01888A,
                        fontWeight: FontWeight.w400,
                        fontSize: PublicData.textSize_14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                PublicFloatingActionButtonLocation(
                  title: '已确认备份',
                  callback: () {
                    Get.toNamed(RouteJumpConfig.confirmMnemonic);
                  },
                  isCanClick: true,
                  fontSize: PublicData.textSize_16,
                  containerHeight: 46.h,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
