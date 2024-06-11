// ignore_for_file: file_names, library_prefixes, unused_element

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wallet/data/userInfoData.dart';
import 'package:flutter_wallet/plugins/localDataController.dart';
import 'package:flutter_wallet/plugins/publicData.dart';
import 'package:flutter_wallet/plugins/publicUtils.dart';
import 'package:flutter_wallet/plugins/router.dart';
import 'package:flutter_wallet/plugins/showDiaologController.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import 'package:bip39/bip39.dart' as bip39;

var verticalSizedBox = SizedBox(
  height: 10.h,
);

class RecoveryIdentityPage extends StatefulWidget {
  const RecoveryIdentityPage({super.key});

  @override
  State<RecoveryIdentityPage> createState() => _RecoveryIdentityPageState();
}

class _RecoveryIdentityPageState extends State<RecoveryIdentityPage> {
  /// 助记词列表
  List<String> bip39Words = [];
  List<TextEditingController> mnemonicControllers =
      List.generate(12, (_) => TextEditingController());

  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerPassword2 = TextEditingController();
  final TextEditingController _controllerPasswordTip = TextEditingController();

  final UserInfoData userInfoData = Get.find();
  final LocalDataController localDataController = Get.find();

  bool hidePassWord = true;
  bool isAgree = false;
  bool isCanClick = false;

  // 存储助记词和对应的边框颜色
  List<Map<String, dynamic>> mnemonicFields = [];

  ShowDiaologController showDiaologController = Get.find();

  bool _isKeyboardVisible = false;

  @override
  initState() {
    super.initState();
    _loadBip39Words();

    KeyboardVisibilityController().onChange.listen((bool visible) {
      setState(() {
        _isKeyboardVisible = visible;
        Logger().i("_isKeyboardVisible   $_isKeyboardVisible");
      });
    });

    // 初始化12个助记词输入框，每个都有一个controller和默认的边框颜色
    for (int i = 0; i < 12; i++) {
      mnemonicFields.add({
        'borderColor': Colors.grey,
        'isTrue': false,
      });
    }
  }

  Future<void> _loadBip39Words() async {
    // 从 assets 文件夹加载 BIP-39 词汇表
    final data = await rootBundle.loadString('assets/bip39_words.txt');
    bip39Words = data.split('\n').map((e) => e.trim()).toList();
  }

  bool _checkMnemonic(String word) {
    return bip39Words.contains(word.toLowerCase());
  }

  bool _isDuplicate(int currentIndex, String value) {
    for (int i = 0; i < mnemonicControllers.length; i++) {
      if (i != currentIndex && mnemonicControllers[i].text == value) {
        return true;
      }
    }
    return false;
  }

  void _checkAndSetBorderColor(int index, String value) {
    var isBip39 = _checkMnemonic(value);
    var isDuplicate = _isDuplicate(index, value);
    setState(() {
      mnemonicFields[index]['borderColor'] =
          isBip39 ? (isDuplicate ? Colors.red : Colors.green) : Colors.red;
      mnemonicFields[index]['isTrue'] = (isBip39 && !isDuplicate);
    });
  }

  @override
  void dispose() {
    for (int i = 0; i < mnemonicControllers.length; i++) {
      mnemonicControllers[i].dispose();
    }

    _controllerPassword.dispose();
    _controllerPassword2.dispose();
    _controllerPasswordTip.dispose();

    super.dispose();
  }

  _changeSureButtonIsCanClick() {
    bool isEmpty = false;
    for (int i = 0; i < mnemonicControllers.length; i++) {
      if (mnemonicControllers[i].text.isEmpty) {
        isEmpty = true;
        break;
      }
    }
    if (!isAgree ||
        isEmpty ||
        _controllerPassword.text.isEmpty ||
        _controllerPassword2.text.isEmpty) {
      setState(() {
        isCanClick = false;
      });
      return;
    }
    for (var i = 0; i < mnemonicFields.length; i++) {
      if (!mnemonicFields[i]['isTrue']) {
        setState(() {
          isCanClick = false;
        });
        return;
      }
    }
    setState(() {
      isCanClick = true;
    });
  }

  _registerHandler() {
    if (!isCanClick) {
      return;
    }
    if (!isAgree) {
      isCanClick = false;
      Logger().w("没有同意服务条款");
      showDiaologController.showAlertDialog("提示", "没有同意服务条款");
      return;
    }
    bool isNot = false;
    for (int i = 0; i < mnemonicControllers.length; i++) {
      if (!_checkMnemonic(mnemonicControllers[i].text)) {
        isNot = true;
        break;
      }
    }
    if (isNot) {
      setState(() {
        isCanClick = false;
      });
      showDiaologController.showAlertDialog("提示", "助记词不对");
    }

    if (_controllerPassword.text.isEmpty) {
      setState(() {
        isCanClick = false;
      });
      showDiaologController.showAlertDialog("提示", "密码不能为空");
      return;
    }
    if (_controllerPassword.text != _controllerPassword2.text) {
      setState(() {
        isCanClick = false;
      });
      showDiaologController.showAlertDialog("提示", "两次密码不一致");
      return;
    }
    try {
      String mnemonic =
          mnemonicControllers.map((controller) => controller.text).join(' ');
      var isValidate = bip39.validateMnemonic(mnemonic);

      if (isValidate) {
        userInfoData.setMnemonic(mnemonic);
      } else {
        showDiaologController.showAlertDialog("提示", "助记词无效");
      }
    } catch (e) {
      Logger().e("RecoveryIdentityPage  error:  $e");
    }
    Logger().i("跳转到添加到币种界面");
    Get.toNamed(RouteJumpConfig.addCurrency, arguments: {
      'toHome': true,
      'password': _controllerPassword.text,
    });
  }

  Widget setLayoutItem(int index) {
    return Row(
      children: [
        Text(
          "$index",
          style: TextStyle(
            color: PublicData.color333333,
            fontSize: PublicData.textSize_12,
          ),
        ),
        SizedBox(
          width: 5.w,
        ),
        Container(
          width: 85.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: mnemonicFields[index - 1]["borderColor"],
            ),
          ),
          child: TextField(
            textAlign: TextAlign.center,
            textAlignVertical: TextAlignVertical.center,
            controller: mnemonicControllers[index - 1],
            onChanged: (value) {
              _checkAndSetBorderColor(index - 1, value);
              _changeSureButtonIsCanClick();
            },
            style: TextStyle(
              color: PublicData.color131313,
              fontSize: PublicData.textSize_12,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "",
              hintStyle: TextStyle(
                color: PublicData.color01888A4D,
                fontSize: PublicData.textSize_12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget setLayout() {
    var rows = [
      [
        1,
        2,
        3,
      ],
      [
        4,
        5,
        6,
      ],
      [
        7,
        8,
        9,
      ],
      [
        10,
        11,
        12,
      ]
    ];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: rows[0].asMap().entries.map((entry) {
            var index = rows[0][entry.key];
            return setLayoutItem(index);
          }).toList(),
        ),
        verticalSizedBox,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: rows[1].asMap().entries.map((entry) {
            var index = rows[1][entry.key];
            return setLayoutItem(index);
          }).toList(),
        ),
        verticalSizedBox,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: rows[2].asMap().entries.map((entry) {
            var index = rows[2][entry.key];
            return setLayoutItem(index);
          }).toList(),
        ),
        verticalSizedBox,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: rows[3].asMap().entries.map((entry) {
            var index = rows[3][entry.key];
            return setLayoutItem(index);
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: getBackLastInterfaceButton(),
        actions: [
          getHelPanelpButton(height: 19.w, width: 19.w),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
              child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "恢复身份",
                  style: TextStyle(
                    color: PublicData.color333333,
                    fontSize: PublicData.textSize_16,
                  ),
                ),
                verticalSizedBox,
                Text(
                  "你将会拥有身份下的多链钱包，比如 ETH、BTC、 COSMOS、EOS...",
                  style: TextStyle(
                    color: PublicData.color01888A,
                    fontSize: PublicData.textSize_13,
                  ),
                ),
                verticalSizedBox,
                verticalSizedBox,
                setLayout(),
                verticalSizedBox,
                Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: Text(
                    "创建密码",
                    style: TextStyle(
                      color: PublicData.color4DA7A9,
                      fontSize: PublicData.textSize_12,
                    ),
                  ),
                ),
                verticalSizedBox,
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      TextField(
                        controller: _controllerPassword,
                        onChanged: (text) {
                          _changeSureButtonIsCanClick();
                        },
                        obscureText: hidePassWord,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: PublicData.textSize_14,
                        ),
                        decoration: InputDecoration(
                          hintText: "输入密码",
                          hintStyle: TextStyle(
                            color: PublicData.colorB9DFE0,
                            fontWeight: FontWeight.w400,
                            fontSize: PublicData.textSize_14,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _controllerPassword2,
                              onChanged: (text) {
                                _changeSureButtonIsCanClick();
                              },
                              obscureText: hidePassWord,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: PublicData.textSize_14,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "重复输入密码",
                                hintStyle: TextStyle(
                                  color: PublicData.colorB9DFE0,
                                  fontWeight: FontWeight.w400,
                                  fontSize: PublicData.textSize_14,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                hidePassWord = !hidePassWord;
                              });
                            },
                            icon: hidePassWord
                                ? Image.asset(
                                    "assets/login/password_hide.png",
                                    width: 15.w,
                                    height: 8.h,
                                  )
                                : Image.asset(
                                    "assets/login/password_show.png",
                                    width: 15.w,
                                    height: 11.h,
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                verticalSizedBox,
                Padding(
                  padding: EdgeInsets.only(
                    left: 10.w,
                  ),
                  child: Text(
                    "密码提示（可选）",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: PublicData.textSize_12,
                      color: PublicData.color4DA7A9,
                    ),
                  ),
                ),
                verticalSizedBox,
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: TextField(
                    controller: _controllerPasswordTip,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: PublicData.textSize_14,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "输入提示文字",
                      hintStyle: TextStyle(
                        color: PublicData.colorB9DFE0,
                        fontWeight: FontWeight.w400,
                        fontSize: PublicData.textSize_14,
                      ),
                    ),
                  ),
                ),
                verticalSizedBox,
                GestureDetector(
                  onTap: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/login/login_help.png",
                        width: 11.w,
                        height: 11.w,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        "如何迁移Token Name 1.0 钱包",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: PublicData.textSize_11,
                          color: PublicData.colorA2B51C,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _isKeyboardVisible
                ? const SizedBox()
                : Column(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Row(
                          children: [
                            changeImageButtonColorByCanClick(
                              callback: () {
                                setState(() {
                                  isAgree = !isAgree;
                                });
                                _changeSureButtonIsCanClick();
                              },
                              imageUrl: 'assets/login/login_choose.png',
                              isCanClick: isAgree,
                              width: 17.w,
                              height: 17.w,
                            ),
                            Text(
                              "我已阅读并同意",
                              style: TextStyle(
                                color: PublicData.color01888A,
                                fontWeight: FontWeight.w400,
                                fontSize: PublicData.textSize_10,
                              ),
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero, // 移除任何内边距
                              ),
                              onPressed: () {
                                Logger().w("跳转到服务条款的网址");
                              },
                              child: Text(
                                "Token Name 服务条款",
                                style: TextStyle(
                                  color: PublicData.colorA2B51C,
                                  fontWeight: FontWeight.w400,
                                  fontSize: PublicData.textSize_10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      PublicFloatingActionButtonLocation(
                        title: '创建身份',
                        callback: () {
                          _registerHandler();
                        },
                        isCanClick: isCanClick,
                        fontSize: PublicData.textSize_16,
                        containerHeight: 46.h,
                      )
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
