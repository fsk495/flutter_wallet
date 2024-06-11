// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class ShowDiaologController extends GetxController {
  void showSnackBar(String msg, String title,int time) {
    Logger().i("调用弹窗方法");
    Get.snackbar(
      title,
      msg,
      snackPosition: SnackPosition.TOP,
      // 位置
      margin: EdgeInsets.all(10.r),
      // 设置外边距
      padding: EdgeInsets.all(15.r),
      // 设置内边距
      borderRadius: 10,
      // 设置圆角
      duration: Duration(milliseconds: time * 1000),
      // 显示时间
      isDismissible: true,
      // 是否可以通过点击屏幕外部或按返回键来关闭 SnackBar
      backgroundColor: Colors.black,
      // 背景颜色
      colorText: Colors.white,
      // 文本颜色
      snackStyle: SnackStyle.FLOATING,
      // 设置 SnackBar 的样式为浮动
      titleText: Center(
          child: Text(
        title,
        style: const TextStyle(color: Colors.white),
      )),
      // 设置标题文本居中
      messageText: Center(
          child: Text(
        msg,
        style: const TextStyle(color: Colors.white),
      )),
    );
  }

  void showAlertDialog(String title, String msg,{
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    Get.defaultDialog(
      title: title,
      middleText: msg,
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () {
                Get.back(); // 关闭对话框
                // 执行确定按钮的逻辑
                logger.i('Confirm Button Pressed');
                if(onConfirm!=null)
                {
                  onConfirm();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // 设置按钮背景色
              ),
              child: const Text('Confirm'),
            ),
            ElevatedButton(
              onPressed: () {
                Get.back(); // 关闭对话框
                // 执行取消按钮的逻辑
                if(onCancel!=null)
                {
                  onCancel();
                }
                logger.i('Cancel Button Pressed');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // 设置按钮背景色
              ),
              child: const Text('Cancel'),
            ),
          ],
        )
      ],
    );
  }
}
