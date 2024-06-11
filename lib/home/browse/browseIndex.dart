// ignore_for_file: file_names, sort_child_properties_last, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wallet/plugins/buttonUtil.dart';
import 'package:flutter_wallet/plugins/publicData.dart';
import 'package:flutter_wallet/plugins/publicUtils.dart';
import 'package:flutter_wallet/plugins/router.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'browseLocalData.dart';

class BrowseIndexPage extends StatefulWidget {
  const BrowseIndexPage({super.key});

  @override
  State<BrowseIndexPage> createState() => _BrowseIndexPageState();
}

class _BrowseIndexPageState extends State<BrowseIndexPage> {
  List<dynamic> browseLocalData = browseData().browseLocalData;

  int selectedIndex1 = 0;
  int selectedIndex2 = 0;

  List<dynamic> browseLocalData_EOS_or_ETH = browseData().browseLocalData_ETH;

  Widget getIconOrDefalut(String url) {
    return url == ""
        ? Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: PublicData.colorB9DFE0,
                width: 1.w,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            padding: EdgeInsets.all(8.r),
            child: Image.asset(
              'assets/browse/browse_defalut.png',
              width: 49.w,
              height: 49.w,
            ),
          )
        : Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
            child: GetImageCoinByUrl(
              url: url,
              width: 49.w,
              height: 49.w,
            ),
          );
  }

  Widget setDefalutItem(dynamic data) {
    return GestureDetector(
      onTap: () {
        // Get.toNamed("${RouteJumpConfig.browseWeb}?url=${data['url']}",
        //     arguments: false);
      },
      behavior: HitTestBehavior.translucent,
      child: Column(
        children: [
          getIconOrDefalut(data['logoURL']),
          SizedBox(
            height: 10.r,
          ),
          SizedBox(
            width: 47.w,
            child: Text(
              data['name'],
              style: TextStyle(
                color: PublicData.color333333,
                fontSize: PublicData.textSize_11,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget setEthOrEosItem(dynamic data) {
    return Container(
      padding: EdgeInsets.all(10.r),
      child: Row(
        children: [
          getIconOrDefalut(data['logoURL']),
          SizedBox(
            width: 16.w,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['name'],
                  style: TextStyle(
                    fontSize: PublicData.textSize_14,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  data['subtitle'],
                  style: TextStyle(
                    fontSize: PublicData.textSize_12,
                    color: PublicData.color4DA7A9,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget getView() {
    return selectedIndex2 == 2
        ? Text(
            "推荐使用后台配置，等待下一步",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: PublicData.textSize_20,
            ),
          )
        : Column(
            children: browseLocalData_EOS_or_ETH
                .map((item) => setEthOrEosItem(item))
                .toList(),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200.r),
        child: AppBar(
            flexibleSpace: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              child: Center(
                child: Transform.translate(
                  offset: const Offset(-40, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "如何了解TokenName的\n链上安全",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: PublicData.textSize_16,
                          color: PublicData.color02595A,
                        ),
                      ),
                      SizedBox(
                        height: 19.r,
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          top: 7.r,
                          bottom: 7.r,
                          left: 23.r,
                          right: 23.r,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: PublicData.color02595A,
                            width: 1.w,
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          "查看详情",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: PublicData.textSize_11,
                            color: PublicData.color02595A,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/browse/browse_title_bg.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        )),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16.r, right: 16.r, top: 5.r),
            child: Container(
              padding: EdgeInsets.only(
                left: 16.r,
                right: 16.r,
              ),
              height: 42.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(21.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 5,
                    offset: Offset(1.r, 0),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.search,
                    color: PublicData.color4DA7A9,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed(RouteJumpConfig.browseWebInput);
                      },
                      behavior: HitTestBehavior.translucent,
                      child: Text(
                        'Search...',
                        style: TextStyle(
                          color: PublicData.color4DA7A9,
                          fontWeight: FontWeight.w400,
                          fontSize: PublicData.textSize_12,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Logger().i("扫描二维码");
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
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 16.r,
                  right: 16.r,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SetSingleChoiceButton(
                              name: "最近使用",
                              onTap: () {
                                Logger().i("点击使用");
                                setState(() {
                                  selectedIndex1 = 0;
                                });
                              },
                              checked: selectedIndex1 == 0,
                              fontSize: PublicData.textSize_12,
                            ),
                            SetSingleChoiceButton(
                              name: "收藏列表",
                              onTap: () {
                                Logger().i("收藏点击");
                                setState(() {
                                  selectedIndex1 = 1;
                                });
                              },
                              checked: selectedIndex1 == 1,
                              fontSize: PublicData.textSize_12,
                            ),
                          ],
                        ),
                        TextButton(
                            onPressed: () {},
                            child: Row(
                              children: [
                                Text(
                                  "全部",
                                  style: TextStyle(
                                    color: PublicData.color4DA7A9,
                                    fontWeight: FontWeight.w400,
                                    fontSize: PublicData.textSize_12,
                                  ),
                                ),
                                SizedBox(
                                  width: 8.w,
                                ),
                                Image.asset(
                                  "assets/browse/browse_right.png",
                                  width: 4.w,
                                  height: 6.h,
                                )
                              ],
                            ))
                      ],
                    ),
                    SizedBox(
                      height: 50.h,
                      child: const Text("这是历史记录和收藏记录"),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      "推荐DApp",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontSize: PublicData.textSize_12,
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    SizedBox(
                      height: 200.r,
                      child: GridView.builder(
                        scrollDirection: Axis.horizontal,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1,
                        ),
                        itemCount: browseLocalData.length,
                        itemBuilder: (context, index) {
                          return setDefalutItem(browseLocalData[index]);
                        },
                      ),
                    ),
                    Container(
                      color: PublicData.colorF2F9F9,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          SetSingleChoiceButton(
                            name: "ETH",
                            onTap: () {
                              Logger().i("点击使用");
                              setState(() {
                                selectedIndex2 = 0;
                                browseLocalData_EOS_or_ETH =
                                    browseData().browseLocalData_ETH;
                              });
                            },
                            checked: selectedIndex2 == 0,
                            fontSize: PublicData.textSize_12,
                          ),
                          SizedBox(
                            width: 32.w,
                          ),
                          SetSingleChoiceButton(
                            name: "EOS",
                            onTap: () {
                              Logger().i("点击使用");
                              setState(() {
                                selectedIndex2 = 1;
                                browseLocalData_EOS_or_ETH =
                                    browseData().browseLocalData_EOS;
                              });
                            },
                            checked: selectedIndex2 == 1,
                            fontSize: PublicData.textSize_12,
                          ),
                          SizedBox(
                            width: 32.w,
                          ),
                          SetSingleChoiceButton(
                            name: "TRON",
                            onTap: () {
                              Logger().i("点击使用");
                              setState(() {
                                selectedIndex2 = 2;
                              });
                            },
                            checked: selectedIndex2 == 2,
                            fontSize: PublicData.textSize_12,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    getView(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
