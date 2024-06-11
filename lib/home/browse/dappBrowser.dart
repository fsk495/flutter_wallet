// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_wallet/home/browse/dappBrowser/dapp_model.dart';
import 'package:flutter_wallet/home/browse/dappBrowser/dapp_web_page.dart';
import 'package:get/get.dart';

class Web3WalletPage extends StatefulWidget {
  const Web3WalletPage({super.key});

  @override
  _Web3WalletPageState createState() => _Web3WalletPageState();
}

class _Web3WalletPageState extends State<Web3WalletPage> {
  late DappWebController _dappWebController;
  final String dappUrl = 'https://dapp.dragmeta.vip'; // 替换为你的DApp URL
  // final String dappUrl = 'https://fin1.novai.finance/#/';  // 替换为你的DApp URL
  // final _web3Client = Web3Client(
  //     "https://data-seed-prebsc-1-s1.bnbchain.org:8545", http.Client());
  final _privateKey =
      "97f448619b3487d4c8eaaa2daf5e965a7bb13efbed64c51dcbdba961ba692a72"; // 替换为你的私钥
  String signString = '';
  DappModel dappModel = DappModel("https://0xzx.com/wp-content/uploads/2021/05/20210530-19.jpg", "UniSwap");

  var lineProgress = 0.0;


  @override
  void initState() {
    super.initState();
    _dappWebController = DappWebController();
  }

  // 加载进度条
  _progressBar(double progress, BuildContext context) {
    return LinearProgressIndicator(
      backgroundColor: Colors.grey[200],
      value: lineProgress == 1.0 ? 0 : lineProgress,
      valueColor: const AlwaysStoppedAnimation(Colors.blue),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Web3 Wallet"),
        centerTitle: true,
        bottom: PreferredSize(
                child: _progressBar(lineProgress, context),
                preferredSize: const Size.fromHeight(2),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    _dappWebController.reload(); // 重新加载页面
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    // controller.reload(); // 重新加载页面
                    Get.back();
                  },
                ),
              ],
      ),
      body: DappWebPage(
        dappViewController: _dappWebController,
        onConsoleMessage: (value) {
          // Logger().i("onConsoleMessage  $value");
        },
        onProgressChanged: (value) {
          // Logger().w(value);
          setState(() {
            lineProgress = value / 100;
          });
        },
        
        onLoadStop: () {},
        url: dappUrl,
        address: "0x4bb8c2893CF939907Feca706bDeD3D35b8143100",
        privateKey: _privateKey,
        nodeAddress: 'https://data-seed-prebsc-2-s2.bnbchain.org:8545',
        dappModel: dappModel,
        selectChainName: 'BSC',
        
      ),
    );
  }
}
