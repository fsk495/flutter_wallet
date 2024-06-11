// ignore_for_file: file_names, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wallet/data/userInfoData.dart';
import 'package:flutter_wallet/plugins/publicData.dart';
import 'package:flutter_wallet/plugins/publicUtils.dart';
import 'package:flutter_wallet/plugins/router.dart';
import 'package:flutter_wallet/plugins/showDiaologController.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

Widget intervalSizedBox = SizedBox(
  height: 10.h,
);

class CreateIdentityPage extends StatefulWidget {
  const CreateIdentityPage({super.key});

  @override
  State<CreateIdentityPage> createState() => _CreateIdentityPageState();
}

class _CreateIdentityPageState extends State<CreateIdentityPage> {
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerPassword2 = TextEditingController();
  final TextEditingController _controllerPasswordTip = TextEditingController();
  final UserInfoData userInfoData = Get.find();
  final ShowDiaologController showDiaologController = Get.find();

  bool _isKeyboardVisible = false;


  bool hidePassWord = true;

  bool isAgree = false;
  bool isCanClick = false;

  @override
  void initState() {
    super.initState();
    KeyboardVisibilityController().onChange.listen((bool visible) { 
      setState(() {
        _isKeyboardVisible = visible;
        Logger().i("_isKeyboardVisible   $_isKeyboardVisible");
      });
    });
  }

  @override
  void dispose() {
    _controllerName.dispose();
    _controllerPassword2.dispose();
    _controllerPassword.dispose();
    _controllerPasswordTip.dispose();

    super.dispose();
  }


  _changeSureButtonIsCanClick() {
    if (!isAgree ||
        _controllerName.text.isEmpty ||
        _controllerPassword.text.isEmpty ||
        _controllerPassword2.text.isEmpty) {
      setState(() {
        isCanClick = false;
      });
      return;
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
      setState(() {
        isCanClick = false;
      });
      Logger().w("没有同意服务条款");
      showDiaologController.showSnackBar("没有同意服务条款", "提示", 2);
      return;
    }
    if (_controllerName.text.isEmpty) {
      setState(() {
        isCanClick = false;
      });
      Logger().w("身份名称不能为空");
      showDiaologController.showSnackBar("身份名称不能为空", "提示", 2);
      return;
    }
    if (_controllerPassword.text.isEmpty) {
      setState(() {
        isCanClick = false;
      });
      Logger().w("密码不能为空");
      showDiaologController.showSnackBar("密码不能为空", "提示", 2);
      return;
    }
    if (_controllerPassword.text != _controllerPassword2.text) {
      setState(() {
        isCanClick = false;
      });
      Logger().w("两次密码不一致");
      showDiaologController.showSnackBar("两次密码不一致", "提示", 2);
      return;
    }
    Get.toNamed(RouteJumpConfig.addCurrency, arguments: {
      'toHome': false,
      'password': _controllerPassword.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: getBackLastInterfaceButton(),
        backgroundColor: PublicData.colorF2F9F9,
        actions: [
          getHelPanelpButton(width: 19.w, height: 19.w),
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
                    "创建身份",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: PublicData.textSize_16,
                      color: PublicData.color333333,
                    ),
                  ),
                  intervalSizedBox,
                  Text(
                    "设定你的身份名，并创建一组密码，你将拥有全新的多链钱包。",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: PublicData.textSize_12,
                      color: PublicData.color01888A,
                    ),
                  ),
                  intervalSizedBox,
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero, // 移除任何内边距
                    ),
                    child: Text(
                      "什么是身份？",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: PublicData.textSize_12,
                        color: PublicData.colorA2B51C,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 10.w,
                    ),
                    child: Text(
                      "身份名称",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: PublicData.textSize_12,
                        color: PublicData.color4DA7A9,
                      ),
                    ),
                  ),
                  intervalSizedBox,
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: TextField(
                      controller: _controllerName,
                      onChanged: (text) {
                        _changeSureButtonIsCanClick();
                      },
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: PublicData.textSize_14,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "输入1-12个字符",
                        hintStyle: TextStyle(
                          color: PublicData.colorB9DFE0,
                          fontWeight: FontWeight.w400,
                          fontSize: PublicData.textSize_14,
                        ),
                      ),
                    ),
                  ),
                  intervalSizedBox,
                  Padding(
                    padding: EdgeInsets.only(
                      left: 10.w,
                    ),
                    child: Text(
                      "密码",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: PublicData.textSize_12,
                        color: PublicData.color4DA7A9,
                      ),
                    ),
                  ),
                  intervalSizedBox,
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
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  intervalSizedBox,
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
                  intervalSizedBox,
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
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child:_isKeyboardVisible? const SizedBox():Column(
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
                    // userInfoData.localWalletName.value = _controllerName.text;
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
