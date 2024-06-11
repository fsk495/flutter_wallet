// ignore_for_file: file_names, unnecessary_overrides, invalid_use_of_protected_member, depend_on_referenced_packages

import 'dart:convert';
import 'package:http/http.dart' as http; // 使用 http 库
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class GetMarketValue extends GetxController {
  var marketValueData = [].obs;
  var defiValueData = [].obs;

  @override
  void onInit() {
    fetchMarketTokens();
    super.onInit();
  }

  /// 获取市场信息 例：币价，变化趋势
  Future<void> fetchMarketTokens() async {
    Logger().i("开始获取市场信息");
    try {
      final response = await http.get(
          Uri.parse(
              "http://system.shulijp.com/system/api/market/tokens?category=favorites&vs_currency=usd&ids=bitcoin%2Cethereum%2Cbinancecoin%2Cripple%2Ccardano%2Csolana%2Cdogecoin%2Cpolkadot%2Cshiba-inu%2Cpancakeswap-token%2Cpha%2Cterra-luna&sparkline=true&sparklinePoints=100"),
      );

      if (response.statusCode == 200) {
        marketValueData.value = jsonDecode(response.body);
        if (marketValueData.isEmpty) {
          Logger().e("没有获取到市场信息");
        } else {
          Logger().w("获取到市场信息");
        }
      } else {
        Logger().e("请求失败，状态码: ${response.statusCode}");
      }
    } catch (error) {
      Logger().e("error fetching market tokens: $error");
    }

    try {
      final response = await http.get(
          Uri.parse(
              "http://system.shulijp.com/system/api/market/tokens?category=decentralized-finance-defi&vs_currency=usd&sparkline=true&sparklinePoints=100"),
      );

      if (response.statusCode == 200) {
        defiValueData.value = jsonDecode(response.body);
        if (defiValueData.isEmpty) {
          Logger().e("没有获取到 DeFi 信息");
        } else {
          Logger().w("获取到 DeFi 信息");
        }
      } else {
        Logger().e("请求失败，状态码: ${response.statusCode}");
      }
    } catch (error) {
      Logger().e("error fetching defi tokens: $error");
    }
  }
}
