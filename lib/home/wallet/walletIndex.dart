// ignore_for_file: file_names, non_constant_identifier_names, unrelated_type_equality_checks, unused_field

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wallet/data/coinGecko/CoinGeckoDataItem.dart';
import 'package:flutter_wallet/data/coinGecko/coinGeckoDataList.dart';
import 'package:flutter_wallet/data/userInfoData.dart';
import 'package:flutter_wallet/data/walletOperationes/walletGetBalance.dart';
import 'package:flutter_wallet/home/wallet/walletBtns.dart';
import 'package:flutter_wallet/home/wallet/walletCoin.dart';
import 'package:flutter_wallet/home/wallet/walletOptions.dart';
import 'package:flutter_wallet/plugins/publicData.dart';
import 'package:flutter_wallet/plugins/publicUtils.dart';
import 'package:flutter_wallet/plugins/router.dart';
import 'package:flutter_wallet/plugins/showDiaologController.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

final logger = Logger();

var verticalSizedBox = SizedBox(
  height: 10.h,
);

class WalletIndexPage extends StatefulWidget {
  const WalletIndexPage({super.key});

  @override
  State<WalletIndexPage> createState() => _WalletIndexPageState();
}

class _WalletIndexPageState extends State<WalletIndexPage> {
  RxInt left_walletIconIndex = 0.obs;
  RxInt right_walletIconIndex = 0.obs;

  CoinGeckoDataListController coinGeckoDataListController = Get.find();
  UserInfoData userInfoData = Get.find();
  ShowDiaologController showDiaologController = Get.find();
  final WalletGetBalance walletGetBalance = WalletGetBalance();
  List<CoinGeckoDataItem> left_walletIconList = <CoinGeckoDataItem>[];

  Rx<WalletAddressInfo> right_walletAddressInfo = WalletAddressInfo(
      walletAddressList: [],
      personalPrivateKey: [],
      walletName: [],
      passWord: []).obs;

  RxMap<String, double> balances = <String, double>{}.obs;

  @override
  void initState() {
    super.initState();
    left_walletIconList = userInfoData.chooseCurrencyData;
    right_walletIconIndex = userInfoData.chooseWalletIndex;
    setLeftIconIndex();
    everAll([left_walletIconIndex], (callback) {
      updateWalletAddressArr();
      initBalances();
    });
    updateWalletAddressArr();
  }

  setLeftIconIndex() {
    var tempWalletNetworkIndex = userInfoData.chooseNetworkIndex.value;
    left_walletIconIndex.value = tempWalletNetworkIndex;
  }

  initBalances() async {
    Map<String, double> tempBalances = await walletGetBalance.getBalance(
      right_walletAddressInfo.value.walletAddressList,
      left_walletIconList[left_walletIconIndex.value].symbol.toUpperCase(),
    );

    if (tempBalances.isNotEmpty) {
      Logger().w(tempBalances);
      balances.value = tempBalances;
    }
  }

  updateWalletAddressArr() {
    right_walletAddressInfo.value =
        userInfoData.allWalletAddressList[left_walletIconIndex.value];
    balances.value = {};
    initBalances();
  }

  void _importPrivateKey(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String privateKey = '';
        return AlertDialog(
          title: const Center(
            child: Text('导入私钥'),
          ),
          content: TextField(
            onChanged: (value) {
              privateKey = value;
            },
            decoration: const InputDecoration(hintText: "输入私钥"),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child: const Text('取消'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('导入'),
                  onPressed: () {
                    Logger().i(_isValidPrivateKey(privateKey));
                    if (_isValidPrivateKey(privateKey)) {
                      var item = userInfoData
                          .chooseCurrencyData[left_walletIconIndex.value];
                      var networkName = item.name;
                      var passWord = userInfoData
                          .allWalletAddressList[left_walletIconIndex.value]
                          .passWord[userInfoData.chooseWalletIndex.value];
                      userInfoData.addWalletAddressByPrivateKey(
                          privateKey, networkName, passWord, item);
                      setState(() {
                        updateWalletAddressArr();
                      });
                    }
                    else
                    {
                      showDiaologController.showSnackBar("私钥不符合要求", '', 2);

                    }
                    Navigator.of(context).pop();
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }

  bool _isValidPrivateKey(String privateKey) {
    final pattern = RegExp(r'^[a-fA-F0-9]{64}$');
    return pattern.hasMatch(privateKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            _showBottomSheet(context);
            initBalances();
          },
          icon: Image.asset(
            "assets/wallet/btn_more.png",
            width: 16.w,
            height: 14.h,
          ),
        ),
        title: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            color: PublicData.colorE7F5F5,
          ),
          child: GestureDetector(
            onTap: () {
              logger.i("选择其他链");
              _showBottomSheet(context);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(
                    () => Text(
                      left_walletIconList[userInfoData.chooseNetworkIndex.value]
                          .symbol
                          .toUpperCase(),
                      style: TextStyle(
                        color: PublicData.color131313,
                        fontSize: PublicData.textSize_14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 7.h,
                  ),
                  Image.asset(
                    "assets/wallet/btn_xia.png",
                    width: 10.w,
                    height: 6.h,
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed(RouteJumpConfig.QR_ScannerPage);
            },
            icon: Image.asset(
              "assets/public/icon_public_scan.png",
              width: 18.w,
              height: 18.w,
            ),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 9.r),
        child: Column(
          children: [
            const walletCoin(),
            SizedBox(
              height: 9.h,
            ),
            const walletBtns(),
            SizedBox(
              height: 9.h,
            ),
            const walletOptions(),
          ],
        ),
      ),
    );
  }

  _setWalletListLeftItem(int index, CoinGeckoDataItem data) {
    return InkWell(
      onTap: () {
        left_walletIconIndex.value = index;
      },
      child: Obx(
        () {
          return Container(
            decoration: BoxDecoration(
              color: left_walletIconIndex.value == index
                  ? Colors.blue
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20.r),
            ),
            padding: EdgeInsets.all(3.r),
            margin: EdgeInsets.symmetric(vertical: 10.r),
            child: GetImageCoinByUrl(
              url: data.image,
              width: 35.w,
              height: 35.w,
            ),
          );
        },
      ),
    );
  }

  _setWalletAddressItem(
    int index,
    WalletAddressInfo wallet_addressInfo,
  ) {
    String walletName = wallet_addressInfo.walletName[index];
    String walletAddress = wallet_addressInfo.walletAddressList[index];
    double? coinNum = balances.isNotEmpty ? balances[walletAddress] : 0.0;
    Logger().i("coinNum   $coinNum  address  $walletAddress");
    bool isCurWallet = false;

    if (left_walletIconIndex.value == userInfoData.chooseNetworkIndex.value) {
      if (index == right_walletIconIndex.value) {
        isCurWallet = true;
      } else {
        isCurWallet = false;
      }
    } else {
      isCurWallet = false;
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      child: InkWell(
        onTap: () {
          right_walletIconIndex.value = index;
          userInfoData.setChooseNetWorkAndWallet(
              left_walletIconIndex.value, right_walletIconIndex.value);
          Get.back();
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  PublicData.color6BB8BA,
                  PublicData.color01888A,
                ]),
            borderRadius: BorderRadius.circular(20.r),
          ),
          padding: EdgeInsets.all(14.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    walletName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: PublicData.textSize_16,
                    ),
                  ),
                  isCurWallet
                      ? const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 20,
                          weight: 800,
                        )
                      : const SizedBox(),
                ],
              ),
              GestureDetector(
                onTap: () {
                  right_walletIconIndex.value = index;
                  userInfoData.chooseNetworkIndex.value =
                      left_walletIconIndex.value;
                  Navigator.of(context).pop();
                },
                behavior: HitTestBehavior.translucent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      shortenEthereumAddress(walletAddress),
                      style: TextStyle(
                        fontSize: PublicData.textSize_11,
                        fontWeight: FontWeight.w400,
                        color: PublicData.colorB9DFE0,
                      ),
                    ),
                    SizedBox(
                      width: 9.w,
                    ),
                    IconButton(
                      onPressed: () {
                        logger.i("复制地址");
                        copyToClipboard(walletAddress);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Copied to clipboard')),
                        );
                      },
                      icon: Image.asset(
                        "assets/wallet/btn_copy.png",
                        width: 9.w,
                        height: 11.h,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "$coinNum \$",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: PublicData.textSize_30,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _showBottomSheet(BuildContext context) {
    setLeftIconIndex();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.h),
              decoration: BoxDecoration(
                color: PublicData.colorF2F9F9,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "管理",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: PublicData.color4DA7A9,
                            fontSize: PublicData.textSize_14,
                          ),
                        ),
                      ),
                      Text(
                        "钱包列表",
                        style: TextStyle(
                          color: PublicData.color131313,
                          fontSize: PublicData.textSize_14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(),
                    ],
                  ),
                  SizedBox(height: 10.h), // 添加间距
                  Container(
                    alignment: Alignment.topCenter,
                    height: 550.h,
                    child: Obx(
                      () => Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 40.w,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: left_walletIconList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return _setWalletListLeftItem(
                                          index, left_walletIconList[index]);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Obx(
                            () => Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                  children: [
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: right_walletAddressInfo
                                          .value.walletAddressList.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return _setWalletAddressItem(
                                          index,
                                          right_walletAddressInfo.value,
                                        );
                                      },
                                    ),
                                    verticalSizedBox,
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            _importPrivateKey(context);
                                          },
                                          behavior: HitTestBehavior.translucent,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 15.w,
                                              vertical: 10.h,
                                            ),
                                            child: Text(
                                              "导入钱包",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                    PublicData.textSize_16,
                                                color: PublicData.color131313,
                                              ),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Logger().i("创建钱包");
                                            var item =
                                                userInfoData.chooseCurrencyData[
                                                    left_walletIconIndex.value];
                                            var networkName = item.name;
                                            var passWord =
                                                userInfoData
                                                        .allWalletAddressList[
                                                            left_walletIconIndex
                                                                .value]
                                                        .passWord[
                                                    userInfoData
                                                        .chooseWalletIndex
                                                        .value];
                                            userInfoData
                                                .addWalletAddressByWeb3Dart(
                                                    networkName,
                                                    passWord,
                                                    item);
                                            setState(() {
                                              updateWalletAddressArr();
                                            });
                                          },
                                          behavior: HitTestBehavior.translucent,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 15.w,
                                              vertical: 10.h,
                                            ),
                                            child: Text(
                                              "创建钱包",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                    PublicData.textSize_16,
                                                color: PublicData.color131313,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
