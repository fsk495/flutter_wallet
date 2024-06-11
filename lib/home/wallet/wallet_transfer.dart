// ignore_for_file: unused_element

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wallet/data/userInfoData.dart';
import 'package:flutter_wallet/data/walletOperationes/walletTransfer.dart';
import 'package:flutter_wallet/plugins/publicData.dart';
import 'package:flutter_wallet/plugins/publicUtils.dart';
import 'package:flutter_wallet/plugins/router.dart';
import 'package:flutter_wallet/plugins/showDiaologController.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:web3dart/web3dart.dart';

FontWeight publicTextWeight = FontWeight.w400;
Widget intervalSizedBox = SizedBox(
  height: 11.h,
);

class WalletTransferPage extends StatefulWidget {
  const WalletTransferPage({super.key});

  @override
  State<WalletTransferPage> createState() => _WalletTransferPageState();
}

class _WalletTransferPageState extends State<WalletTransferPage> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controllerNum = TextEditingController();
  final TextEditingController _controllerRemark = TextEditingController();

  final UserInfoData userInfoData = Get.find();
  final ShowDiaologController showDiaologController = Get.find();
  final gas = "".obs;

  bool _isKeyboardVisible = false;
  final isCanClick = false.obs;

  late Timer _timer;

  var coinType = '';

  var seconds = 0.obs;

  void _startTimer() {
    const period = Duration(seconds: 1);
    _timer = Timer.periodic(period, (timer) {
      if (seconds.value > 0) {
        seconds--;
      } else {
        // 重置计时器
        _timer.cancel();
        if (seconds.value <= 0) // 重新设置倒计时时间
        {
          Logger().i("是否已经停止倒计时了");
          seconds.value = 0;
          _getGas();
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _controllerNum.dispose();
    _controllerRemark.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // WalletTransfer.sendBNB()
    super.initState();
    coinType = userInfoData
        .chooseCurrencyData[userInfoData.chooseNetworkIndex.value].symbol
        .toUpperCase();
    _getGas();

    KeyboardVisibilityController().onChange.listen((bool visible) {
      setState(() {
        _isKeyboardVisible = visible;
        Logger().i("_isKeyboardVisible   $_isKeyboardVisible");
      });
    });
  }

  _getGas() async {
    EtherAmount gasLimit;
    if(coinType == "NOV")
    {
      gasLimit = await WalletTransfer.getGasPriceByRPCUrl("http://54.80.49.30:8545");
    }
    else{
      gasLimit = await WalletTransfer.getGasPrice(coinType);
    }
    final balanceWei = gasLimit.getInWei.toDouble();
    final balanceDouble = (balanceWei / 1e18).toStringAsFixed(10);
    gas.value = balanceDouble;
    Logger().i("gas.value   ${gas.value}");
    Logger().i("gas.value   ${gasLimit.getInWei}");
    // 在获取完矿工费后重新启动计时器
    seconds.value = 30;
    _startTimer();
  }

  _setCanClick() {
    if (!isValidEthereumAddress(_controller.text.trim())) {
      isCanClick.value = false;
    } else {
      isCanClick.value = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PublicData.colorF2F9F9,
        leading: getBackLastInterfaceButton(),
        centerTitle: true,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "转账",
              style: TextStyle(
                fontWeight: publicTextWeight,
                fontSize: PublicData.textSize_12,
                color: Colors.black,
              ),
            ),
            Text(
              coinType,
              style: TextStyle(
                fontWeight: publicTextWeight,
                fontSize: PublicData.textSize_10,
                color: PublicData.color4DA7A9,
              ),
            ),
          ],
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
      body: Padding(
        padding: EdgeInsets.only(right: 16.w, left: 16.w, top: 10.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '收款地址',
                style: TextStyle(
                  color: PublicData.color4DA7A9,
                  fontWeight: publicTextWeight,
                  fontSize: PublicData.textSize_12,
                ),
              ),
              intervalSizedBox,
              Container(
                padding: EdgeInsets.only(
                  left: 18.w,
                  right: 18.w,
                  top: 5.h,
                  bottom: 5.h,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7.r),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        onChanged: (value) {
                          _setCanClick();
                        },
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: PublicData.textSize_14,
                        ),
                        decoration: InputDecoration(
                          hintText: "输入收款地址",
                          hintStyle: TextStyle(
                            color: PublicData.colorB9DFE0,
                            fontWeight: publicTextWeight,
                            fontSize: PublicData.textSize_14,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Image.asset(
                        "assets/wallet/transfer/transfer_all_address.png",
                        width: 15.w,
                        height: 16.h,
                      ),
                    ),
                  ],
                ),
              ),
              intervalSizedBox,
              intervalSizedBox,
              Text(
                '数量',
                style: TextStyle(
                  color: PublicData.color4DA7A9,
                  fontWeight: publicTextWeight,
                  fontSize: PublicData.textSize_12,
                ),
              ),
              intervalSizedBox,
              Container(
                padding: EdgeInsets.only(
                  left: 18.w,
                  right: 18.w,
                  top: 5.h,
                  bottom: 5.h,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7.r),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _controllerNum,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: PublicData.textSize_14,
                      ),
                      decoration: InputDecoration(
                        hintText: "0",
                        hintStyle: TextStyle(
                          color: PublicData.colorB9DFE0,
                          fontWeight: publicTextWeight,
                          fontSize: PublicData.textSize_14,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                    SizedBox(
                      height: 5.w,
                    ),
                    TextField(
                      controller: _controllerRemark,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: PublicData.textSize_14,
                      ),
                      decoration: InputDecoration(
                        hintText: "备注",
                        hintStyle: TextStyle(
                          color: PublicData.colorB9DFE0,
                          fontWeight: publicTextWeight,
                          fontSize: PublicData.textSize_14,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ],
                ),
              ),
              intervalSizedBox,
              intervalSizedBox,
              Text(
                '矿工费',
                style: TextStyle(
                  color: PublicData.color4DA7A9,
                  fontWeight: publicTextWeight,
                  fontSize: PublicData.textSize_12,
                ),
              ),
              intervalSizedBox,
              Container(
                padding: EdgeInsets.all(7.r),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7.r),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '预估范围',
                          style: TextStyle(
                            color: PublicData.color4DA7A9,
                            fontWeight: publicTextWeight,
                            fontSize: PublicData.textSize_12,
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Image.asset(
                          "assets/wallet/transfer/transfer_refresh.png",
                          width: 10.w,
                          height: 10.w,
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Obx(
                          () => Text(
                            seconds.value <= 0
                                ? "正在更新"
                                : '${seconds.value}秒后更新',
                            style: TextStyle(
                              color: PublicData.colorA2B51C,
                              fontWeight: publicTextWeight,
                              fontSize: PublicData.textSize_10,
                            ),
                          ),
                        ),
                      ],
                    ),
                    intervalSizedBox,
                    Obx(
                      () => Text(
                        "预估费用: ${gas.value} $coinType",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: publicTextWeight,
                          fontSize: PublicData.textSize_14,
                        ),
                      ),
                    ),
                    intervalSizedBox,
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   children: [
                    //     Text(
                    //       '最高费用:  99999 $coinType',
                    //       style: TextStyle(
                    //         color: PublicData.color4DA7A9,
                    //         fontWeight: publicTextWeight,
                    //         fontSize: PublicData.textSize_12,
                    //       ),
                    //     ),
                    //     GestureDetector(
                    //       onTap: () {},
                    //       child: Row(
                    //         children: [
                    //           Text(
                    //             '标准',
                    //             style: TextStyle(
                    //               color: PublicData.color4DA7A9,
                    //               fontWeight: publicTextWeight,
                    //               fontSize: PublicData.textSize_12,
                    //             ),
                    //           ),
                    //           SizedBox(
                    //             width: 5.w,
                    //           ),
                    //           Image.asset(
                    //             "assets/browse/browse_right.png",
                    //             width: 5.w,
                    //             height: 10.h,
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    intervalSizedBox,
                    Container(
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        color: PublicData.colorE7F5F5,
                        border: Border.all(
                          color: PublicData.color8DC2C3,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '最小值: 接近实际需支付的成本',
                                style: TextStyle(
                                  color: PublicData.color01888A,
                                  fontWeight: publicTextWeight,
                                  fontSize: PublicData.textSize_12,
                                ),
                              ),
                              Text(
                                '最大值: 预估的最大费用，可自定义调节',
                                style: TextStyle(
                                  color: PublicData.color01888A,
                                  fontWeight: publicTextWeight,
                                  fontSize: PublicData.textSize_12,
                                ),
                              ),
                            ],
                          ),
                          Image.asset(
                            "assets/wallet/transfer/transfer_close.png",
                            width: 18.w,
                            height: 18.w,
                          ),
                        ],
                      ),
                    ),
                    intervalSizedBox,
                    Container(
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        color: PublicData.colorE7F5F5,
                        border: Border.all(
                          color: PublicData.color8DC2C3,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '矿工费加油站，快速充值 $coinType',
                            style: TextStyle(
                              color: PublicData.color01888A,
                              fontWeight: publicTextWeight,
                              fontSize: PublicData.textSize_12,
                            ),
                          ),
                          Image.asset(
                            "assets/browse/browse_right.png",
                            width: 5.w,
                            height: 10.h,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _isKeyboardVisible
          ? const SizedBox()
          : Obx(
              () => PublicFloatingActionButtonLocation(
                title: '下一步',
                callback: () {
                  Logger().i("转账");
                  showDiaologController.showAlertDialog("提示", "处理中。。。\n请等待",
                      onConfirm: () {
                    Get.back();
                  });
                  WalletTransfer.sendTransaction(
                    _controller.text,
                    _controllerNum.text == '' ? "0" : _controllerNum.text,
                    coinType,
                  );
                  // Get.back();
                  // aboutBlockchainOperations.sendBNB();
                },
                isCanClick: isCanClick.value,
                fontSize: PublicData.textSize_16,
                containerHeight: 46.h,
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
