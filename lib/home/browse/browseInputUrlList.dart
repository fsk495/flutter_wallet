// ignore_for_file: file_names, unused_element

import 'dart:convert';

import 'package:flutter_wallet/home/browse/browseInputUrlItem.dart';
import 'package:flutter_wallet/plugins/localDataController.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class BrowseInputUrlController extends GetxController {
  RxList<BrowseInputUrlItem> browseInputUrlList = <BrowseInputUrlItem>[].obs;



  addUrlList(BrowseInputUrlItem item) {
    bool isHad= false;
    for(var i=0;i<browseInputUrlList.length; i++) {
      if (item.url == browseInputUrlList[i].url) {
        isHad = true;
      }
    }
    if (!isHad) {
      browseInputUrlList.insert(0, item);
      saveLocalInputUrl();
    }
  }

  clearUrlList() {
    Logger().i("清除");
    browseInputUrlList.clear();
    saveLocalInputUrl();
  }

  loadLocalInputUrl() {
    LocalDataController localDataController = Get.find();
    var jsonStringList = localDataController.loadData('inputUrl');
    Logger().w("Loaded JSON loadLocalInputUrl list: $jsonStringList");
    if (jsonStringList != null) {
      var decodedList =
          (jsonDecode(jsonStringList) as List<dynamic>).map((item) {
        return BrowseInputUrlItem.fromJson(item as Map<String, dynamic>);
      }).toList();
      browseInputUrlList.value = decodedList;
    }
  }

  saveLocalInputUrl() {
    LocalDataController localDataController = Get.find();
    var jsonStringList = jsonEncode(browseInputUrlList.map((item) {
      return item.toJson();
    }).toList());
    localDataController.saveData("inputUrl", jsonStringList);
  }
}
