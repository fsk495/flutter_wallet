import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wallet/data/userInfoData.dart';
import 'package:flutter_wallet/plugins/publicData.dart';
import 'package:flutter_wallet/plugins/publicUtils.dart';
import 'package:get/get.dart';

class WalletPaymentQR extends StatefulWidget {
  const WalletPaymentQR({super.key});

  @override
  State<WalletPaymentQR> createState() => _WalletPaymentQRState();
}

class _WalletPaymentQRState extends State<WalletPaymentQR> {
  final UserInfoData userInfoData = Get.find();

  String walletAddress = '';

  String coinType = '';

  @override
  void initState() {
    walletAddress = userInfoData.getWalletAddress(
      userInfoData.chooseNetworkIndex.value,
      userInfoData.chooseWalletIndex.value,
    );
    var tempCoinType = userInfoData
        .chooseCurrencyData[userInfoData.chooseNetworkIndex.value].symbol
        .toUpperCase();

    coinType = tempCoinType == "BNB" ? "BNB" : "ETH/ERC20";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: getBackLastInterfaceButton(),
        title: Text(
          "收款",
          style: TextStyle(
            fontSize: PublicData.textSize_16,
            color: Colors.white,
          ),
        ),
        backgroundColor: PublicData.color01888A,
        centerTitle: true,
        actions: [
          getHelPanelpButton(height: 19.w, width: 19.w),
        ],
      ),
      backgroundColor: PublicData.color01888A,
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width - (20.w * 2),
            margin: EdgeInsets.all(20.w),
            padding: EdgeInsets.all(40.r),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Text(
                  "仅支持 $coinType  相关资产",
                  style: TextStyle(
                    fontSize: PublicData.textSize_14,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 42.h,
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      "assets/wallet/transfer/payment_qr.png",
                      width: 228.w,
                      height: 228.w,
                    ),
                    GetQRCodeByWalletAddress(
                      walletAddress: walletAddress,
                      size: 192.w,
                    ),
                  ],
                ),
                SizedBox(
                  height: 23.h,
                ),
                Text(
                  "钱包地址",
                  style: TextStyle(
                    fontSize: PublicData.textSize_12,
                    color: PublicData.color4DA7A9,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  walletAddress,
                  style: TextStyle(
                    fontSize: PublicData.textSize_12,
                    color: PublicData.color01888A,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
