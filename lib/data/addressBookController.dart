// ignore_for_file: camel_case_types, collection_methods_unrelated_type, file_names

import 'dart:convert';

import 'package:flutter_wallet/plugins/localDataController.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class AddressBookController extends GetxController {
  RxList<addressItem> allAddressInfoList = <addressItem>[].obs;

  final LocalDataController localDataController = Get.find();

  @override
  void onInit() {
    super.onInit();
    loadAddressBook();
  }
  void loadAddressBook() {
    var jsonStringList = localDataController.loadData("addressBook");
    Logger().w("Loaded JSON list: $jsonStringList");
    if (jsonStringList != null) {
      var decodedList = (jsonDecode(jsonStringList) as List<dynamic>).map((item) {
        return addressItem.fromJson(item as Map<String, dynamic>);
      }).toList();
      allAddressInfoList.value = decodedList;
    }
  }

  void saveAddressBook() {
    var jsonStringList = jsonEncode(allAddressInfoList.map((item) {
      return item.toJson();
    }).toList());
    localDataController.saveData("addressBook", jsonStringList);
  }

  void addAddress(addressItem item) {
    allAddressInfoList.add(item);
    saveAddressBook(); // 保存到本地
  }

  void addAddresses(List<addressItem> items) {
    allAddressInfoList.addAll(items);
    saveAddressBook(); // 保存到本地
  }

  void changeAddress(addressItem item, int index) {
    allAddressInfoList[index] = item;
    saveAddressBook(); // 保存到本地
  }

  void removeAddress(addressItem item) {
    allAddressInfoList.remove(item);
    saveAddressBook(); // 保存到本地
  }

  void removeAddresss(List<addressItem> items) {
    allAddressInfoList.removeWhere((element) => items.contains(element));
    saveAddressBook(); // 保存到本地
  }
}

class addressItem {
  final String iconUrl;
  final String addressName;
  final String address;
  final String remakes;
  final String type;
  final String networkName;

  addressItem({
    required this.iconUrl,
    required this.addressName,
    required this.address,
    required this.remakes,
    required this.type,
    required this.networkName,
  });

  // 从 JSON 创建 addressItem 对象
  factory addressItem.fromJson(Map<String, dynamic> json) {
    return addressItem(
      iconUrl: json['iconUrl'],
      addressName: json['addressName'],
      address: json['address'],
      remakes: json['remakes'],
      type: json['type'],
      networkName: json['networkName'],
    );
  }

  // 将 addressItem 对象转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'iconUrl': iconUrl,
      'addressName': addressName,
      'address': address,
      'remakes': remakes,
      'type': type,
      'networkName': networkName,
    };
  }

  // 将 addressItem 对象转换为 JSON 字符串
  String toJsonString() {
    return jsonEncode(toJson());
  }

  // 从 JSON 字符串创建 addressItem 对象
  factory addressItem.fromJsonString(String jsonString) {
    return addressItem.fromJson(jsonDecode(jsonString));
  }
}
