// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wallet/plugins/publicData.dart';
import 'package:flutter_wallet/plugins/router.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class LoginOrRegisterPage extends StatelessWidget {
  const LoginOrRegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Image.asset("assets/login/login_head.png"),
              SizedBox(
                height: 16.h,
              ),
              Center(
                child: Text(
                  "多链钱包，轻松使用",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: PublicData.textSize_20,
                    color: PublicData.color333333,
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 36.h,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 21.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(20.r),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: PublicData.colorB9DFE0,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(7.r),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Logger().i("创建身份");
                        Get.toNamed(RouteJumpConfig.createIdentity);
                      },
                      behavior: HitTestBehavior.translucent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '创建身份',
                                style: TextStyle(
                                  color: PublicData.color01888A,
                                  fontSize: PublicData.textSize_14,
                                ),
                              ),
                              Text(
                                '使用新的多链钱包',
                                style: TextStyle(
                                  color: PublicData.color8DC2C3,
                                  fontSize: PublicData.textSize_11,
                                ),
                              ),
                            ],
                          ),
                          Image.asset(
                            "assets/browse/browse_right.png",
                            width: 5.w,
                            height: 8.h,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Container(
                    padding: EdgeInsets.all(20.r),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: PublicData.colorB9DFE0,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(7.r),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed(RouteJumpConfig.recoveryIdentity);
                      },
                      behavior: HitTestBehavior.translucent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '恢复身份',
                                style: TextStyle(
                                  color: PublicData.color01888A,
                                  fontSize: PublicData.textSize_14,
                                ),
                              ),
                              Text(
                                '使用我已拥有的钱包',
                                style: TextStyle(
                                  color: PublicData.color8DC2C3,
                                  fontSize: PublicData.textSize_11,
                                ),
                              ),
                            ],
                          ),
                          Image.asset(
                            "assets/browse/browse_right.png",
                            width: 5.w,
                            height: 8.h,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 27.h,
                  ),
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
            ),
          ),
        ],
      ),
    );
  }
}
