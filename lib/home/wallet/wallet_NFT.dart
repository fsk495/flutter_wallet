// ignore_for_file: file_names, unused_element

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wallet/data/NFT/NFTDataItem.dart';
import 'package:flutter_wallet/data/coinGecko/coinGeckoAPI.dart';
import 'package:flutter_wallet/plugins/publicData.dart';
import 'package:flutter_wallet/plugins/publicUtils.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class WalletNFT extends StatefulWidget {
  const WalletNFT({super.key});

  @override
  State<WalletNFT> createState() => _WalletNFTState();
}

class _WalletNFTState extends State<WalletNFT> {
  RxList<NFTDataItem> allNFTDataList = <NFTDataItem>[].obs;

  CoinGeckoAPI coinGeckoAPI = Get.find();
  @override
  void initState() {
    super.initState();
    fetchNFTData();
  }

  Future<void> fetchNFTData() async {
    allNFTDataList.value = coinGeckoAPI.allNFTDataList;

    Logger().i("allNFTDataList.value   $allNFTDataList");
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Obx(
        () => SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Column(
              children: allNFTDataList.map((item) {
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
                        "0",
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
