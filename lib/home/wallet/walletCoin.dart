// ignore_for_file: file_names, camel_case_types, unnecessary_null_comparison

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wallet/data/userInfoData.dart';
import 'package:flutter_wallet/data/walletOperationes/walletGetBalance.dart';
import 'package:flutter_wallet/home/wallet/walletIndex.dart';
import 'package:flutter_wallet/plugins/publicData.dart';
import 'package:flutter_wallet/plugins/publicUtils.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

/// 显示
class walletCoin extends StatefulWidget {
  const walletCoin({super.key});

  @override
  State<walletCoin> createState() => _walletCoinState();
}

class _walletCoinState extends State<walletCoin> {
  late Timer _timer;
  final UserInfoData userInfoData = Get.find();
  final coinNum = 0.0.obs;
  final WalletGetBalance walletGetBalance = WalletGetBalance();
  final walletAddress = ''.obs;
  final walletName = ''.obs;
  final walletCoinType = ''.obs;

  @override
  initState() {
    super.initState();
    everAll([userInfoData.chooseNetworkIndex, userInfoData.chooseWalletIndex],
        (callback) {
      updateWalletAddress();
    });
    updateWalletAddress();

    // 创建每隔 5 秒执行一次的 Timer
    _timer = Timer.periodic(const Duration(seconds: 60), (timer) {
      // getBalance();
    });
  }

  getBalance() async {
    Map<String, double> balances = await walletGetBalance
        .getBalance([walletAddress.value], walletCoinType.value);
    if (balances.isNotEmpty) {
      coinNum.value = balances[walletAddress.value]!;
      Logger().i("coinNum.value  ${coinNum.value}");
    }
  }

  // 更新钱包地址
  void updateWalletAddress() {
    walletAddress.value = userInfoData.getWalletAddress(
      userInfoData.chooseNetworkIndex.value,
      userInfoData.chooseWalletIndex.value,
    );
    walletCoinType.value = userInfoData
        .chooseCurrencyData[userInfoData.chooseNetworkIndex.value].symbol
        .toUpperCase();
    walletName.value = userInfoData.getWalletName(
        userInfoData.chooseNetworkIndex.value,
        userInfoData.chooseWalletIndex.value);
    Logger().w("userInfoData.getWalletAddress() 2 ${walletAddress.value} ");
    getBalance(); // 更新地址后重新获取余额
  }

  @override
  void dispose() {
    if (_timer == null) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              PublicData.color6BB8BA,
              PublicData.color01888A,
            ]),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  walletName.value,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: PublicData.textSize_16,
                  ),
                ),
                Text(
                  walletCoinType.value,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    fontSize: PublicData.textSize_16,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                logger.i("复制地址");
                copyToClipboard(walletAddress.value);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Copied to clipboard')),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    shortenEthereumAddress(walletAddress.value),
                    style: TextStyle(
                      fontSize: PublicData.textSize_11,
                      fontWeight: FontWeight.w400,
                      color: PublicData.colorB9DFE0,
                    ),
                  ),
                  SizedBox(
                    width: 9.w,
                  ),
                  Image.asset(
                    "assets/wallet/btn_copy.png",
                    width: 9.w,
                    height: 11.h,
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${coinNum.value}" "\$",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: PublicData.textSize_30,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    logger.i("查看其他余额");
                  },
                  icon: Image.asset(
                    "assets/wallet/btn_right.png",
                    width: 22.w,
                    height: 22.w,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
