// ignore_for_file: camel_case_types, file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wallet/data/getMarketValueProvider.dart';
import 'package:flutter_wallet/home/market/marketQuotes_defi.dart';
import 'package:flutter_wallet/home/market/marketQuotes_marketValue.dart';
import 'package:flutter_wallet/plugins/buttonUtil.dart';
import 'package:flutter_wallet/plugins/publicData.dart';
import 'package:get/get.dart';

class marketQuotesPage extends StatefulWidget {
  const marketQuotesPage({super.key});

  @override
  State<marketQuotesPage> createState() => _MarketQuotesPageState();
}

class _MarketQuotesPageState extends State<marketQuotesPage> {
  List<dynamic> tokens = [];
  final GetMarketValue getMarketValue = Get.find();
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  List<Widget> marketPages = [
    // Container(),
    const Center(
      child: Text("暂无"),
    ),
    const MarketQuotesMarketValue(),
    const MarketQuotesDeFI(),
  ];

  Widget singleButton() {
    return Row(
      children: radioButtonList
          .asMap()
          .entries
          .map((entry) => SetSingleChoiceButton(
                name: entry.value.title,
                chooseTextColor: Colors.black,
                unChooseTextColor: PublicData.color4DA7A9,
                chooseUnderlineColor: Colors.black,
                unChooseUnderlineColor: Colors.transparent,
                fontSize: PublicData.textSize_13,
                onTap: () {
                  entry.value.onTap();
                  setState(() {
                    selectedIndex = entry.key;
                  });
                },
                checked: selectedIndex == entry.key,
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        singleButton(),
        SizedBox(
          height: 5.h,
        ),
        marketPages[selectedIndex],
      ],
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
  RadioButtonItem(title: "自选", onTap: () {}),
  RadioButtonItem(title: "市值", onTap: () {}),
  RadioButtonItem(title: "DeFi", onTap: () {}),
];
