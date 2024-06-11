// ignore_for_file: file_names, camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wallet/data/addressBookController.dart';
import 'package:flutter_wallet/data/coinGecko/CoinGeckoDataItem.dart';
import 'package:flutter_wallet/data/coinGecko/coinGeckoDataList.dart';
import 'package:flutter_wallet/plugins/publicData.dart';
import 'package:flutter_wallet/plugins/publicUtils.dart';
import 'package:flutter_wallet/plugins/router.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

var verticalSizedBox = SizedBox(
  height: 10.h,
);

class AddressBookPage extends StatefulWidget {
  const AddressBookPage({super.key});

  @override
  State<AddressBookPage> createState() => _AddressBookPageState();
}

class _AddressBookPageState extends State<AddressBookPage> {
  final AddressBookController addressBookController = Get.find();

  CoinGeckoDataListController coinGeckoDataListController = Get.find();

  List<CoinGeckoDataItem> tempCurrencyData = [];

  final RxString addressType = "all".obs;

  @override
  void initState() {
    super.initState();

    tempCurrencyData = coinGeckoDataListController.CoinGeckoDataList_chooseList;
  }

  List<addressItem> filterAddressByType(String type) {
    List<addressItem> temp = [];
    if (type == "all") {
      temp = addressBookController.allAddressInfoList;
    } else {
      for (var i = 0;
          i < addressBookController.allAddressInfoList.length;
          i++) {
        var item = addressBookController.allAddressInfoList[i];
        if (item.type == addressType.value) {
          temp.add(item);
        }
      }
    }
    Logger().i(temp.length);
    Logger().i(type);
    Logger().i(addressBookController.allAddressInfoList.length);
    return temp;
  }

  _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.8,
                padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Column(
                  children: [
                    Text(
                      "请选择钱包网络",
                      style: TextStyle(
                        color: PublicData.color131313,
                        fontSize: PublicData.textSize_18,
                      ),
                    ),
                    verticalSizedBox,
                    Expanded(
                      child: ListView.separated(
                        itemCount: tempCurrencyData.length + 1,
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider(); // 可以根据需求替换为其他分隔符
                        },
                        itemBuilder: (BuildContext context, int index) {
                          if (index == 0) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  // isChooseList[index] = !isChooseList[index];
                                  addressType.value = "all";
                                });
                                Navigator.pop(context); // 关闭底部表单
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.r),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          "assets/mine/icon_set.png",
                                          width: 32.w,
                                          height: 32.w,
                                        ),
                                        SizedBox(
                                          width: 5.w,
                                        ),
                                        Text(
                                          "全部",
                                          style: TextStyle(
                                            color: PublicData.color131313,
                                            fontSize: PublicData.textSize_12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Image.asset(
                                      "assets/mine/address_book_all.png",
                                      width: 8.w,
                                      height: 12.h,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            var item = tempCurrencyData[index - 1];
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  // isChooseList[index] = !isChooseList[index];
                                  addressType.value = item.name;
                                });
                                Navigator.pop(context); // 关闭底部表单
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.r),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        GetImageCoinByUrl(
                                          url: item.image,
                                          width: 32.w,
                                          height: 32.w,
                                        ),
                                        SizedBox(
                                          width: 5.w,
                                        ),
                                        Text(
                                          item.symbol.toUpperCase(),
                                          style: TextStyle(
                                            color: PublicData.color131313,
                                            fontSize: PublicData.textSize_12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Image.asset(
                                      "assets/browse/browse_right.png",
                                      width: 8.w,
                                      height: 12.h,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    verticalSizedBox,
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget noData() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/mine/icon_notData.png',
            width: 87.w,
            height: 74.h,
          ),
          SizedBox(
            height: 14.h,
          ),
          Text(
            "您当前没有添加地址信息",
            style: TextStyle(
              fontSize: PublicData.textSize_12,
              color: PublicData.color4DA7A9,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 35.h,
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Logger().i("添加地址信息");
              Get.toNamed(RouteJumpConfig.addAddressBook);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7.r),
                color: PublicData.color01888A,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 21.w,
                vertical: 13.h,
              ),
              child: Text(
                "点击添加",
                style: TextStyle(
                  fontSize: PublicData.textSize_16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget setAddressItem(addressItem data, int index) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(RouteJumpConfig.addressBookModifyInfo, arguments: index);
      },
      behavior: HitTestBehavior.translucent,
      child: Row(
        children: [
          GetImageCoinByUrl(
            url: data.iconUrl,
            width: 52.w,
            height: 52.w,
          ),
          SizedBox(
            width: 20.w,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.addressName,
                style: TextStyle(
                  fontSize: PublicData.textSize_21,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                shortenEthereumAddress(
                  data.address,
                  leadingChars: 6,
                  trailingChars: 6,
                ),
                style: TextStyle(
                  color: PublicData.color4DA7A9,
                  fontSize: PublicData.textSize_18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget haveData() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(left: 25.w, right: 25.w, top: 10.h),
        child: Column(
          children: addressBookController.allAddressInfoList
              .asMap()
              .entries
              .map((entry) => setAddressItem(entry.value, entry.key))
              .toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: getBackLastInterfaceButton(),
        title: GestureDetector(
          onTap: () {
            Logger().i("选择网络");
            _showBottomSheet(context);
          },
          behavior: HitTestBehavior.translucent,
          child: Column(
            children: [
              Text(
                "地址本",
                style: TextStyle(
                  color: PublicData.color090C0B,
                  fontSize: PublicData.textSize_12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 2.r,
              ),
              Container(
                decoration: BoxDecoration(
                  color: PublicData.colorE7F5F5,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Obx(
                        () => Text(
                          addressType.value == "all"
                              ? "所有网络"
                              : addressType.value,
                          style: TextStyle(
                            color: PublicData.color01888A,
                            fontSize: PublicData.textSize_10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Image.asset(
                        "assets/mine/icon_xia_green.png",
                        width: 7.w,
                        height: 4.h,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              Logger().i("添加地址信息");
              Get.toNamed(RouteJumpConfig.addAddressBook);
            },
            child: Text(
              "添加",
              style: TextStyle(
                fontSize: PublicData.textSize_12,
                fontWeight: FontWeight.bold,
                color: PublicData.color090C0B,
              ),
            ),
          ),
        ],
      ),
      body: Obx(
        () => filterAddressByType(addressType.value).isEmpty
            ? noData()
            : haveData(),
      ),
    );
  }
}
