// ignore_for_file: camel_case_types, file_names, non_constant_identifier_names, unused_element, unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wallet/data/coinGecko/CoinGeckoDataItem.dart';
import 'package:flutter_wallet/data/coinGecko/coinGeckoAPI.dart';
import 'package:flutter_wallet/data/coinGecko/coinGeckoDataList.dart';
import 'package:flutter_wallet/data/userInfoData.dart';
import 'package:flutter_wallet/plugins/publicData.dart';
import 'package:flutter_wallet/plugins/publicUtils.dart';
import 'package:flutter_wallet/plugins/showDiaologController.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class marketTradePage extends StatefulWidget {
  const marketTradePage({super.key});

  @override
  State<marketTradePage> createState() => _marketTradePageState();
}

class _marketTradePageState extends State<marketTradePage> {
  final TextEditingController _controller_send = TextEditingController();

  final UserInfoData userInfoData = Get.find();
  final ShowDiaologController showDiaologController = Get.find();
  final CoinGeckoDataListController coinGeckoDataListController = Get.find();
  final CoinGeckoAPI coinGeckoAPI = Get.find();

  var sendCoinNum = 0.0.obs;
  var getCoinNum = 0.0.obs;
  var instantRateNum = ''.obs;

  var toTokenAddress = ''.obs;
  var toTokenDecimals = 0.obs;

  late CoinGeckoDataItem defaultCoin_one;
  late CoinGeckoDataItem defaultCoin_two;

  late List<CoinGeckoDataItem> oneList;
  late List<CoinGeckoDataItem> twoList;

  /// 手续费
  final double handlingFees = 0.3;

  @override
  initState() {
    twoList = coinGeckoDataListController.CoinGeckoDataList_allList;
    oneList = userInfoData.chooseCurrencyData;
    defaultCoin_one = oneList[userInfoData.chooseNetworkIndex.value];

    _getReceiveCoinData(1, false);
    super.initState();
  }

  _getReceiveCoinData(int index, bool isOne) {
    setState(() {
      if (isOne) {
        defaultCoin_one = oneList[index];
      } else {
        defaultCoin_two = twoList[index];
      }
    });
    if (sendCoinNum.value != '') {
      _getReceiveCoinNum();
    }
  }

  _getReceiveCoinNum() async {
    Logger().i(sendCoinNum.value);
    if (sendCoinNum.value == 0.0) {
      return;
    }

    var ExchangeRate = await coinGeckoAPI.getCurrency_exchange_rate(
        defaultCoin_one.id, defaultCoin_two.id);

    instantRateNum.value = ExchangeRate.toString();

    getCoinNum.value = sendCoinNum.value * ExchangeRate * 0.997;

    // double multipliedValue =
    //     sendCoinNum.value * BigInt.from(10).pow(18).toDouble();

    // // 转换为BigInt
    // BigInt bigIntValue = BigInt.from(multipliedValue);
    // showDiaologController.showSnackBar("获取新数据,请等待", '', 3);

    // var url = 'http://system.shulijp.com/system/api/exchange/quote_all?'
    //     'toNetworkId=evm--1&fromNetworkId=evm--1&toTokenAddress=${toTokenAddress.value}'
    //     '&fromTokenAddress=0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee&toTokenDecimals=${toTokenDecimals.value}&fromTokenDecimals=18'
    //     '&slippagePercentage=0.5&userAddress=${userInfoData.getWalletAddress(userInfoData.chooseNetworkIndex.value, userInfoData.chooseWalletIndex.value)}&receivingAddress=${userInfoData.getWalletAddress(userInfoData.chooseNetworkIndex.value, userInfoData.chooseWalletIndex.value)}'
    //     '&fromTokenAmount=$bigIntValue&includes=0x,1inch,jupiter,openocean,swftc,socket,mdex,Deezy,Thorswap,ThorswapStream&noFilter=true';
    // try {
    //   Logger().i(url);
    //   final response = await http.get(Uri.parse(url));
    //   if (response.statusCode == 200) {
    //     // 请求成功，解析JSON数据
    //     final data = jsonDecode(response.body);
    //     Logger().w(data['data'][0]['result']);
    //     var temp = BigInt.parse(data['data'][0]['result']['buyAmount']);
    //     BigInt divisor = BigInt.from(10).pow(toTokenDecimals.value);

    //     // 除以 10 的 18 次方，得到相应的小数部分
    //     BigInt integerPart = temp ~/ divisor; // 取整数部分
    //     BigInt remainder = temp % divisor; // 取余数部分

    //     // 格式化余数部分，确保它是 18 位数
    //     String remainderStr = remainder.toString().padLeft(18, '0');

    //     // 获取小数部分的前 4 位
    //     String decimalPart = remainderStr.substring(0, 4);

    //     // 整合整数和小数部分
    //     String formatted = '${integerPart.toString()}.$decimalPart';

    //     getCoinNum.value = formatted;
    //     instantRateNum.value = data['data'][0]['result']['instantRate'];
    //   }
    // } catch (e) {
    //   Logger().e("_getReceiveCoinNum  error:  $e");
    // }
  }

  void _showBottomSheet(BuildContext context, bool isOne) {
    var newList = isOne ? oneList : twoList;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 允许滑动
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5, // 设置列表高度
          color: Colors.white,
          child: ListView.builder(
            itemCount: newList.length, // 列表项数量
            itemBuilder: (BuildContext context, int index) {
              var data = newList[index];
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: (data.symbol == defaultCoin_one.symbol ||
                          data.symbol == defaultCoin_two.symbol)
                    ? null
                    : () {
                        _getReceiveCoinData(index, isOne);
                        Get.back();
                      },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  color: (data.symbol == defaultCoin_one.symbol ||
                          data.symbol == defaultCoin_two.symbol)
                      ? Colors.grey
                      : Colors.white,
                  child: Row(
                    children: [
                      ClipOval(
                        child: GetImageCoinByUrl(
                          url: data.image,
                          width: 32.w,
                          height: 32.w,
                          // fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.symbol.toUpperCase(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: PublicData.textSize_16,
                              color: PublicData.color333333,
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                            data.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: PublicData.textSize_10,
                              color: PublicData.color333333,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Color publicColor = PublicData.color4DA7A9;

    FontWeight publicWeight = FontWeight.w400;

    return ListView(
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        children: [
          Container(
            color: PublicData.colorF2F9F9,
            padding: EdgeInsets.only(top: 10.r, left: 15.r, right: 15.r),
            child: Column(
              children: [
                // Container(
                //   padding: const EdgeInsets.all(5.r),
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(10.r),
                //     color: Colors.white,
                //   ),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Row(
                //         children: [
                //           Text(
                //             "24H 量",
                //             style: TextStyle(
                //               color: publicColor,
                //               fontSize: PublicData.textSize_10,
                //               fontWeight: publicWeight,
                //             ),
                //           ),
                //           Text(
                //             "\$10.23M",
                //             style: TextStyle(
                //               color: publicColor,
                //               fontSize: PublicData.textSize_10,
                //               fontWeight: publicWeight,
                //             ),
                //           )
                //         ],
                //       ),
                //       Row(
                //         children: [
                //           Text(
                //             "最新兑换",
                //             style: TextStyle(
                //               color: publicColor,
                //               fontSize: PublicData.textSize_10,
                //               fontWeight: publicWeight,
                //             ),
                //           ),
                //           Text(
                //             "290.00ETH",
                //             style: TextStyle(
                //               color: publicColor,
                //               fontSize: PublicData.textSize_10,
                //               fontWeight: publicWeight,
                //             ),
                //           ),
                //           Image.asset(
                //             "assets/market/icon_right.png",
                //             width: 7.w,
                //             height: 7.w,
                //           ),
                //           Text(
                //             "595.29K USDT",
                //             style: TextStyle(
                //               color: publicColor,
                //               fontSize: PublicData.textSize_10,
                //               fontWeight: publicWeight,
                //             ),
                //           ),
                //         ],
                //       ),
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: 10.h,
                ),
                Container(
                  padding: EdgeInsets.all(15.r),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "发送",
                            style: TextStyle(
                              color: publicColor,
                              fontWeight: publicWeight,
                              fontSize: PublicData.textSize_11,
                            ),
                          ),
                          Text(
                            "余额：0.0000",
                            style: TextStyle(
                              color: PublicData.color333333,
                              fontWeight: publicWeight,
                              fontSize: PublicData.textSize_11,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 9.h,
                      ),
                      Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          color: PublicData.colorE7F5F5,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                _showBottomSheet(context, true);
                              },
                              child: Container(
                                padding: EdgeInsets.all(8.r),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14.r),
                                  color: Colors.white,
                                ),
                                child: Row(
                                  children: [
                                    GetImageCoinByUrl(
                                      url: defaultCoin_one.image,
                                      width: 32.w,
                                      height: 32.w,
                                    ),
                                    SizedBox(
                                      width: 11.w,
                                    ),
                                    Text(
                                      defaultCoin_one.symbol.toUpperCase(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: PublicData.textSize_16,
                                        color: PublicData.color333333,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    Image.asset(
                                      "assets/wallet/btn_xia.png",
                                      width: 10.w,
                                      height: 5.h,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                controller: _controller_send,
                                onChanged: (value) {
                                  if (value == "") {
                                    return;
                                  }
                                  sendCoinNum.value = double.parse(value);
                                  _getReceiveCoinNum();
                                },
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d*\.?\d*')),
                                ],
                                textAlign: TextAlign.right,
                                decoration: InputDecoration(
                                  hintText: '转出数量',
                                  border: InputBorder.none,
                                  hintStyle: const TextStyle(
                                    color: PublicData.color83BABB,
                                  ),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 15.r),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 11.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "接收（预估）",
                            style: TextStyle(
                              color: publicColor,
                              fontWeight: publicWeight,
                              fontSize: PublicData.textSize_11,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Logger().i("交换币种");
                              setState(() {
                                var temp = defaultCoin_one;
                              defaultCoin_one = defaultCoin_two;
                              defaultCoin_two = temp;
                              });
                            },
                            icon: Image.asset(
                              "assets/market/icon_convert.png",
                              width: 21.w,
                              height: 18.h,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          color: PublicData.colorE7F5F5,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                _showBottomSheet(context, false);
                              },
                              child: Container(
                                padding: EdgeInsets.all(8.r),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14.r),
                                  color: Colors.white,
                                ),
                                child: Row(
                                  children: [
                                    ClipOval(
                                      child: GetImageCoinByUrl(
                                        url: defaultCoin_two.image,
                                        width: 32.w,
                                        height: 32.w,
                                        // fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 11.w,
                                    ),
                                    Text(
                                      defaultCoin_two.symbol.toUpperCase(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: PublicData.textSize_16,
                                        color: PublicData.color333333,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    Image.asset(
                                      "assets/wallet/btn_xia.png",
                                      width: 10.w,
                                      height: 5.h,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Obx(() => Expanded(
                                  child: Text(
                                    getCoinNum.value == 0.0
                                        ? '收到数量'
                                        : getCoinNum.value.toStringAsFixed(4),
                                    style: TextStyle(
                                      color: getCoinNum.value == ''
                                          ? PublicData.color83BABB
                                          : Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: PublicData.textSize_16,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                "汇率",
                                style: TextStyle(
                                  color: publicColor,
                                  fontWeight: publicWeight,
                                  fontSize: PublicData.textSize_11,
                                ),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Obx(
                                () => Text(
                                  "1 ${defaultCoin_one.symbol.toUpperCase()} = ${instantRateNum == "" ? "" : double.parse(instantRateNum.value).toStringAsFixed(6)} ${defaultCoin_two.symbol.toUpperCase()}",
                                  style: TextStyle(
                                    color: PublicData.color333333,
                                    fontWeight: publicWeight,
                                    fontSize: PublicData.textSize_11,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Image.asset(
                                "assets/market/icon_data.png",
                                width: 11.w,
                                height: 11.w,
                              )
                            ],
                          ),
                          Container(
                            width: 10.w,
                            height: 10.w,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: PublicData.color6BC7A1,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        children: [
                          Text(
                            "手续费",
                            style: TextStyle(
                              color: publicColor,
                              fontWeight: publicWeight,
                              fontSize: PublicData.textSize_11,
                            ),
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Text(
                            "$handlingFees%",
                            style: TextStyle(
                              color: PublicData.color333333,
                              fontWeight: publicWeight,
                              fontSize: PublicData.textSize_11,
                            ),
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          getHelPanelpButton(height: 11.4.w, width: 11.4.w),
                        ],
                      ),
                      SizedBox(
                        height: 18.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.all(11.r),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: PublicData.colorB9DFE0,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Image.asset(
                              "assets/market/btn_set.png",
                              width: 21.w,
                              height: 20.h,
                            ),
                          ),
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              showDiaologController.showSnackBar("余额不足", '', 3);
                            },
                            child: Container(
                              padding: EdgeInsets.only(
                                top: 16.h,
                                bottom: 16.h,
                                left: 93.w,
                                right: 93.w,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                color: PublicData.color01888A,
                              ),
                              child: Text(
                                "立即兑换",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: PublicData.textSize_14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]);
  }
}
