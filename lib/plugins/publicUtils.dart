// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_wallet/plugins/publicData.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:qr_flutter/qr_flutter.dart';

String shortenEthereumAddress(
  String address, {
  int leadingChars = 6,
  int trailingChars = 6,
}) {
  if (address.length < (leadingChars + trailingChars + 2)) {
    return address;
  } else {
    // 提取前导和后导字符数量，默认为前6个字符和后4个字符
    final leadingPart = address.substring(0, leadingChars + 2); // 保持"0x"前缀
    final trailingPart = address.substring(address.length - trailingChars);

    return '$leadingPart...$trailingPart';
  }
}

void copyToClipboard(String text) async {
  await Clipboard.setData(ClipboardData(text: text));
}

/// 返回上一个界面按钮
Widget getBackLastInterfaceButton({Color color = Colors.black}) {
  return IconButton(
    onPressed: () {
      // 一般是返回上一个页面
      Get.back();
    },
    icon: Image.asset(
      "assets/public/icon_public_left_return.png",
      width: 12.w,
      height: 20.h,
      color: color,
    ),
  );
}

/// 跳转到帮助界面按钮
Widget getHelPanelpButton({required double height, required double width}) {
  return IconButton(
    onPressed: () {},
    icon: Image.asset(
      "assets/market/btn_help.png",
      color: Colors.black,
      width: width,
      height: height,
    ),
  );
}

/// title:浮点按钮的说明文字
/// callback:浮点按钮的回调函数
/// buttonClickColor:浮点按钮能够点击时的颜色 默认颜色为PublicData.color01888A
/// buttonUnClickColor:浮点按钮不能点击时的颜色 默认颜色为PublicData.color01888A4D
/// textColor:说明文字的颜色 默认颜色为白色
/// isCanClick:按钮是否能够点击 默认不能点击
Widget PublicFloatingActionButtonLocation({
  required String title,
  required VoidCallback callback,
  Color buttonClickColor = PublicData.color01888A,
  Color buttonUnClickColor = PublicData.color01888A4D,
  Color textColor = Colors.white,
  bool isCanClick = false,
  double fontSize = 48,
  double containerHeight = 160,
}) {
  return GestureDetector(
    behavior: HitTestBehavior.translucent,
    onTap: isCanClick
        ? () {
            callback();
          }
        : null,
    child: Container(
      margin: EdgeInsets.all(20.r),
      height: containerHeight,
      decoration: BoxDecoration(
        color: isCanClick ? buttonClickColor : buttonUnClickColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    ),
  );
}

/// 是否能够点击 更改图片按钮的颜色
Widget changeImageButtonColorByCanClick({
  required VoidCallback callback,
  required String imageUrl,
  required double width,
  required double height,
  bool isCanClick = false,
}) {
  return IconButton(
      onPressed: () {
        callback();
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      enableFeedback: false,
      icon: Image.asset(
        imageUrl,
        width: width,
        height: height,
        color: isCanClick ? null : Colors.grey,
      ));
}

/// 此函数将十六进制的区块链数据转换为十进制
int hexToInt_public(String hex, bool has0x) {
  // return int.parse(, radix: 16); // 跳过 '0x' 开头
  var newHex = has0x ? hex.substring(2) : hex;
  return int.parse(newHex, radix: 16); // 开头没有0x，直接转化
}

/// 此函数将十六进制的区块链数据转换为十进制
double hexToDouble(String hex) {
  // return int.parse(hex.substring(2), radix: 16); // 跳过 '0x' 开头
  return double.parse(BigInt.parse(hex, radix: 16).toString()); // 开头没有0x，直接转化
}

/// 将BigInt转化为十六进制的区块链数据
String BigIntToHex(BigInt value) {
  return value.toRadixString(16);
}

/// 此函数将 Wei 单位转换为 BNB 单位
double weiToBnb(int wei) {
  return wei / 1e18;
}

/// int转化为BigInt
BigInt intToBigInt(int value) {
  return BigInt.from(value);
}

/// 获取钱包地址的二维码
Widget GetQRCodeByWalletAddress({
  required String walletAddress,
  required double size,
}) {
  return QrImageView(
    data: walletAddress,
    version: QrVersions.auto,
    size: size,
    errorStateBuilder: (context, error) {
      Logger().e("GetQRCodeByWalletAddress error: $error");
      return Container();
    },
    // 添加图片到二维码中间
    // embeddedImage: AssetImage('assets/images/my_embedded_image.png'),
    // embeddedImageStyle: QrEmbeddedImageStyle(
    //   size: Size(80, 80),
    // ),
  );
}

/// 获取币种的图标
Widget GetImageCoinByUrl({
  required String url,
  required double width,
  required double height,
}) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.0),
          spreadRadius: 2,
          blurRadius: 4,
          offset: const Offset(0, 2),
        )
      ],
    ),
    child: ClipOval(
      child: Image.network(
        url,
        width: width,
        height: height,
        errorBuilder:
            (BuildContext context, Object error, StackTrace? stackTrace) {
          Logger().e("GetImageCoinByUrl   error $error   $url");

          /// 错误问题
          return Image.asset(
            'assets/public/icon_defalut_coin.png',
            width: width,
            height: height,
          );
        },
      ),
    ),
  );
}

bool isValidEthereumAddress(String address) {
  final pattern = RegExp(r'^0x[a-fA-F0-9]{40}$');
  return pattern.hasMatch(address);
}

/// 省略过多的数字，添加 亿，万等单位
String formatNumber(int amount) {
  final formatter = NumberFormat('#,##0.00', 'zh_CN');
  String formattedNum = formatter.format(amount);
  String unit = '';

  if (amount >= 100000000) {
    formattedNum = (amount / 100000000).toStringAsFixed(2);
    unit = "亿";
  } else if (amount >= 10000) {
    formattedNum = (amount / 10000).toStringAsFixed(2);
    unit = '万';
  } else {
    unit = '';
  }

  return '$formattedNum $unit';
}

Widget LoadingScreen() {
  Logger().i(" 加载动画  ");

  return Scaffold(
    backgroundColor: Colors.black54,
    body: Center(
      child: SpinKitCircle(
        color: Colors.white,
        size: 50.r,
      ),
    ),
  );
}
