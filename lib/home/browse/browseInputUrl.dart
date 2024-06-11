// ignore_for_file: file_names, camel_case_types, unused_element

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wallet/home/browse/browseInputUrlItem.dart';
import 'package:flutter_wallet/home/browse/browseInputUrlList.dart';
import 'package:flutter_wallet/plugins/localDataController.dart';
import 'package:flutter_wallet/plugins/publicData.dart';
import 'package:flutter_wallet/plugins/publicUtils.dart';
import 'package:flutter_wallet/plugins/router.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class BrowseInputUrlPage extends StatefulWidget {
  const BrowseInputUrlPage({super.key});

  @override
  State<BrowseInputUrlPage> createState() => _BrowseInputUrlPageState();
}

class _BrowseInputUrlPageState extends State<BrowseInputUrlPage> {
  LocalDataController localDataController = Get.find();
  BrowseInputUrlController browseInputUrlLists = Get.find();

  @override
  void initState() {
    super.initState();

    browseInputUrlLists.loadLocalInputUrl();
  }

  bool isValidURL(String url) {
    // final RegExp urlPattern = RegExp(r'^(https?:\/\/)?' // 支持 http 或 https 开头
    //     r'([a-zA-Z0-9.-]+)' // 域名部分
    //     r'(\.[a-zA-Z]{2,})' // 顶级域名，例如 .com, .net
    //     r'([\/\w.-]*)*\/?$' // 路径和参数部分
    //     );
    // return urlPattern.hasMatch(url);
    try {
      Uri.parse(url);
      return true;
    } catch (e) {
      Logger().w("isValidURL   $e");
      return false;
    }
  }

  Widget _updateHistoryRecord(BrowseInputUrlItem item) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Get.toNamed(RouteJumpConfig.temp);
        // Get.toNamed("${RouteJumpConfig.browseWeb}?url=${item.url}",
        //             arguments: true);
      },
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          child: Row(
            children: [
              
              SizedBox(
                width: 20.w,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(
                      color: PublicData.color131313,
                      fontSize: PublicData.textSize_18,
                    ),
                  ),
                  Text(
                    shortenEthereumAddress(item.url,leadingChars: 30,trailingChars: 0),
                    style: TextStyle(
                      color: PublicData.color131313,
                      fontSize: PublicData.textSize_18,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(
              "取消",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: PublicData.textSize_16,
                color: PublicData.color131313,
              ),
            ),
          ),
        ],
        title: Container(
          decoration: BoxDecoration(
              color: PublicData.color01888A4D,
              borderRadius: BorderRadius.circular(10.r)),
          child: TextField(
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: PublicData.textSize_12,
            ),
            onChanged: (value) {},
            onSubmitted: (value) {
              Logger().i("onSubmitted value  $value");
              if (value == "") {
                return;
              }
              if (isValidURL(value)) {
                Get.toNamed(RouteJumpConfig.temp);
                // Get.toNamed("${RouteJumpConfig.browseWeb}?url=$value",
                //     arguments: true);
              } else {
                Logger().w("不是有效网址  $value");
              }
            },
            decoration: InputDecoration(
              hintText: 'Search...',
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16.r),
              hintStyle: TextStyle(
                color: PublicData.color131313,
                fontWeight: FontWeight.w400,
                fontSize: PublicData.textSize_12,
              ),
            ),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10.h),
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_filled_outlined,
                        color: PublicData.color01888A,
                        size: 20.r,
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Text(
                        "历史记录",
                        style: TextStyle(
                          fontSize: PublicData.textSize_16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      browseInputUrlLists.clearUrlList();
                    },
                    icon: Icon(
                      Icons.delete_forever_outlined,
                      size: 20.r,
                    ),
                  )
                ],
              ),
              Expanded(
                child: Obx(
                  () => SingleChildScrollView(
                    child: Column(
                      children: browseInputUrlLists.browseInputUrlList.map((item) {
                        return _updateHistoryRecord(item);
                      }).toList(),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
