
// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter_wallet/data/coinGecko/CoinGeckoDataItem.dart';
import 'package:flutter_wallet/data/coinGecko/coinGeckoNetworks.dart';
import 'package:get/get.dart';


class CoinGeckoDataListController extends GetxController{
  
  final RxList<CoinGeckoDataItem> CoinGeckoDataList_allList =
      <CoinGeckoDataItem>[].obs;

      final RxList<CoinGeckoDataItem> CoinGeckoDataList_chooseList =
      <CoinGeckoDataItem>[].obs;


  @override
  void onInit() {
    super.onInit();
    conversionData();
  }

  void conversionData() {
    for(var i=0;i<allCoinGeckoNetworks.length; i++) {
      var element = allCoinGeckoNetworks[i];
      CoinGeckoDataItem item = CoinGeckoDataItem.fromJson(element);
      if(item.symbol == "nov"||item.symbol == "eth"||item.symbol == "usdt")
      {
        item.isDefault = true;
      }
      if(item.isDefault)
      {
        CoinGeckoDataList_chooseList.add(item);
      }
      CoinGeckoDataList_allList.add(item);
    }
  }

  void addOrRemoveChooseList(bool add, CoinGeckoDataItem item) {
    if(add)
    {
      CoinGeckoDataList_chooseList.add(item);
    }
    else
    {
      CoinGeckoDataList_chooseList.remove(item);
    }
  }
}
