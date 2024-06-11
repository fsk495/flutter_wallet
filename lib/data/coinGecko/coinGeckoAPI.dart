// ignore_for_file: non_constant_identifier_names, file_names

import 'dart:convert';

import 'package:flutter_wallet/data/DeFI/DefiDataItem.dart';
import 'package:flutter_wallet/data/DeFI/localDefiData.dart';
import 'package:flutter_wallet/data/NFT/NFTDataItem.dart';
import 'package:flutter_wallet/data/NFT/localNFTData.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class CoinGeckoAPI extends GetxController {
  static const String _baseUrl = 'https://api.coingecko.com/api/v3';

  static const String apiKey = "CG-hGdLDfgDUq9JGh9quacrRUtf";

  final vs_currencies = "usd".obs;

  List<NFTDataItem> allNFTDataList = [];

  List<DefiDataItem> allDeFiDataList = [];

  @override
  onInit() {
    super.onInit();
    conversionData();
  }

  conversionData() {
    for (var i = 0; i < LocalNFTData.length; i++) {
      var element = LocalNFTData[i];
      NFTDataItem item = NFTDataItem.fromJson(element);
      allNFTDataList.add(item);
    }

    for (var i = 0; i < LocalDefiData.length; i++) {
      var element = LocalDefiData[i];
      DefiDataItem item = DefiDataItem.fromJson(element);
      allDeFiDataList.add(item);
    }
  }

  /// 获取币价
  Future<double> getCoinPrice(String coinId) async {
    final url = Uri.parse(
        '$_baseUrl/simple/price?ids=$coinId&vs_currencies=${vs_currencies.value}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data[coinId] != null && data[coinId][vs_currencies.value] != null) {
        return data[coinId][vs_currencies.value].toDouble();
      } else {
        Logger().e(
            'Failed to load coin price   ${data[coinId]}  ${data[coinId][vs_currencies.value]} ');
        return 0.0;
      }
    } else {
      Logger().e('Failed to load coin price');
      return 0.0;
    }
  }

  /// 获取币币的汇率
  Future<double> getCurrency_exchange_rate(String starting, String End) async {
    var splicingString = "$starting,$End";

    final url = Uri.parse(
        '$_baseUrl/simple/price?ids=$splicingString&vs_currencies=${vs_currencies.value}');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data[starting] != null && data[End] != null) {
        Logger().i(
            "1 $starting = ${data[starting][vs_currencies.value] / data[End][vs_currencies.value]}  $End");
        return data[starting][vs_currencies.value] /
            data[End][vs_currencies.value];
      } else {
        Logger().e(
            "getCurrency_exchange_rate  Failed  : ${data[starting]}  ${data[End]}");
        return 0.0;
      }
    } else {
      Logger().e(
          "getCurrency_exchange_rate  Failed  : ${jsonDecode(response.body)['error'] || jsonDecode(response.body)['message']}");
      return 0.0;
    }
  }

  /// 获取网上的NFT列表
  Future<List<NFTDataItem>> getNFTDataListByNetwork() async {
    List<NFTDataItem> allNFTDataList = [];

    final url = Uri.parse('$_baseUrl/nfts/list');
    Logger().i("获取支持的NFT 列表  $url");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      var tempNFTList = data.map((item) => NFTDataItem.fromJson(item)).toList();

      for (var i = 0; i < tempNFTList.length; i++) {
        NFTDataItem item = tempNFTList[i];
        if (item.asset_platform_id == "ethereum" ||
            item.asset_platform_id == 'binance-smart-chain') {
          allNFTDataList.add(item);
        } else {
          continue;
        }
      }
    } else {
      Logger()
          .e("getNFTDataListByNetwork   Failed  error  ${response.statusCode}");
      allNFTDataList = [];
    }

    return allNFTDataList;
  }
}
