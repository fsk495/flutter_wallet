// ignore_for_file: library_private_types_in_public_api, file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wallet/data/getMarketValueProvider.dart';
import 'package:flutter_wallet/plugins/buttonUtil.dart';
import 'package:flutter_wallet/plugins/publicData.dart';
import 'package:flutter_wallet/plugins/publicUtils.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

class MarketQuotesDeFI extends StatefulWidget {
  const MarketQuotesDeFI({super.key});

  @override
  _MarketQuotesDeFIState createState() => _MarketQuotesDeFIState();
}

class _MarketQuotesDeFIState extends State<MarketQuotesDeFI> {
  final GetMarketValue getMarketValue = Get.find();
  int selectedIndex = 0;
  int sortIndex = 0;

  String buttonImageUrl(bool selected, int sortIndex) {
    if (selected) {
      return sortIndex == 1
          ? "assets/market/sort_1.png"
          : "assets/market/sort_2.png";
    } else {
      return "assets/market/sort_0.png";
    }
  }


  Color getColorByPriceChangePercentage24H(
      double priceChangePercentage24H, bool isText) {
    bool isWin = priceChangePercentage24H > 0;
    if (isText) {
      return isWin
          ? PublicData.colorA2B51C
          : PublicData.color4DA7A9;
    } else {
      return isWin
          ? PublicData.colorF2F3EA
          : PublicData.colorE7F5F5;
    }
  }

  Widget getScrollView() {
    if (getMarketValue.defiValueData.isEmpty) {
      return Center(
        child: Text(
          "暂无数据",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: PublicData.textSize_30,
            color: Colors.black,
          ),
        ),
      );
    } else {
      List<dynamic> sortedData = getMarketValue.defiValueData;
      if (selectedIndex == 0) {
        sortedData.sort((a, b) => a['marketCap'].compareTo(b['marketCap']));
      } else if (selectedIndex == 1) {
        sortedData.sort((a, b) => a['price'].compareTo(b['price']));
      } else if (selectedIndex == 2) {
        sortedData.sort((a, b) => a['priceChangePercentage24H']
            .compareTo(b['priceChangePercentage24H']));
      }
      Logger().i("sortIndex   $sortIndex");
      if (sortIndex == 0) {
        sortedData = sortedData.reversed.toList();
      }

      return SuperListView.builder(
        physics: const ClampingScrollPhysics(),
        itemCount: sortedData.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final item = sortedData[index];
          double priceChangePercentage24H = 0.0;
          try {
            priceChangePercentage24H = item['priceChangePercentage24H'];
          } catch (e) {
            Logger().e("Error parsing priceChangePercentage24H: $e");
          }
          return Container(
            padding: EdgeInsets.only(
              left: 15.r,
              right: 10.r,
              top: 10.r,
              bottom: 10.r,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['symbol'].toString().toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: PublicData.textSize_14,
                        color: PublicData.color333333,
                      ),
                    ),
                    Text(
                      "#${index + 1} \$${formatNumber(item['marketCap'])}",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: PublicData.textSize_10,
                        color: PublicData.color8DC2C3,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "\$ ${double.parse(item['price'].toString())}",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: PublicData.textSize_14,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 61.w),
                Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: getColorByPriceChangePercentage24H(
                        priceChangePercentage24H, false),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    "${priceChangePercentage24H.toStringAsFixed(2)}%",
                    style: TextStyle(
                      fontSize: PublicData.textSize_12,
                      fontWeight: FontWeight.w400,
                      color: getColorByPriceChangePercentage24H(
                          priceChangePercentage24H, true),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.r),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PublicButtonTextAndIcon(
                  title: '市值',
                  imageUrl: buttonImageUrl(selectedIndex == 0, sortIndex),
                  fontSize: PublicData.textSize_10,
                  onPressed: () {
                    setState(() {
                      if (selectedIndex == 0) {
                        sortIndex = sortIndex == 0 ? 1 : 0;
                      } else {
                        selectedIndex = 0;
                        sortIndex = 0;
                      }
                    });
                  },
                  isUseIcon: false,
                ),
                Row(
                  children: <Widget>[
                    PublicButtonTextAndIcon(
                      title: '价格',
                      imageUrl: buttonImageUrl(selectedIndex == 1, sortIndex),
                      fontSize: PublicData.textSize_10,
                      onPressed: () {
                        setState(() {
                          if (selectedIndex == 1) {
                            sortIndex = sortIndex == 0 ? 1 : 0;
                          } else {
                            selectedIndex = 1;
                            sortIndex = 0;
                          }
                        });
                      },
                      isUseIcon: false,
                    ),
                    SizedBox(width: 61.w),
                    PublicButtonTextAndIcon(
                      title: '涨跌',
                      imageUrl: buttonImageUrl(selectedIndex == 2, sortIndex),
                      fontSize: PublicData.textSize_10,
                      onPressed: () {
                        setState(() {
                          if (selectedIndex == 2) {
                            sortIndex = sortIndex == 0 ? 1 : 0;
                          } else {
                            selectedIndex = 2;
                            sortIndex = 0;
                          }
                        });
                      },
                      isUseIcon: false,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Obx(() {
                return getScrollView();
              }),
            ),
          ),
        ],
      ),
    );
  }
}
