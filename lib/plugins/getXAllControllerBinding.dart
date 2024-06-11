// ignore_for_file: file_names

import 'package:flutter_wallet/data/addressBookController.dart';
import 'package:flutter_wallet/data/coinGecko/coinGeckoAPI.dart';
import 'package:flutter_wallet/data/coinGecko/coinGeckoDataList.dart';
import 'package:flutter_wallet/data/getMarketValueProvider.dart';
import 'package:flutter_wallet/data/userInfoData.dart';
import 'package:flutter_wallet/home/browse/browseInputUrlList.dart';
import 'package:flutter_wallet/plugins/localDataController.dart';
import 'package:flutter_wallet/plugins/otherDataController.dart';
import 'package:flutter_wallet/plugins/showDiaologController.dart';
import 'package:get/get.dart';

class AllControllerBinding implements Bindings{
  @override
  void dependencies(){
    Get.lazyPut<GetMarketValue>(() => GetMarketValue(),fenix: true);
    Get.lazyPut<LocalDataController>(() => LocalDataController(),fenix: true);
    Get.lazyPut<UserInfoData>(() => UserInfoData(),fenix: true);
    Get.lazyPut<ShowDiaologController>(() => ShowDiaologController(),fenix: true);
    Get.lazyPut<OtherDataController>(() => OtherDataController(),fenix: true);
    Get.lazyPut<AddressBookController>(() => AddressBookController(),fenix: true);
    Get.lazyPut<BrowseInputUrlController>(() => BrowseInputUrlController(),fenix: true);

    Get.lazyPut<CoinGeckoDataListController>(() => CoinGeckoDataListController(),fenix: true);
    Get.lazyPut<CoinGeckoAPI>(() => CoinGeckoAPI(),fenix: true);
    
  }
}