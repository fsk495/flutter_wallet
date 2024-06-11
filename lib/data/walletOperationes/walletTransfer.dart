// ignore_for_file: file_names, constant_identifier_names, no_leading_underscores_for_local_identifiers

import 'dart:convert';

import 'package:flutter_wallet/data/userInfoData.dart';
import 'package:flutter_wallet/data/walletOperationes/ABIProvider.dart';
import 'package:flutter_wallet/data/walletOperationes/walletBaseUrl.dart';
import 'package:flutter_wallet/plugins/showDiaologController.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter_wallet/plugins/publicUtils.dart';

/// 钱包之间的转账
class WalletTransfer {
  static final UserInfoData userInfoData = Get.find();
  static ShowDiaologController showDiaologController = Get.find();


  static Future<void> sendETHTransaction(
    String recipientAddress,
    String senderBalance,
  ) async {
    var walletAddressList = userInfoData
        .allWalletAddressList[userInfoData.chooseNetworkIndex.value]
        .walletAddressList;
    var personalPrivateKey = userInfoData
        .allWalletAddressList[userInfoData.chooseNetworkIndex.value]
        .personalPrivateKey;

    final fromAddress = walletAddressList[userInfoData.chooseWalletIndex.value];
    final privateKey = personalPrivateKey[userInfoData.chooseWalletIndex.value];

    // 以太坊转账需要构造原始交易数据
    // 这里示例一个简化的构造方式，请根据实际情况修改
    final nonce = await getNonce(fromAddress, "ETH"); // 获取发送方地址的 nonce
    final gasPrice = await getGasPrice("ETH"); // 估计的 gas 价格

    const gasLimit = 21000; // 估计的 gas 上限
    final value = EtherAmount.fromBase10String(
        EtherUnit.ether, senderBalance); // 转账金额，单位为以太
    final credentials = EthPrivateKey.fromHex(privateKey);
    Transaction transaction = Transaction(
      nonce: int.parse(nonce),
      from: EthereumAddress.fromHex(fromAddress),
      gasPrice: gasPrice,
      maxGas: gasLimit,
      to: EthereumAddress.fromHex(recipientAddress),
      value: value,
    );

    // 对原始交易数据进行签名
    final signedTransaction = await signTransaction(transaction, credentials);

    final url = Uri.parse(ApiUrl.getETHApiUrl);
    final response = await http.post(url, body: {
      'module': 'proxy',
      'action': 'eth_sendRawTransaction',
      'hex': bytesToHex(signedTransaction),
      'apikey': ApiUrl.ETHApiKey,
    });
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      Logger().i("ETH Transaction Response: $responseData");

      if (responseData['error'] != null) {
        Logger().e(
            "Failed to send ERC20 transaction: ${responseData['error']['message']}");
      } else {
        final txHash = responseData['result'];
        Logger().i("ERC20 Transaction Hash: $txHash");

        // 等待一段时间以确保交易被确认
        await Future.delayed(const Duration(seconds: 30));
        // 查询交易状态
        await checkTransactionStatus(txHash, 'ETH');
      }
    } else {
      Logger().i("Failed to send ETH transaction: ${response.statusCode}");
    }
  }

  static Future<void> sendBNBTransaction(
    String recipientAddress,
    String senderBalance,
  ) async {
    var personalPrivateKey = userInfoData
        .allWalletAddressList[userInfoData.chooseNetworkIndex.value]
        .personalPrivateKey;

    final privateKey = personalPrivateKey[userInfoData.chooseWalletIndex.value];

    // 构建 BSCScan API 地址
    final apiUrl = Uri.parse(ApiUrl.getBNBApiUrl);

    // 获取发送方地址
    final credentials = EthPrivateKey.fromHex(privateKey);
    final fromAddress = credentials.address;

    // 获取发送方地址的 nonce
    final nonce = await getNonce(fromAddress.hex, "BNB");

    // 估计的 gas 价格和 gas 上限
    final gasPrice = await getGasPrice('BNB');
    const gasLimit = 21000;

    // 转账金额，单位为以太
    final value = EtherAmount.fromBase10String(
        EtherUnit.wei, senderBalance); // BNB 转账不需要指定 value

    // 构造原始交易数据
    final transaction = Transaction(
      from: fromAddress,
      nonce: int.parse(nonce),
      gasPrice: gasPrice,
      maxGas: gasLimit,
      to: EthereumAddress.fromHex(recipientAddress),
      value: value,
    );

    // 对原始交易数据进行签名
    final client = Web3Client(ApiUrl.getBNBApiUrl, http.Client());
    final signedTransaction = await client.signTransaction(
      credentials,
      transaction,
      chainId: 56,
    );

    // 发送转账请求
    final response = await http.post(apiUrl, body: {
      'module': 'proxy',
      'action': 'eth_sendRawTransaction',
      'hex': bytesToHex(signedTransaction),
      'apikey': ApiUrl.BNBApiKey, // 您的 BSCScan API 密钥
    });

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      Logger().i("BNB Transaction Response: $responseData");

      if (responseData['error'] != null) {
        Logger().e(
            "Failed to send BNB transaction: ${responseData['error']['message']}");
      } else {
        final txHash = responseData['result'];
        Logger().i("BNB Transaction Hash: $txHash");

        // 等待 30 秒，然后查询交易状态
        await Future.delayed(const Duration(seconds: 30));
        await checkTransactionStatus(txHash, "BNB");
      }
    } else {
      Logger().e("Failed to send BNB transaction: ${response.statusCode}");
    }
  }

  static Future<List<int>> signTransaction(
      Transaction transaction, EthPrivateKey privateKey) async {
    // 使用私钥对交易数据进行签名
    final client = Web3Client(ApiUrl.getETHApiUrl, http.Client());
    final signed = await client.signTransaction(privateKey, transaction);
    // 请使用你选择的加密库进行签名
    // 这里仅作示例，实际应用中需使用有效的签名方式
    // 可以考虑使用 web3dart 或 ethers.js 等库进行签名
    Logger().i("signTransaction   $signed");
    return signed;
  }

  static Future<void> sendERC20Transaction(
    String recipientAddress,
    String senderBalance,
    String symbol,
  ) async {
    var walletAddressList = userInfoData
        .allWalletAddressList[userInfoData.chooseNetworkIndex.value]
        .walletAddressList;
    var personalPrivateKey = userInfoData
        .allWalletAddressList[userInfoData.chooseNetworkIndex.value]
        .personalPrivateKey;

    final fromAddress = walletAddressList[userInfoData.chooseWalletIndex.value];
    final privateKey = personalPrivateKey[userInfoData.chooseWalletIndex.value];
    final contractAddress =
        ApiUrl.contractAddress[symbol]; // ERC20 Token contract address

    final url = Uri.parse(ApiUrl.getETHApiUrl);

    final nonce = await getNonce(fromAddress, "ERC20");

    // 估计的 gas 价格和 gas 上限
    final gasPrice = await getGasPrice("ERC20");
    const gasLimit = 60000; // ERC20 token transfer gas limit

    final tokenContract =
        await ABIProvider.getContract(symbol.toUpperCase(), contractAddress!);

    final transferFunction = tokenContract.function('transfer');
    final data = transferFunction.encodeCall([
      EthereumAddress.fromHex(recipientAddress),
      BigInt.parse(senderBalance),
    ]);

    final credentials = EthPrivateKey.fromHex(privateKey);
    Transaction transaction = Transaction(
      from: EthereumAddress.fromHex(fromAddress),
      nonce: int.parse(nonce),
      gasPrice: gasPrice,
      maxGas: gasLimit,
      to: EthereumAddress.fromHex(contractAddress),
      value: EtherAmount.zero(),
      data: data,
    );
    final signedTransaction = await signTransaction(transaction, credentials);
    final response = await http.post(
      url,
      body: {
        "module": "proxy",
        "action": "eth_sendRawTransaction",
        "hex": bytesToHex(signedTransaction),
        "apikey": ApiUrl.ETHApiKey,
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      Logger().i("ERC20 Transaction Response: $responseData");

      if (responseData['error'] != null) {
        Logger().e(
            "Failed to send ERC20 transaction: ${responseData['error']['message']}");
      } else {
        final txHash = responseData['result'];
        Logger().i("ERC20 Transaction Hash: $txHash");

        // 等待一段时间以确保交易被确认
        await Future.delayed(const Duration(seconds: 30));
        // 查询交易状态
        await checkTransactionStatus(txHash, 'ERC20');
      }
    } else {
      Logger().e("Failed to send ERC20 transaction: ${response.statusCode}");
    }
  }

  static Future<bool> checkTransactionStatus(String txHash, String type) async {
    Logger().i("检测订单是否成功");

    var urlHead = type == "BNB" ? "api.bscscan.com" : "api.etherscan.io";
    var apikey = type == "BNB" ? ApiUrl.BNBApiKey : ApiUrl.ETHApiKey;
    final url = Uri.https(urlHead, "/api", {
      "module": "transaction",
      "action": "gettxreceiptstatus",
      "txhash": txHash,
      "apikey": apikey,
    });

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['result']['status'] == "1") {
        Logger().i("Transaction Successful: $txHash");
        return true;
      } else {
        Logger().e("Transaction Failed: $txHash");
        return false;
      }
    } else {
      Logger().e("Failed to check transaction status: ${response.statusCode}");
      return false;
    }
  }

  static Future<String> getNonce(String address, String type) async {
    // 从以太坊节点获取 nonce
    // 请根据实际情况修改获取 nonce 的逻辑
    var urlHead = type == "BNB" ? "api.bscscan.com" : "api.etherscan.io";
    var apikey = type == "BNB" ? ApiUrl.BNBApiKey : ApiUrl.ETHApiKey;
    // 这里仅作示例，实际应用中需使用有效的 nonce 获取方式
    final url = Uri.https(urlHead, '/api', {
      'module': 'proxy',
      'action': 'eth_getTransactionCount',
      'address': address,
      'tag': 'latest',
      'apikey': apikey,
    });
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      // result是十六进制字符串，需要转换为十进制
      String nonceHex = responseData['result'];
      int nonce = hexToInt_public(nonceHex, true);
      Logger().i("getNonce   $nonce");
      return nonce.toString();
    } else {
      throw Exception('Failed to get nonce');
    }
  }

  static Future<EtherAmount> getGasPrice(String type) async {
    String apiUrl;
    if (type == 'BNB') {
      apiUrl = 'api.bscscan.com';
    } else {
      apiUrl = 'api.etherscan.io';
    }
    String apikey = type == "BNB" ? ApiUrl.BNBApiKey : ApiUrl.ETHApiKey;
    final url = Uri.https(apiUrl, '/api', {
      'module': 'proxy',
      'action': 'eth_gasPrice',
      'apikey': apikey,
    });

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      int gasPriceInt = hexToInt_public(responseData['result'], true);
      Logger().i(" getGasPrice gasPriceInt  $gasPriceInt  ");
      // 使用EtherAmount.inWei将Wei转换为以太
      BigInt gasPriceWei = intToBigInt(gasPriceInt);
      Logger().i(" getGasPrice gasPriceWei  $gasPriceWei  ");
      EtherAmount gasPriceEther = EtherAmount.inWei(gasPriceWei);
      return gasPriceEther;
    } else {
      throw Exception('Failed to fetch gas price');
    }
  }

  static sendNovaiTransaction(
    String recipientAddress,
    String senderBalance,
  ) async {
    Web3Client _client = Web3Client("http://54.80.49.30:8545", http.Client());
    var personalPrivateKey = userInfoData
        .allWalletAddressList[userInfoData.chooseNetworkIndex.value]
        .personalPrivateKey;

    final privateKey = personalPrivateKey[userInfoData.chooseWalletIndex.value];

    try {
      /// 创建钱包和凭据
    final credentials = EthPrivateKey.fromHex(privateKey);
    final address = credentials.address;

    /// 获取当前gas价格
    final gasPrice = await getGasPriceByRPCUrl("http://54.80.49.30:8545");//_client.getGasPrice();

    Logger().i('发送地址: $address');
    Logger().i('接收地址: $recipientAddress');
    Logger().i('发送金额: $senderBalance');
    Logger().i('当前 gas 价格: $gasPrice');

    final value = BigInt.parse((double.parse(senderBalance) * 1e18).toStringAsFixed(0));//EtherAmount.fromBase10String(EtherUnit.ether, senderBalance);

    /// 创建交易
    final Transaction transaction = Transaction(
      from: address,
      to: EthereumAddress.fromHex(recipientAddress),
      value: EtherAmount.inWei(value),
      gasPrice: gasPrice,
      maxGas: 21000,
    );

    /// 发送交易
    final txHash = await _client.sendTransaction(
      credentials,
      transaction,
      chainId: 9000,
    );

    Logger().i('交易哈希: $txHash');
    await Future.delayed(const Duration(seconds: 30));
    await _verifyTransaction(txHash);
    } catch (e) {
      Logger().e('交易失败: $e');
      showDiaologController.showSnackBar("'交易失败!", '', 3);
    }
  }

  static Future<EtherAmount> getGasPriceByRPCUrl(String rpcUrl)async{
    // Web3Client _client = Web3Client("http://54.80.49.30:8545", http.Client());
    Web3Client _client = Web3Client(rpcUrl, http.Client());
    final gasPrice = await _client.getGasPrice();
    return gasPrice;
  }



  /// 验证交易是否成功
  static Future<void> _verifyTransaction(String txHash) async {
    try {
      Web3Client _client = Web3Client("http://54.80.49.30:8545", http.Client());

      final receipt = await _client.getTransactionReceipt(txHash);
      if (receipt != null && receipt.status == true) {
        Logger().i('交易成功! 状态: ${receipt.status}');
        showDiaologController.showSnackBar("'交易成功!", '', 3);
      } else {
        Logger().i('交易失败或仍在处理中');
        showDiaologController.showSnackBar("'交易失败或仍在处理中!", '', 3);
      }
    } catch (e) {
      Logger().i('验证交易失败: $e');
      showDiaologController.showSnackBar("'验证交易失败!", '', 3);
    }
  }


  static sendTransaction(
    String recipientAddress,
    String senderBalance,
    String tokenSymbol,
  ) {
    Logger().w("发送转账订单   ");
    switch (tokenSymbol) {
      case "ETH":
        return sendETHTransaction(recipientAddress, senderBalance);
      case 'BNB':
        return sendBNBTransaction(recipientAddress, senderBalance);

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
        return sendERC20Transaction(
          recipientAddress,
          senderBalance,
          tokenSymbol,
        );
      case "NOV":
        return sendNovaiTransaction(
          recipientAddress,
          senderBalance,
        );
      default:
        Logger().e("Unsupported token: $tokenSymbol");
        return {};
    }
  }
}
