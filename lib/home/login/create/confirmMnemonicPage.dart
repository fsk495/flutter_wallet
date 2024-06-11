// ignore_for_file: file_names, camel_case_types

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wallet/data/userInfoData.dart';
import 'package:flutter_wallet/plugins/publicData.dart';
import 'package:flutter_wallet/plugins/publicUtils.dart';
import 'package:flutter_wallet/plugins/router.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

Widget intervalSizedBox = SizedBox(
  height: 10.h,
);

Color borderColor = PublicData.colorB9DFE0;

Color borderColorErr = Colors.red;

class ConfirmMnemonicPage extends StatefulWidget {
  const ConfirmMnemonicPage({super.key});

  @override
  State<ConfirmMnemonicPage> createState() => _ConfirmMnemonicPageState();
}

class _ConfirmMnemonicPageState extends State<ConfirmMnemonicPage> {
  UserInfoData userInfoData = Get.find();

  List<MnemonicListItem> confirmMnemonicList = [];

  List<MnemonicListItem> defaultMnemonicList = [];

  List<String> tempMnemonicList = [];

  bool canToNext = false;

  @override
  void initState() {
    tempMnemonicList = userInfoData.localMnemonic.value.split(' ');

    for (var element in tempMnemonicList.asMap().entries) {
      var index = element.key;
      var isTure = true;
      var title = element.value;
      var confirmMnemonicItem = MnemonicListItem(title, isTure, index, true);
      defaultMnemonicList.add(confirmMnemonicItem);
    }
    Logger().w("tempMnemonicList  $tempMnemonicList");
    defaultMnemonicList.shuffle(Random());
    super.initState();
  }

  Widget getGrid(List<MnemonicListItem> words) {
    return Container(
      padding: const EdgeInsets.all(15),
      width: MediaQuery.of(context).size.width - (20.w * 2),
      height: 300.r,
      decoration: BoxDecoration(
          color: PublicData.colorE7F5F5,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            width: 1,
            color: borderColor,
          ) // 圆角矩形
          ),
      // padding: const EdgeInsets.all(2), // 宽松的内边距
      child: Wrap(
        spacing: 10.w, // 水平间距
        runSpacing: 10.w, // 垂直间距
        children: List.generate(
          words.length,
          (index) {
            var tempItem = words[index];
            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                if (!tempItem.isTure) {
                  onConfirmMnemonicItemClick(tempItem);
                }
              },
              child: Container(
                padding: EdgeInsets.all(12.w),
                // alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: tempItem.isTure ? borderColor : borderColorErr,
                  ),
                  borderRadius: BorderRadius.circular(7.r),
                  color: Colors.white,
                ),
                child: Text(
                  tempItem.title, // 显示每个单词
                  style: TextStyle(
                    fontSize: PublicData.textSize_16,
                    fontWeight: FontWeight.bold,
                    color: PublicData.color333333,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  onItemClick(MnemonicListItem data) {
    setState(() {
      bool shad = false;
      if (confirmMnemonicList.isEmpty) {
        shad = false;
      } else {
        for (var i = 0; i < confirmMnemonicList.length; i++) {
          if (confirmMnemonicList[i].title == data.title) {
            shad = true;
            break;
          }
        }
      }

      if (data.title == tempMnemonicList[confirmMnemonicList.length]) {
        data.isTure = true;
      } else {
        data.isTure = false;
      }

      if (!shad) {
        for (var i = 0; i < defaultMnemonicList.length; i++) {
          if (defaultMnemonicList[i].title == data.title) {
            defaultMnemonicList[i].isCanClick = false;
            break;
          }
        }
        confirmMnemonicList.add(data);

        if (confirmMnemonicList.length == defaultMnemonicList.length) {
          bool tempBool = true;

          for (var i = 0; i < confirmMnemonicList.length; i++) {
            if (!confirmMnemonicList[i].isTure) {
              tempBool = false;
              break;
            }
            canToNext = tempBool;
          }
        }
      }
    });
  }

  onConfirmMnemonicItemClick(MnemonicListItem data) {
    setState(() {
      confirmMnemonicList.remove(data);
      for (var i = 0; i < confirmMnemonicList.length; i++) {
        if (confirmMnemonicList[i].title == tempMnemonicList[i]) {
          confirmMnemonicList[i].isTure = true;
        } else {
          confirmMnemonicList[i].isTure = false;
        }
      }
      for (var i = 0; i < defaultMnemonicList.length; i++) {
        if (defaultMnemonicList[i].title == data.title) {
          defaultMnemonicList[i].isCanClick = true;
          break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: getBackLastInterfaceButton(),
        actions: [
          getHelPanelpButton(height: 19.w, width: 19.w),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    intervalSizedBox,
                    Text(
                      "确认助记词",
                      style: TextStyle(
                        color: PublicData.color333333,
                        fontWeight: FontWeight.w400,
                        fontSize: PublicData.textSize_17,
                      ),
                    ),
                    intervalSizedBox,
                    Text(
                      "请按顺序点击助记词，以确认您备份正确。",
                      style: TextStyle(
                        color: PublicData.color01888A,
                        fontWeight: FontWeight.w400,
                        fontSize: PublicData.textSize_13,
                      ),
                    ),
                    intervalSizedBox,
                    intervalSizedBox,
                    getGrid(confirmMnemonicList),
                    intervalSizedBox,
                    intervalSizedBox,
                    Wrap(
                      spacing: 10.w,
                      runSpacing: 10.w,
                      children: defaultMnemonicList
                          .asMap()
                          .entries
                          .map(
                            (entry) => GestureDetector(
                              onTap: () {
                                if (entry.value.isCanClick) {
                                  onItemClick(entry.value);
                                }
                              },
                              behavior: HitTestBehavior.translucent,
                              child: Container(
                                padding: EdgeInsets.all(12.w),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: borderColor,
                                  ),
                                  borderRadius: BorderRadius.circular(7.r),
                                  color: entry.value.isCanClick
                                      ? Colors.white
                                      : Colors.grey,
                                ),
                                child: Text(
                                  entry.value.title, // 显示每个单词
                                  style: TextStyle(
                                    fontSize: PublicData.textSize_16,
                                    fontWeight: FontWeight.bold,
                                    color: PublicData.color333333,
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                PublicFloatingActionButtonLocation(
                  title: '下一步',
                  callback: () {
                    Get.offAllNamed(RouteJumpConfig.home);
                  },
                  isCanClick: canToNext,
                  fontSize: PublicData.textSize_16,
                  containerHeight: 46.h,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MnemonicListItem {
  String title;
  bool isTure;
  int index;
  bool isCanClick;

  MnemonicListItem(this.title, this.isTure, this.index, this.isCanClick);
}
