// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wallet/data/addressBookController.dart';
import 'package:flutter_wallet/plugins/publicData.dart';
import 'package:flutter_wallet/plugins/publicUtils.dart';
import 'package:flutter_wallet/plugins/router.dart';
import 'package:flutter_wallet/plugins/showDiaologController.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

var verticalSizedBox = SizedBox(
  height: 10.h,
);

class AddressBookModifyInfo extends StatefulWidget {
  const AddressBookModifyInfo({super.key});

  @override
  State<AddressBookModifyInfo> createState() => _AddressBookModifyInfoState();
}

class _AddressBookModifyInfoState extends State<AddressBookModifyInfo> {
  AddressBookController addressBookController = Get.find();
  ShowDiaologController showDiaologController = Get.find();

  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controller_name = TextEditingController();
  final TextEditingController _controller_remarks = TextEditingController();

  late int addressIndex;

  late addressItem tempAddressItem;

  bool _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    addressIndex = Get.arguments;

    tempAddressItem = addressBookController.allAddressInfoList[addressIndex];

    _controller.text = tempAddressItem.address;
    _controller_name.text = tempAddressItem.addressName;
    _controller_remarks.text = tempAddressItem.remakes;

    KeyboardVisibilityController().onChange.listen((bool visible) {
      setState(() {
        _isKeyboardVisible = visible;
        Logger().i("_isKeyboardVisible   $_isKeyboardVisible");
      });
    });
  }

  bool isCanEdit = false;

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
        actions: [
          TextButton(
              onPressed: () {
                setState(() {
                  isCanEdit = !isCanEdit;
                });
              },
              child: Text(
                isCanEdit ? "取消" : "编辑",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: PublicData.color131313,
                  fontSize: PublicData.textSize_16,
                ),
              ))
        ],
      ),
      body: Stack(
        children: [
          Padding(
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
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: Colors.white,
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GetImageCoinByUrl(
                        url: tempAddressItem.iconUrl,
                        width: 35.w,
                        height: 35.w,
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Text(
                        tempAddressItem.networkName,
                        style: TextStyle(
                          color: PublicData.color333333,
                          fontSize: PublicData.textSize_13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          onChanged: (value) {
                            // setIsCanClick();
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
                            enabled: isCanEdit,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          isCanEdit
                              ? Get.toNamed(RouteJumpConfig.QR_ScannerPage)
                              : copyToClipboard(_controller.text);
                        },
                        icon: Image.asset(
                          isCanEdit
                              ? "assets/public/icon_public_scan.png"
                              : "assets/wallet/btn_copy.png",
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
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                  child: TextField(
                    controller: _controller_name,
                    onChanged: (value) {
                      // setIsCanClick();
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
                      enabled: isCanEdit,
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
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                  child: TextField(
                    controller: _controller_remarks,
                    onChanged: (value) {
                      // setIsCanClick();
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
                      enabled: isCanEdit,
                    ),
                  ),
                ),
              ],
            ),
          ),
          isCanEdit
              ? Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0.h,
                  child: _isKeyboardVisible
                      ? const SizedBox()
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            PublicFloatingActionButtonLocation(
                              title: '保存',
                              callback: () {
                                _saveButton();
                                Logger().i("保存地址到地址本");
                              },
                              isCanClick: true,
                              fontSize: 16.sp,
                              containerHeight: 46.h,
                            ),
                            // SizedBox(height: 10.h),
                            PublicFloatingActionButtonLocation(
                              title: '删除',
                              callback: () {
                                _deletedButton();
                                Logger().i("保存地址到地址本");
                              },
                              buttonClickColor: Colors.red,
                              isCanClick: true,
                              fontSize: 16.sp,
                              containerHeight: 46.h,
                            ),
                          ],
                        ),
                )
              : Container(),
        ],
      ),
    );
  }

  _saveButton() {
    if (!isValidEthereumAddress(_controller.text.trim())) {
      showDiaologController.showSnackBar("钱包地址不符合条件", "", 3);
      return;
    }
    if (_controller_name.text.isEmpty) {
      showDiaologController.showSnackBar("请设置名称", "", 3);
      return;
    }
    addressBookController.changeAddress(
      addressItem(
        iconUrl: tempAddressItem.iconUrl,
        addressName: _controller_name.text.trim(),
        address: _controller.text.trim(),
        remakes: _controller_remarks.text.trim(),
        type: tempAddressItem.type,
        networkName: tempAddressItem.networkName,
      ),
      addressIndex,
    );
    addressBookController.saveAddressBook();
    Navigator.pop(context);
  }

  _deletedButton() {
    showDiaologController.showAlertDialog(
      "提示",
      "是否删除该地址",
      onConfirm: () {
        addressBookController.removeAddress(tempAddressItem);
        addressBookController.saveAddressBook();
        Navigator.pop(context);
      },
    );
  }
}
