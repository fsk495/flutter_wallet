// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wallet/data/coinGecko/CoinGeckoDataItem.dart';
import 'package:flutter_wallet/data/coinGecko/coinGeckoDataList.dart';
import 'package:flutter_wallet/data/userInfoData.dart';
import 'package:flutter_wallet/data/walletOperationes/walletGetBalance.dart';
import 'package:flutter_wallet/plugins/publicData.dart';
import 'package:flutter_wallet/plugins/publicUtils.dart';
import 'package:flutter_wallet/plugins/showDiaologController.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class ManageWalletsPage extends StatefulWidget {
  const ManageWalletsPage({super.key});

  @override
  State<ManageWalletsPage> createState() => _ManageWalletsPageState();
}

class _ManageWalletsPageState extends State<ManageWalletsPage> {
  RxInt left_walletIconIndex = 0.obs;
  RxInt right_walletIconIndex = 0.obs;

  CoinGeckoDataListController coinGeckoDataListController = Get.find();
  UserInfoData userInfoData = Get.find();
  final WalletGetBalance walletGetBalance = WalletGetBalance();
  List<CoinGeckoDataItem> left_walletIconList = <CoinGeckoDataItem>[];

  ShowDiaologController showDiaologController = Get.find();

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
        title: Text(
          "管理钱包",
          style: TextStyle(
            color: PublicData.color131313,
            fontSize: PublicData.textSize_14,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: getBackLastInterfaceButton(),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        // height: 550.h,
        padding: EdgeInsets.only(right: 10.w,left: 10.w,top: 5.h,bottom: 10.h),//symmetric(horizontal: 15.w,vertical: 20.h),
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
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: left_walletIconList.length,
                        itemBuilder: (BuildContext context, int index) {
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
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: right_walletAddressInfo
                              .value.walletAddressList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return _setWalletAddressItem(
                              index,
                              right_walletAddressInfo.value,
                            );
                          },
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    fontSize: PublicData.textSize_16,
                                    color: PublicData.color131313,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Logger().i("创建钱包");
                               try {
                                  var item = userInfoData.chooseCurrencyData[
                                    left_walletIconIndex.value];
                                var networkName = item.name;
                                var passWord = userInfoData
                                        .allWalletAddressList[
                                            left_walletIconIndex.value]
                                        .passWord[
                                    userInfoData.chooseWalletIndex.value];
                                userInfoData.addWalletAddressByWeb3Dart(
                                    networkName, passWord, item);
                                setState(() {
                                  updateWalletAddressArr();
                                });
                               } catch (e) {
                                 showDiaologController.showSnackBar("$e", '', 10);
                               }
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
                                    fontSize: PublicData.textSize_16,
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
    // Logger().i("coinNum   $coinNum  address  $walletAddress");
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
                  // right_walletIconIndex.value = index;
                  // userInfoData.chooseNetworkIndex.value =
                  //     left_walletIconIndex.value;
                  // Navigator.of(context).pop();
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
                        Logger().i("复制地址");
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
}
