// ignore_for_file: file_names, non_constant_identifier_names, no_leading_underscores_for_local_identifiers

import 'dart:convert';

import 'package:flutter_wallet/data/walletOperationes/walletBaseUrl.dart';
import 'package:flutter_wallet/plugins/publicUtils.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:web3dart/web3dart.dart';

class WalletGetBalance {
  /// 获取ETH 主链的余额
  /// addressList 要获取的钱包地址
  Future<Map<String, double>> getETHBalance(List<String> addressList) async {
    // 将字符数组拼接成一个字符串
    var address = addressList.join(',');
    Logger().i("address  $address");
    // 拼接URL并转为Uri
    final url = Uri.parse(
        "${ApiUrl.getETHApiUrl}?module=account&action=balancemulti&address=$address&tag=latest&apikey=${ApiUrl.ETHApiKey}");
    // 返回的数据类型
    Map<String, double> balances = {};
    Logger().i("url $url");
    try {
      // 获取数据
      final response = await http.get(url);
      // 检查返回数据的状态
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == '1' && data['result'] != null) {
          final result = data['result'];
          for (var item in result) {
            var account = item['account'];
            var balance = BigInt.parse(item['balance']);
            var balanceDouble = BigIntToDouble(balance);
            balances[account] = balanceDouble;
          }
          return balances;
        } else {
          Logger().w("getETHBalance error: ${data['result']}");
          return balances;
        }
      } else {
        Logger().w("getETHBalance  error ${response.statusCode}");
        return balances;
      }
    } catch (error) {
      Logger().w("getETHBalance  error:$error");
      return balances;
    }
  }

  /// 获取单个地址的ERC-20代币的 余额
  Future<double> getSingleERC20Balance(
      String address, String ContractAddress) async {
    final url = Uri.parse(
        '${ApiUrl.getETHApiUrl}?module=account&action=tokenbalance&contractaddress=$ContractAddress&address=$address&tag=latest&apikey=${ApiUrl.ETHApiKey}');
    Logger().i("url $url");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == '1') {
          var balance = BigInt.parse(data['result']);
          var balanceDouble =
              balance / BigInt.from(10).pow(6); // USDT has 6 decimal places
          return balanceDouble.toDouble();
        } else {
          Logger().w("getSingleERC20Balance error: ${data['message']}");
          return 0.0;
        }
      } else {
        Logger().w("getSingleERC20Balance error: ${response.statusCode}");
        return 0.0;
      }
    } catch (error) {
      Logger().w("getSingleERC20Balance error: $error");
      return 0.0;
    }
  }

  /// 获取Solana 区块链 单个地址的代币 余额
  Future<Map<String, double>> getERC20Balance(
      List<String> addressList, String ContractAddress) async {
    Map<String, double> balances = {};
    for (String address in addressList) {
      double balance = await getSingleERC20Balance(address, ContractAddress);
      balances[address] = balance;
    }
    return balances;
  }

  Future<Map<String, double>> getBNBBalance(List<String> addressList) async {
    var address = addressList.join(',');
    final url = Uri.parse(
        '${ApiUrl.getBNBApiUrl}?module=account&action=balancemulti&address=$address&tag=latest&apikey=${ApiUrl.BNBApiKey}');
    Map<String, double> balances = {};
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == '1' && data['result'] != null) {
          final result = data['result'];
          for (var item in result) {
            var account = item['account'];
            var balance = BigInt.parse(item['balance']);
            var balanceDouble =
                BigIntToDouble(balance); // BNB has 18 decimal places
            balances[account] = balanceDouble.toDouble();
          }
          return balances;
        } else {
          Logger().w("getBNBBalance error: ${data['result']}");
          return balances;
        }
      } else {
        Logger().w("getBNBBalance error: ${response.statusCode}");
        return balances;
      }
    } catch (error) {
      Logger().w("getBNBBalance error: $error");
      return balances;
    }
  }

  // /// 获取Solana 区块链的代币余额
  // Future<double> getSOLBalance(String address) async {
  //   final url = Uri.parse('https://api.mainnet-beta.solana.com');
  //   try {
  //     final response = await http.post(
  //       url,
  //       headers: {"Content-Type": "application/json"},
  //       body: jsonEncode({
  //         "jsonrpc": "2.0",
  //         "id": 1,
  //         "method": "getBalance",
  //         "params": [address]
  //       }),
  //     );
  //     Logger().i("Response status: ${response.statusCode}");
  //     Logger().i("Response body: ${response.body}");
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       var balance = data['result']['value'];
  //       var balanceDouble =
  //           balance / BigInt.from(10).pow(9); // SOL has 9 decimal places
  //       return balanceDouble.toDouble();
  //     } else {
  //       Logger().w("getSOLBalance error: ${response.statusCode}");
  //       return 0.0;
  //     }
  //   } catch (error) {
  //     Logger().w("getSOLBalance error: $error");
  //     return 0.0;
  //   }
  // }

  // /// 获取Solana 区块链的代币余额
  // Future<double> getXRPBalance(String address) async {
  //   final url =
  //       Uri.parse('https://data.ripple.com/v2/accounts/$address/balances');
  //   try {
  //     final response = await http.get(url);
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       var balance = 0.0;
  //       for (var item in data['balances']) {
  //         if (item['currency'] == 'XRP') {
  //           balance = double.parse(item['value']);
  //           break;
  //         }
  //       }
  //       return balance;
  //     } else {
  //       Logger().w("getXRPBalance error: ${response.statusCode}");
  //       return 0.0;
  //     }
  //   } catch (error) {
  //     Logger().w("getXRPBalance error: $error");
  //     return 0.0;
  //   }
  // }

  // Future<double> getATOMBalance(String address) async {
  //   final url =
  //       Uri.parse('https://lcd-mainnet.cosmos.network/auth/accounts/$address');
  //   try {
  //     final response = await http.get(url);
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       var coins = data['result']['value']['coins'];
  //       var atomBalance = 0.0;
  //       for (var coin in coins) {
  //         if (coin['denom'] == 'uatom') {
  //           atomBalance = double.parse(coin['amount']) /
  //               1000000; // 1 ATOM = 1,000,000 uatom
  //           break;
  //         }
  //       }
  //       return atomBalance;
  //     } else {
  //       Logger().w("getATOMBalance error: ${response.statusCode}");
  //       return 0.0;
  //     }
  //   } catch (error) {
  //     Logger().w("getATOMBalance error: $error");
  //     return 0.0;
  //   }
  // }

  // Future<double> getFILBalance(String address) async {
  //   final url = Uri.parse('http://your-lotus-api-url/rpc/v0');
  //   final jsonRpcRequest = {
  //     "jsonrpc": "2.0",
  //     "id": 1,
  //     "method": "Filecoin.WalletBalance",
  //     "params": [address]
  //   };
  //   try {
  //     final response = await http.post(
  //       url,
  //       headers: {"Content-Type": "application/json"},
  //       body: jsonEncode(jsonRpcRequest),
  //     );
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       return double.parse(data['result']);
  //     } else {
  //       Logger().w("getFILBalance error: ${response.statusCode}");
  //       return 0.0;
  //     }
  //   } catch (error) {
  //     Logger().w("getFILBalance error: $error");
  //     return 0.0;
  //   }
  // }

  // Future<double> getCROBalance(String address) async {
  //   final url = Uri.parse('https://crypto.com/chain/api/v1/account/$address');
  //   try {
  //     final response = await http.get(url);
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       var croBalance = double.parse(data['result']['balance'][0]['amount']);
  //       return croBalance;
  //     } else {
  //       Logger().w("getCROBalance error: ${response.statusCode}");
  //       return 0.0;
  //     }
  //   } catch (error) {
  //     Logger().w("getCROBalance error: $error");
  //     return 0.0;
  //   }
  // }

  /// 获取除了ERC-20的代币和ETH，BNB 的代币余额
  /// symbol 对应的代币
  // Future<Map<String, double>> getOtherBalance(
  //     List<String> addressList, String symbol) async {
  //   Map<String, double> balances = {};

  //   if (BalanceFunctions.functions.containsKey(symbol.toUpperCase())) {
  //     BalanceGetter getter = BalanceFunctions.functions[symbol.toUpperCase()]!;
  //     for (String address in addressList) {
  //       double balance = await getter(address);
  //       balances[address] = balance;
  //     }
  //   } else {
  //     Logger().w("Unsupported token: $symbol");
  //   }
  //   return balances;
  // }

  Future<Map<String, double>> getNovaiBalance(List<String> addressList) async {
    Web3Client _client = Web3Client("http://54.80.49.30:8545", http.Client());
    Map<String,double > balances = {};
    for (var i = 0; i < addressList.length; i++) {
      EthereumAddress address = EthereumAddress.fromHex(addressList[i]);
      EtherAmount balance = await _client.getBalance(address);
      Logger().i(balance.getInWei);
      balances[addressList[i]] = balance.getValueInUnit(EtherUnit.ether).toDouble();
    }
    return balances;
  }

  /// 获取指定币种的余额
  Future<Map<String, double>> getBalance(
      List<String> addressList, String tokenSymbol) async {
    
    Logger().i("获取代币余额-- 钱包地址：$addressList  代币： $tokenSymbol");

    switch (tokenSymbol) {
      case "ETH":
        return getETHBalance(addressList);
      case 'BNB':
        return getBNBBalance(addressList);
      // case 'DOGE':
      // case 'BCH':
      // case 'LTC':
      // case 'ETC':
      // case 'APT':
      // case 'TON':
      // case 'ADA':
      // case 'AVAX':
      // case 'TRX':
      // case 'DOT':
      // case 'NEAR':
      // case 'ICP':
      // case 'HBAR':
      // case 'XLM':
      // case 'XRP':
      // case 'SOL':
      // case 'ATOM':
      // case 'FIL':
      // case 'CRO':
      //   return getOtherBalance(addressList, tokenSymbol.toUpperCase());

      case 'NOV':
        return getNovaiBalance(addressList);

      case "USDT":
      case 'STETH':
      case 'USDC':
      case 'SHIB':
      case 'WBTC':
      case 'LINK':
      case 'UNI':
      case 'MATIC':
      case 'FET':
      case 'LEO':
      case 'DAI':
      case 'PEPE':
      case 'WEETH':
      case 'RNDR':
      case 'IMX':
      case 'EZETH':
      case 'FDUSD':
      case 'MNT':
      case 'GRT':
        return getERC20Balance(
            addressList, ApiUrl.contractAddress[tokenSymbol]!);
      default:
        Logger().e("Unsupported token: $tokenSymbol");
        return {};
    }
  }

  double BigIntToDouble(BigInt balance) {
    final balanceHex = BigIntToHex(balance);
    final balanceWei = hexToInt_public(balanceHex,false);
    final balanceDouble = weiToBnb(balanceWei);

    return balanceDouble;
  }
}

typedef BalanceGetter = Future<double> Function(String address);

class BalanceFunctions {
  static final Map<String, BalanceGetter> functions = {
    // 'XRP': WalletGetBalance().getXRPBalance,
    // 'SOL': WalletGetBalance().getSOLBalance,
    // 'ATOM': WalletGetBalance().getATOMBalance,
    // 'FIL': WalletGetBalance().getFILBalance,
    // 'CRO': WalletGetBalance().getCROBalance,

    // 'STETH': WalletGetBalance().getSOLBalance,
    
    // 'TON': WalletGetBalance().getSOLBalance,
    // 'ADA': WalletGetBalance().getSOLBalance,
    // 'AVAX': WalletGetBalance().getSOLBalance,
    // 'TRX': WalletGetBalance().getSOLBalance,
    // 'DOT': WalletGetBalance().getSOLBalance,
    
    // 'NEAR': WalletGetBalance().getSOLBalance,
    
    // 'ICP': WalletGetBalance().getSOLBalance,
    
    // 'HBAR': WalletGetBalance().getSOLBalance,
    
    // 'MNT': WalletGetBalance().getSOLBalance,
    // 'XLM': WalletGetBalance().getSOLBalance,

    // 'DOGE': WalletGetBalance().getSOLBalance,
    // 'APT': WalletGetBalance().getSOLBalance,
    // 'ETC': WalletGetBalance().getSOLBalance,
    // 'LTC': WalletGetBalance().getSOLBalance,
    // 'BCH': WalletGetBalance().getSOLBalance,
    // 添加其他代币的函数
  };
}
