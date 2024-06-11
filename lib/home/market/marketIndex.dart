// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wallet/data/getMarketValueProvider.dart';
import 'package:flutter_wallet/home/market/marketQuotes.dart';
import 'package:flutter_wallet/home/market/martketTrade.dart';
import 'package:flutter_wallet/plugins/publicData.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class MarketIndexPage extends StatefulWidget {
  const MarketIndexPage({super.key});

  @override
  State<MarketIndexPage> createState() => _MarketIndexPageState();
}

class _MarketIndexPageState extends State<MarketIndexPage> {
  /// 获取市值 只执行一次
  final GetMarketValue getMarketValue = Get.find();


  List<Widget> marketPages = [
    const marketTradePage(),
    const marketQuotesPage(),
  ];

  int pageIndex = 0;

  Color getTextColor(int curPageIndex) {
    return pageIndex == curPageIndex
        ? PublicData.color131313
        : PublicData.color4DA7A9;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text("钱包"),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              onPressed: () {},
              icon: Image.asset(
                "assets/market/btn_kefu.png",
                width: 20.w,
                height: 20.w,
              ),
            ),
            Container(
              padding: EdgeInsets.all(5.r),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                color: PublicData.colorE7F5F5,
              ),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Logger().i("切换到交易界面");
                      setState(() {
                        pageIndex = 0;
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.white;
                          }
                          return pageIndex == 0
                              ? Colors.white
                              : PublicData.colorE7F5F5;
                        },
                      ),
                    ),
                    child: Text(
                      "交易",
                      style: TextStyle(
                        color: getTextColor(0),
                        fontSize: PublicData.textSize_12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5.r,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Logger().i("切换到行情界面");
                      setState(() {
                        pageIndex = 1;
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.white;
                          }
                          return pageIndex == 1
                              ? Colors.white
                              : PublicData.colorE7F5F5;
                        },
                      ),
                    ),
                    child: Text(
                      "行情",
                      style: TextStyle(
                        color: getTextColor(1),
                        fontSize: PublicData.textSize_12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Image.asset(
                "assets/market/btn_more.png",
                width: 19.w,
                height: 4.h,
              ),
            ),
          ],
        ),
      ),
      body: marketPages[pageIndex],
    );
  }
}
