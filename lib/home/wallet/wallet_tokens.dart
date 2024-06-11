// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wallet/data/coinGecko/CoinGeckoDataItem.dart';
import 'package:flutter_wallet/data/coinGecko/coinGeckoAPI.dart';
import 'package:flutter_wallet/data/userInfoData.dart';
import 'package:flutter_wallet/data/walletOperationes/walletGetBalance.dart';
import 'package:flutter_wallet/plugins/publicData.dart';
import 'package:flutter_wallet/plugins/publicUtils.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class WalletTokens extends StatefulWidget {
  const WalletTokens({super.key});

  @override
  State<WalletTokens> createState() => _WalletTokensState();
}

class _WalletTokensState extends State<WalletTokens> {
  CoinGeckoAPI coinGeckoAPI = Get.find();
  UserInfoData userInfoData = Get.find();
  final WalletGetBalance walletGetBalance = WalletGetBalance();

  RxList<tokensItem> coinTokenList = <tokensItem>[].obs;

  @override
  initState() {
    super.initState();
    everAll([userInfoData.chooseNetworkIndex, userInfoData.chooseWalletIndex],
        (callback) {
      updateCoinItem();
    });
    updateCoinItem();
  }

  updateCoinItem() {
    CoinGeckoDataItem item =
        userInfoData.chooseCurrencyData[userInfoData.chooseNetworkIndex.value];
    coinTokenList.value = [];
    tokensItem item1 = tokensItem(
      icon: item.image,
      name: item.symbol.toUpperCase(),
      num: 0,
      price: 0.0,
      id: item.id,
    );
    coinTokenList.add(item1);
    getCoinNum();
    getCoinPrice();
  }

  getCoinPrice() async {
    for (var i = 0; i < coinTokenList.length; i++) {
      double price = await coinGeckoAPI.getCoinPrice(coinTokenList[i].id);
      Logger().i(price);
      setState(() {
        coinTokenList[i].price = price;
      });
    }
  }

  getCoinNum() async {
    Map<String, double> tempBalances = await walletGetBalance.getBalance(
      userInfoData.allWalletAddressList[userInfoData.chooseNetworkIndex.value]
          .walletAddressList,
      userInfoData
          .chooseCurrencyData[userInfoData.chooseNetworkIndex.value].symbol
          .toUpperCase(),
    );

    if (tempBalances.isNotEmpty) {
      Logger().w(tempBalances);
      for (var i = 0; i < coinTokenList.length; i++) {
        if (coinTokenList[i].name ==
            userInfoData
                .chooseCurrencyData[userInfoData.chooseNetworkIndex.value]
                .symbol
                .toUpperCase()) {
          var tempWallet = userInfoData
              .allWalletAddressList[userInfoData.chooseNetworkIndex.value]
              .walletAddressList[userInfoData.chooseWalletIndex.value];
          setState(() {
            coinTokenList[i].num = tempBalances[tempWallet]!;
          });
          Logger().i("coinTokenList[i].num   ${coinTokenList[i].num }");
        }
        
      }
    }
  }

  Widget haveData() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: ListView.builder(
        itemCount: coinTokenList.length,
        itemBuilder: (context, index) {
          var item = coinTokenList[index];
          return Container(
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GetImageCoinByUrl(
                      url: item.icon,
                      width: 35.w,
                      height: 35.w,
                    ),
                    SizedBox(
                      width: 15.w,
                    ),
                    Text(
                      item.name,
                      style: TextStyle(
                          fontSize: PublicData.textSize_16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "${item.num}",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontSize: PublicData.textSize_20,
                      ),
                    ),
                    Text(
                      "\$${item.price * item.num}",
                      style: TextStyle(
                        color: PublicData.color01888A,
                        fontSize: PublicData.textSize_12,
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget noData() {
    return ListView(
      shrinkWrap: true,
      children: [
        Column(
          children: [
            Image.asset(
              "assets/wallet/tokens/notokensData.png",
              width: 193.w,
              height: 166.h,
            ),
            SizedBox(
              height: 8.h,
            ),
            Text(
              "开启代币探索之旅",
              style: TextStyle(
                fontSize: PublicData.textSize_16,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(
              height: 8.h,
            ),
            Text(
              "你可以在xxToken App轻松买币，也可以从交易所或个人钱包转入代币",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: PublicData.textSize_12,
                color: PublicData.color4DA7A9,
              ),
            ),
            SizedBox(
              height: 8.h,
            ),
            ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    PublicData.color01888A), // 设置背景色
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7.r), // 设置圆角值
                  ),
                ),
                // 其他样式属性
              ),
              child: Text(
                "获取代币",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: PublicData.textSize_16,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Expanded(
        child: coinTokenList.isNotEmpty ? haveData() : noData(),
      );
    });
  }
}

class tokensItem {
  String icon;
  String name;
  double num;
  double price;
  String id;

  tokensItem({
    required this.icon,
    required this.name,
    required this.num,
    required this.price,
    required this.id,
  });
}
