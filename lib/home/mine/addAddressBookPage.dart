// ignore_for_file: file_names, unused_element, non_constant_identifier_names, dead_code

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wallet/data/addressBookController.dart';
import 'package:flutter_wallet/data/coinGecko/CoinGeckoDataItem.dart';
import 'package:flutter_wallet/data/coinGecko/coinGeckoDataList.dart';
import 'package:flutter_wallet/plugins/publicData.dart';
import 'package:flutter_wallet/plugins/publicUtils.dart';
import 'package:flutter_wallet/plugins/router.dart';
import 'package:flutter_wallet/plugins/showDiaologController.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

var verticalSizedBox = SizedBox(
  height: 10.h,
);

class AddAddressBookPage extends StatefulWidget {
  const AddAddressBookPage({super.key});

  @override
  State<AddAddressBookPage> createState() => _AddAddressBookPageState();
}

class _AddAddressBookPageState extends State<AddAddressBookPage> {
  CoinGeckoDataListController coinGeckoDataListController = Get.find();
  AddressBookController addressBookController = Get.find();
  ShowDiaologController showDiaologController = Get.find();

  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controller_name = TextEditingController();
  final TextEditingController _controller_remarks = TextEditingController();

  List<CoinGeckoDataItem> tempCurrencyData = [];

  List<CoinGeckoDataItem> chooseCurrencyData = [];

  List<bool> isChooseList = [];

  bool isCanClick = false;

  bool _isKeyboardVisible = false;

  setIsCanClick() {
    var tempBool = false;
    if (chooseCurrencyData.isNotEmpty &&
        _controller.text != "" &&
        _controller_name.text != "") {
      tempBool = true;
    }
    setState(() {
      isCanClick = tempBool;
    });
  }

  _setStackWidth(int length) {
    double tempWidth = 35.w;
    switch (length) {
      case 1:
        tempWidth = 35.w;
        break;
      case 2:
      case 3:
        tempWidth = length * 28.w;
        break;
      case 4:
      default:
        tempWidth = 4 * 24.w;
        break;
    }
    return tempWidth;
  }

  _setChooseCurrencyData(CoinGeckoDataItem item) {
    setState(() {
      bool isAdd = true;

      for (var i = 0; i < chooseCurrencyData.length; i++) {
        CoinGeckoDataItem temp = chooseCurrencyData[i];
        if (temp.symbol == item.symbol) {
          isAdd = false;
        }
      }
      if (isAdd) {
        chooseCurrencyData.add(item);
      } else {
        chooseCurrencyData.remove(item);
      }
    });
  }

  @override
  void initState() {
    super.initState();

    tempCurrencyData = coinGeckoDataListController.CoinGeckoDataList_allList;
    chooseCurrencyData.add(tempCurrencyData[0]);
    isChooseList = List<bool>.filled(tempCurrencyData.length, false);
    isChooseList[0] = true;

    KeyboardVisibilityController().onChange.listen((bool visible) {
      setState(() {
        _isKeyboardVisible = visible;
        Logger().i("_isKeyboardVisible   $_isKeyboardVisible");
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _controller_name.dispose();
    _controller_remarks.dispose();

    super.dispose();
  }

  int selectedIndex = 0;

  _showBottomSheet(BuildContext context, List<bool> isChooseList) {
    if (isChooseList.isEmpty) {
      isChooseList = List<bool>.filled(tempCurrencyData.length, false);
    }
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
                        itemCount: tempCurrencyData.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider(); // 可以根据需求替换为其他分隔符
                        },
                        itemBuilder: (BuildContext context, int index) {
                          var item = tempCurrencyData[index];
                          return InkWell(
                            onTap: () {
                              setState(() {
                                isChooseList[index] = !isChooseList[index];
                                _setChooseCurrencyData(item);
                              });
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
                                    isChooseList[index]
                                        ? "assets/login/addCurrency_2.png"
                                        : "assets/login/addCurrency_1.png",
                                    width: 20.w,
                                    height: 20.w,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    verticalSizedBox,
                    GestureDetector(
                      onTap: () {
                        // 将更新的状态传递回主页面
                        Navigator.pop(context, isChooseList);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width - (10.w * 2),
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color: Colors.blue,
                        ),
                        child: Center(
                          child: Text(
                            "确定(${chooseCurrencyData.isNotEmpty ? chooseCurrencyData.length : ""})",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: PublicData.textSize_12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: getBackLastInterfaceButton(),
        title: Text(
          "添加地址",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: PublicData.textSize_16,
            color: PublicData.color131313,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 16.r, right: 16.r, top: 20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "请选择钱包网络",
              style: TextStyle(
                fontSize: PublicData.textSize_12,
                color: PublicData.color4DA7A9,
              ),
            ),
            verticalSizedBox,
            GestureDetector(
              onTap: () {
                _showBottomSheet(context, isChooseList);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: Colors.white,
                ),
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    chooseCurrencyData.isEmpty
                        ? Text(
                            "选择钱包网络",
                            style: TextStyle(
                              color: PublicData.color131313,
                              fontWeight: FontWeight.bold,
                              fontSize: PublicData.textSize_18,
                            ),
                          )
                        : Row(
                            children: [
                              SizedBox(
                                width: _setStackWidth(
                                    chooseCurrencyData.length), // 计算Stack所需的宽度
                                height: 35.w,
                                child: Stack(
                                  children: [
                                    for (int i = 0;
                                        i <
                                            (chooseCurrencyData.length > 4
                                                ? 4
                                                : chooseCurrencyData.length);
                                        i++)
                                      Positioned(
                                        left: i * 20.0.w, // 调整水平位置以重叠图标
                                        child: GetImageCoinByUrl(
                                          url: chooseCurrencyData[i].image,
                                          width: 35.w,
                                          height: 35.w,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Text(
                                chooseCurrencyData.length > 1
                                    ? "已选择${chooseCurrencyData[0].symbol.toUpperCase()}等${chooseCurrencyData.length}个网络"
                                    : chooseCurrencyData[0]
                                        .symbol
                                        .toUpperCase(),
                                style: TextStyle(
                                  color: PublicData.color333333,
                                  fontSize: PublicData.textSize_13,
                                ),
                              ),
                            ],
                          ),
                    Icon(
                      Icons.keyboard_arrow_right,
                      size: 30.r,
                      color: PublicData.color131313,
                    ),
                  ],
                ),
              ),
            ),
            verticalSizedBox,
            Text(
              "钱包地址",
              style: TextStyle(
                fontSize: PublicData.textSize_12,
                color: PublicData.color4DA7A9,
              ),
            ),
            verticalSizedBox,
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: Colors.white,
              ),
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      onChanged: (value) {
                        setIsCanClick();
                      },
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: PublicData.textSize_14,
                      ),
                      decoration: InputDecoration(
                        hintText: "请输入地址",
                        hintStyle: TextStyle(
                          color: PublicData.colorB9DFE0,
                          fontSize: PublicData.textSize_14,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
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
            ),
            verticalSizedBox,
            Text(
              "请设置名称",
              style: TextStyle(
                fontSize: PublicData.textSize_12,
                color: PublicData.color4DA7A9,
              ),
            ),
            verticalSizedBox,
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: Colors.white,
              ),
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              child: TextField(
                controller: _controller_name,
                onChanged: (value) {
                  setIsCanClick();
                },
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: PublicData.textSize_14,
                ),
                decoration: InputDecoration(
                  hintText: "请输入名称",
                  hintStyle: TextStyle(
                    color: PublicData.colorB9DFE0,
                    fontSize: PublicData.textSize_14,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            verticalSizedBox,
            Text(
              "设置备注",
              style: TextStyle(
                fontSize: PublicData.textSize_12,
                color: PublicData.color4DA7A9,
              ),
            ),
            verticalSizedBox,
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: Colors.white,
              ),
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              child: TextField(
                controller: _controller_remarks,
                onChanged: (value) {
                  setIsCanClick();
                },
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: PublicData.textSize_14,
                ),
                decoration: InputDecoration(
                  hintText: "备注仅做补充信息，不参与链上交易",
                  hintStyle: TextStyle(
                    color: PublicData.colorB9DFE0,
                    fontSize: PublicData.textSize_14,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _isKeyboardVisible
          ? const SizedBox()
          : PublicFloatingActionButtonLocation(
              title: '保存',
              callback: () {
                _saveButton();
                Logger().i("保存地址到地址本");
              },
              isCanClick: isCanClick,
              fontSize: 16.sp,
              containerHeight: 46.h,
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  _saveButton() {
    // addressItem(
    //   iconUrl: '',
    //   addressName: _controller_name.text.trim(),
    //   address: _controller.text.trim(),
    //   remakes: _controller_remarks.text.trim(),
    //   type: '',
    // );
    if (!isValidEthereumAddress(_controller.text.trim())) {
      showDiaologController.showSnackBar("钱包地址不符合条件", "", 3);
      return;
    }
    for (var i = 0; i < chooseCurrencyData.length; i++) {
      addressBookController.addAddress(
        addressItem(
          iconUrl: chooseCurrencyData[i].image,
          addressName: _controller_name.text.trim(),
          address: _controller.text.trim(),
          remakes: _controller_remarks.text.trim(),
          type: chooseCurrencyData[i].symbol,
          networkName: chooseCurrencyData[i].symbol.toUpperCase(),
        ),
      );
    }
    addressBookController.saveAddressBook();
    Navigator.pop(context);
  }
}
