// ignore_for_file: file_names, non_constant_identifier_names, unused_element, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wallet/data/coinGecko/CoinGeckoDataItem.dart';
import 'package:flutter_wallet/data/coinGecko/coinGeckoDataList.dart';
import 'package:flutter_wallet/data/userInfoData.dart';
import 'package:flutter_wallet/plugins/publicData.dart';
import 'package:flutter_wallet/plugins/publicUtils.dart';
import 'package:flutter_wallet/plugins/router.dart';
import 'package:get/get.dart';

class AddCurrencyPage extends StatefulWidget {
  const AddCurrencyPage({super.key});

  

  @override
  _AddCurrencyPageState createState() => _AddCurrencyPageState();
}

class _AddCurrencyPageState extends State<AddCurrencyPage> {
  CoinGeckoDataListController coinGeckoDataListController = Get.find();
  UserInfoData userInfoData = Get.find();
  String passWord = '';

  _addOrRemoveCurrencyItem(bool add, CoinGeckoDataItem item) {
    setState(() {
      coinGeckoDataListController.addOrRemoveChooseList(add, item);
    });
  }

  Future<void> _createWalletAddress() async {
    userInfoData.generatePublicMnemonic();
    if (coinGeckoDataListController.CoinGeckoDataList_chooseList.isNotEmpty) {
      for (var item in coinGeckoDataListController.CoinGeckoDataList_chooseList) {
        await userInfoData.generateWalletAddressByWeb3Dart(
          item.name,
          "",
          passWord,
          item,
        );
        await Future.delayed(const Duration(milliseconds: 500));  // 每次生成钱包地址后延迟 500 毫秒
      }
    }
  }

  Widget _buildCurrencyButtons() {
    return SingleChildScrollView(
      child: Column(
        children: coinGeckoDataListController.CoinGeckoDataList_allList
            .map((item) => _buildCurrencyButton(item))
            .toList(),
      ),
    );
  }

  Widget _buildCurrencyButton(CoinGeckoDataItem data) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        setState(() {
          data.isClick = !data.isClick;
          _addOrRemoveCurrencyItem(data.isClick, data);
        });
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                GetImageCoinByUrl(
                  url: data.image,
                  width: 35.w,
                  height: 35.w,
                ),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.symbol.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: PublicData.textSize_14,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      data.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: PublicData.textSize_10,
                        color: PublicData.color01888A,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Image.asset(
              data.isDefault
                  ? "assets/login/addCurrency_0.png"
                  : (data.isClick
                      ? "assets/login/addCurrency_2.png"
                      : "assets/login/addCurrency_1.png"),
              width: 17.w,
              height: 17.w,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>;
    final bool isToHome = args['toHome'];
    passWord = args['password'];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "添加币种",
          style: TextStyle(
            color: PublicData.color131313,
            fontSize: PublicData.textSize_16,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            left: 0,
            right: 0,
            bottom: 120.h,
            child: _buildCurrencyButtons(),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                      Text(
                        "请选择需要添加到钱包的账户(多选)",
                        style: TextStyle(
                          color: PublicData.color01888A,
                          fontWeight: FontWeight.w400,
                          fontSize: PublicData.textSize_12,
                        ),
                      ),
                      const SizedBox(width: 5),
                    ],
                  ),
                ),
                Obx(
                  () => PublicFloatingActionButtonLocation(
                    title: '确认',
                    callback: () async {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return const Dialog(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                      );

                      await Future.delayed(const Duration(milliseconds: 500));
                      await _createWalletAddress();
                      Get.back();

                      isToHome
                          ? Get.offAllNamed(RouteJumpConfig.home)
                          : Get.toNamed(RouteJumpConfig.mnemonicTip);
                    },
                    isCanClick: coinGeckoDataListController
                        .CoinGeckoDataList_chooseList.isNotEmpty,
                    containerHeight: 46.h,
                    fontSize: PublicData.textSize_16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

