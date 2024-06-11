// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wallet/data/DeFI/DefiDataItem.dart';
import 'package:flutter_wallet/data/coinGecko/coinGeckoAPI.dart';
import 'package:flutter_wallet/plugins/publicData.dart';
import 'package:flutter_wallet/plugins/publicUtils.dart';
import 'package:get/get.dart';

class WalletDeFi extends StatefulWidget {
  const WalletDeFi({super.key});

  @override
  State<WalletDeFi> createState() => _WalletDeFiState();
}

class _WalletDeFiState extends State<WalletDeFi> {

  RxList<DefiDataItem> allDeFiDataList = <DefiDataItem>[].obs;

  CoinGeckoAPI coinGeckoAPI = Get.find();
  @override
  void initState() {
    super.initState();
    fetchNFTData();
  }

  Future<void> fetchNFTData() async {
    allDeFiDataList.value = coinGeckoAPI.allDeFiDataList;
  }


  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Obx(
        () => SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Column(
              children: allDeFiDataList.map((item) {
                return Container(
                  padding: EdgeInsets.all(10.r),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ClipOval(
                            child: GetImageCoinByUrl(
                              url: item.image,
                              width: 32.w,
                              height: 32.w,
                              // fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text(
                            item.name,
                            style: TextStyle(
                              fontSize: PublicData.textSize_12,
                              fontWeight: FontWeight.bold,
                              color: PublicData.color131313,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "\$ ${item.current_price}",
                        style: TextStyle(
                          fontSize: PublicData.textSize_12,
                          fontWeight: FontWeight.bold,
                          color: PublicData.color131313,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
