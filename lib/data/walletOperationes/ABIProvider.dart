// ignore_for_file: file_names

import 'package:web3dart/web3dart.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class ABIProvider {
  static final Map<String, String> _abiMap = {
    "USDT": 'assets/ABIJson/usdt.json',
    "STETH": 'assets/ABIJson/steth.json',
    "USDC": 'assets/ABIJson/usdc.json',
    "SHIB": 'assets/ABIJson/shib.json',
    "WBTC": 'assets/ABIJson/wbtc.json',
    "LINK": 'assets/ABIJson/link.json',
    "UNI": 'assets/ABIJson/uni.json',
    "MATIC": 'assets/ABIJson/matic.json',
    "FET": 'assets/ABIJson/fet.json',
    "LEO": 'assets/ABIJson/leo.json',
    "DAI": 'assets/ABIJson/dai.json',
    "PEPE": 'assets/ABIJson/pepe.json',
    "WEETH": 'assets/ABIJson/weeth.json',
    "RNDR": 'assets/ABIJson/rndr.json',
    "IMX": 'assets/ABIJson/imx.json',
    "EZETH": 'assets/ABIJson/ezeth.json',
    "FDUSD": 'assets/ABIJson/fdusd.json',
    "MNT": 'assets/ABIJson/mnt.json',
    "GRT": 'assets/ABIJson/grt.json',
  };

  static Future<DeployedContract> getContract(String symbol, String contractAddress) async {
    String abiJson = await rootBundle.loadString(_abiMap[symbol]!);
    var contractAbi = ContractAbi.fromJson(jsonDecode(abiJson), 'ERC20');
    var ethAddress = EthereumAddress.fromHex(contractAddress);
    return DeployedContract(contractAbi, ethAddress);
  }
}
