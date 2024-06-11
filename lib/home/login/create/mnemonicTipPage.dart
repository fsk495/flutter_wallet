// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wallet/data/userInfoData.dart';
import 'package:flutter_wallet/plugins/localDataController.dart';
import 'package:flutter_wallet/plugins/publicData.dart';
import 'package:flutter_wallet/plugins/publicUtils.dart';
import 'package:flutter_wallet/plugins/router.dart';
import 'package:get/get.dart';


class MnemonicTipPage extends StatefulWidget {
  const MnemonicTipPage({super.key});

  @override
  State<MnemonicTipPage> createState() => _MnemonicTipPageState();
}

class _MnemonicTipPageState extends State<MnemonicTipPage> {
  final UserInfoData userInfoData = Get.find();
  final LocalDataController localDataController = Get.find();

  @override
  void initState() {
    // createWalletInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Positioned.fill(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 50.h,
                ),
                Image.asset(
                  "assets/login/mnemonic_title.png",
                  width: 148.w,
                  height: 157.h,
                ),
                SizedBox(
                  height: 49.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "备份助记词，保障钱包安全",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: PublicData.textSize_20,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "当更换手机或重装应用时，你将需要助记词 (12 个英文单词) 恢复钱包。为保障钱包安全，请务必尽快完成助记词备份。",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: PublicData.textSize_14,
                          color: PublicData.color01888A,
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        "重要提示：",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: PublicData.textSize_14,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Text(
                        "获得助记词等于拥有钱包资产所有权。",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: PublicData.textSize_14,
                          color: PublicData.color01888A,
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Text(
                        "如何安全地备份助记词?",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: PublicData.textSize_14,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        "· 使用纸笔，按正确次序抄写助记词。",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: PublicData.textSize_14,
                          color: PublicData.color01888A,
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        "· 将助记词保管至安全的地方。",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: PublicData.textSize_14,
                          color: PublicData.color01888A,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 33.h,
          child: Column(
            children: [
              PublicFloatingActionButtonLocation(
                title: '立即备份',
                callback: () {
                  Get.toNamed(RouteJumpConfig.remarksMnemonic);
                },
                isCanClick: true,
                containerHeight: 46.h,
                fontSize: PublicData.textSize_16,
              ),
              TextButton(
                onPressed: () {
                  Get.offAllNamed(RouteJumpConfig.home);
                },
                child: Text(
                  "稍后再说",
                  style: TextStyle(
                    color: PublicData.color01888A,
                    fontWeight: FontWeight.w400,
                    fontSize: PublicData.textSize_16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
