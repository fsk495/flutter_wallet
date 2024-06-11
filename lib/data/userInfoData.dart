// ignore_for_file: file_names, unused_element, non_constant_identifier_names
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_wallet/data/coinGecko/CoinGeckoDataItem.dart';
import 'package:flutter_wallet/plugins/localDataController.dart';
import 'package:get/get.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import 'package:logger/logger.dart';

class UserInfoData extends GetxController {
  LocalDataController localDataController = LocalDataController();

  /// 通用的助记词
  final localMnemonic = "".obs;

  /// 对应的区块链的选择的钱包地址

  final chooseNetworkIndex = 0.obs;

  final chooseWalletIndex = 0.obs;

  final RxList<WalletAddressInfo> allWalletAddressList =
      <WalletAddressInfo>[].obs;

  final RxList<CoinGeckoDataItem> chooseCurrencyData =
      <CoinGeckoDataItem>[].obs;

  late Uint8List seedHex;
  late bip32.BIP32 root;

  String walletAddress_default = '';
  String personalPrivateKey_default = '';

  @override
  void onInit() {
    super.onInit();
    loadWatterAddress();
  }

  _createDefaultData() {
    seedHex = bip39.mnemonicToSeed(localMnemonic.value);
    root = bip32.BIP32.fromSeed(seedHex);

    // 生成衍生路径
    var derivePathStr = "m/44'/60'/0'/0/0";
    final child1 = root.derivePath(derivePathStr);

    // 转化为私钥
    personalPrivateKey_default = bytesToHex(child1.privateKey!.toList());

    // 转化为钱包地址
    final private = EthPrivateKey.fromHex(personalPrivateKey_default);
    walletAddress_default = private.address.hex;
  }

  void loadWatterAddress() {
    var jsonStringList_wallet =
        localDataController.loadData("walletAddressInfo");
    Logger().w("Loaded walletAddressInfo JSON list: $jsonStringList_wallet");
    if (jsonStringList_wallet != null) {
      var decodedList =
          (jsonDecode(jsonStringList_wallet) as List<dynamic>).map((item) {
        return WalletAddressInfo.fromJson(item as Map<String, dynamic>);
      }).toList();
      allWalletAddressList.value = decodedList;
    }

    var jsonStringList_currency =
        localDataController.loadData("chooseCurrencyData");
    Logger().w("Loaded chooseCurrency SON list: $jsonStringList_currency");
    if (jsonStringList_currency != null) {
      var decodedList =
          (jsonDecode(jsonStringList_currency) as List<dynamic>).map((item) {
        return CoinGeckoDataItem.fromJson(item as Map<String, dynamic>);
      }).toList();
      chooseCurrencyData.value = decodedList;
    }
  }

  void saveWalletAddress() {
    var jsonStringList_wallet = jsonEncode(allWalletAddressList.map((item) {
      return item.toJson();
    }).toList());
    localDataController.saveData("walletAddressInfo", jsonStringList_wallet);

    var jsonStringList_currency = jsonEncode(chooseCurrencyData.map((item) {
      return item.toJson();
    }).toList());
    localDataController.saveData("chooseCurrencyData", jsonStringList_currency);
  }

  String getWalletAddress(int currentIndex, int walletIndex) {
    return allWalletAddressList[currentIndex].walletAddressList[walletIndex];
  }

  String getWalletPrivateKey(int currentIndex, int walletIndex) {
    return allWalletAddressList[currentIndex].personalPrivateKey[walletIndex];
  }

  String getWalletName(int currentIndex, int walletIndex) {
    return allWalletAddressList[currentIndex].walletName[walletIndex];
  }

  String getWalletPassWord(int currentIndex, int walletIndex) {
    return allWalletAddressList[currentIndex].passWord[walletIndex];
  }

  setChooseNetWorkAndWallet(int networkIndex, int walletIndex) {
    chooseNetworkIndex.value = networkIndex;
    chooseWalletIndex.value = walletIndex;
  }

  setMnemonic(String mnemonic) {
    localMnemonic.value = mnemonic;
    Logger().i('设置新的助记词   mnemonic $mnemonic ');
    _createDefaultData();
    localDataController.saveData("mnemonic", mnemonic);
  }

  /// 生成通用的助记词
  generatePublicMnemonic() {
    String mnemonic = bip39.generateMnemonic(strength: 128);
    Logger().i('生成的助记词   $mnemonic');

    localMnemonic.value = mnemonic;
    _createDefaultData();
    localDataController.saveData("mnemonic", mnemonic);
  }

  generateWalletAddressByWeb3Dart(
    String networkName,
    String walletName,
    String passWord,
    CoinGeckoDataItem item,
  ) async {
    // var mnemonic = localMnemonic.value;
    // final seedHex = bip39.mnemonicToSeed(mnemonic);
    // final root = bip32.BIP32.fromSeed(seedHex);
    walletName = "${item.symbol}-1";

    Logger().w("walletAddress  $walletAddress_default");
    Logger().w("personalPrivateKey  $personalPrivateKey_default");
    Logger().w("mnemonic   ${localMnemonic.value}");

    // 更新钱包地址和选择的货币数据列表
      WalletAddressInfo walletAddressInfo = WalletAddressInfo(
        walletAddressList: [walletAddress_default],
        personalPrivateKey: [personalPrivateKey_default],
        walletName: [walletName],
        passWord: [passWord],
      );
      allWalletAddressList.add(walletAddressInfo);
      chooseCurrencyData.add(item);
    

    Logger().i("allWalletAddressList.length   ${allWalletAddressList.length}");
    Logger().i("chooseCurrencyData.length   ${chooseCurrencyData.length}");
    saveWalletAddress();
  }

  addWalletAddressByWeb3Dart(
    String networkName,
    String passWord,
    CoinGeckoDataItem item,
  ) {
    var mnemonic = localMnemonic.value;
    final seedHex = bip39.mnemonicToSeed(mnemonic);
    final root1 = bip32.BIP32.fromSeed(seedHex);
    var walletName = '';
    int hadIndex = 0;
    String walletAddress1 = '';
    String personalPrivateKey1 = '';
    for (var i = 0; i < chooseCurrencyData.length; i++) {
      if (networkName == chooseCurrencyData[i].name) {
        hadIndex = i;
        break;
      }
    }
    var derivePathIndex = 0;

    derivePathIndex = allWalletAddressList[hadIndex].walletAddressList.length;
    walletName = "${item.symbol}-${derivePathIndex + 1}";
    var derivePathStr = "m/44'/60'/0'/0/$derivePathIndex";
    final child1 = root1.derivePath(derivePathStr);

    // 转化为私钥
    personalPrivateKey1 = bytesToHex(child1.privateKey!.toList());
    // 转化为钱包地址
    final private = EthPrivateKey.fromHex(personalPrivateKey1);
    walletAddress1 = private.address.hex;

    Logger().w("walletAddress1  $walletAddress1");
    Logger().w("personalPrivateKey1  $personalPrivateKey1");
    Logger().w("mnemonic  ${localMnemonic.value}");

    allWalletAddressList[hadIndex].walletAddressList.add(walletAddress1);
    allWalletAddressList[hadIndex].passWord.add(passWord);
    allWalletAddressList[hadIndex].walletName.add(walletName);
    allWalletAddressList[hadIndex].personalPrivateKey.add(personalPrivateKey1);
    saveWalletAddress();
  }

  addWalletAddressByPrivateKey(
    String privateKey,
    String networkName,
    String passWord,
    CoinGeckoDataItem item,
  ) {
    Logger().i("开始导入钱包");
    var walletName = '';
    int hadIndex = 0;
    String walletAddress1 = '';

    for (var i = 0; i < chooseCurrencyData.length; i++) {
      if (networkName == chooseCurrencyData[i].name) {
        hadIndex = i;
        break;
      }
    }

    var derivePathIndex =
        allWalletAddressList[hadIndex].walletAddressList.length;
    walletName = "${item.symbol}-${derivePathIndex + 1}";

    // 使用私钥创建钱包
    final private = EthPrivateKey.fromHex(privateKey);
    walletAddress1 = private.address.hex;

    Logger().w("walletAddress1  $walletAddress1");
    Logger().w("personalPrivateKey1  $privateKey");
    Logger().i(
        " 1 allWalletAddressList[hadIndex].walletAddressList. ${allWalletAddressList[hadIndex].walletAddressList.length}  ");
    allWalletAddressList[hadIndex].walletAddressList.add(walletAddress1);
    allWalletAddressList[hadIndex].passWord.add(passWord);
    allWalletAddressList[hadIndex].walletName.add(walletName);
    allWalletAddressList[hadIndex].personalPrivateKey.add(privateKey);
    Logger().i(
        " 2 allWalletAddressList[hadIndex].walletAddressList. ${allWalletAddressList[hadIndex].walletAddressList.length}  ");
    saveWalletAddress();
    Logger().i("导入钱包结束");
  }
}

class WalletAddressInfo {
  // final String symbol;
  // final String networkName;
  final List<String> walletName;
  final List<String> walletAddressList;
  // final String publicPrivateKey;
  final List<String> personalPrivateKey;
  final List<String> passWord;
  // final String logoURI;
  // final String id;
  // final localCurrencyItem item;

  WalletAddressInfo({
    // required this.symbol,
    // required this.networkName,
    required this.walletAddressList,
    // required this.publicPrivateKey,
    required this.personalPrivateKey,
    required this.walletName,
    required this.passWord,
    // required this.rpcURLs,
    // required this.logoURI,
    // required this.id,
    // required this.item,
  });

  // 从 JSON 创建 addressItem 对象
  factory WalletAddressInfo.fromJson(Map<String, dynamic> json) {
    return WalletAddressInfo(
      // symbol: json['symbol'],
      // networkName: json['networkName'],
      walletAddressList: json['walletAddressList']?.cast<String>() ?? [],
      // publicPrivateKey: json['publicPrivateKey'],
      personalPrivateKey: json['personalPrivateKey']?.cast<String>() ?? [],
      walletName: json['walletName']?.cast<String>() ?? [],
      passWord: json['passWord']?.cast<String>() ?? [],
      // rpcURLs: json['rpcURLs']?.cast<String>() ?? [],
      // logoURI: json['logoURI'],
      // id: json['id'],
      // item: localCurrencyItem.fromJson(json['item']),
    );
  }

  // 将 addressItem 对象转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      // 'symbol': symbol,
      // 'networkName': networkName,
      'walletAddressList': walletAddressList,
      // 'publicPrivateKey': publicPrivateKey,
      'personalPrivateKey': personalPrivateKey,
      'walletName': walletName,
      'passWord': passWord,
      // 'rpcURLs': rpcURLs,
      // 'logoURI': logoURI,
      // 'id': id,
      // 'item': item.toJson(),
    };
  }

  // 将 addressItem 对象转换为 JSON 字符串
  String toJsonString() {
    return jsonEncode(toJson());
  }

  // 从 JSON 字符串创建 addressItem 对象
  factory WalletAddressInfo.fromJsonString(String jsonString) {
    return WalletAddressInfo.fromJson(jsonDecode(jsonString));
  }
}
