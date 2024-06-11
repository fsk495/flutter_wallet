// ignore_for_file: file_names, camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wallet/home/wallet/wallet_DeFi.dart';
import 'package:flutter_wallet/home/wallet/wallet_NFT.dart';
import 'package:flutter_wallet/home/wallet/wallet_tokens.dart';
import 'package:flutter_wallet/plugins/buttonUtil.dart';
import 'package:flutter_wallet/plugins/publicData.dart';

class walletOptions extends StatefulWidget {
  const walletOptions({super.key});

  @override
  State<walletOptions> createState() => _WalletOptionsState();
}

class _WalletOptionsState extends State<walletOptions> {
  int value = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> walletPages = [
      const WalletTokens(),
      const WalletNFT(),
      const WalletDeFi(),
    ];
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: radioButtonList
                    .asMap()
                    .entries
                    .map(
                      (entry) => SetSingleChoiceButton(
                        chooseTextColor: Colors.black,
                        unChooseTextColor: PublicData.color4DA7A9,
                        chooseUnderlineColor: Colors.black,
                        unChooseUnderlineColor: Colors.transparent,
                        fontSize: PublicData.textSize_14,
                        name: entry.value.title,
                        onTap: () {
                          entry.value.onTap();
                          setState(() {
                            value = entry.key;
                          });
                        },
                        checked: value == entry.key,
                      ),
                    )
                    .toList(),
              )
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          walletPages[value],
        ],
      ),
    );
  }
}

class RadioButtonItem {
  final String title;
  final Function() onTap;

  RadioButtonItem({
    required this.title,
    required this.onTap,
  });
}

List<RadioButtonItem> radioButtonList = [
  RadioButtonItem(title: "代币", onTap: () {}),
  RadioButtonItem(title: "NFT", onTap: () {}),
  RadioButtonItem(title: "DeFi", onTap: () {}),
];
