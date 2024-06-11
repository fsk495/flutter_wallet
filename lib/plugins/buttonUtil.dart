// ignore_for_file: file_names, camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wallet/plugins/publicData.dart';

/// 公共的按钮  文字在左 图标在右
class PublicButtonTextAndIcon extends StatelessWidget {
  /// 按钮名字
  final String title;

  /// 图标的本地地址
  final String? imageUrl;

  /// 图标的系统图标数据
  final IconData? icon;

  /// 点击的回调事件
  final VoidCallback onPressed;

  /// 是否使用系统图标
  final bool isUseIcon;

  final Color textColor;

  final double fontSize;

  const PublicButtonTextAndIcon({
    super.key,
    required this.title,
    this.imageUrl,
    this.icon,
    required this.onPressed,
    required this.isUseIcon,
    this.textColor = PublicData.color4DA7A9,
    this.fontSize = 14,
  }) : assert(
            (imageUrl != null && icon == null) ||
                (imageUrl == null && icon != null),
            'Only one of imageUrl or icon can be provided.');

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      label: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: fontSize,
              color: textColor,
            ),
          ),
          SizedBox(
            width: 5.w,
          ),
          isUseIcon ? Icon(icon) : Image.asset(imageUrl!),
        ],
      ),
      icon: const SizedBox(),
      style: ButtonStyle(
        // 按钮内边距
        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
      ),
    );
  }
}

/// 单选按钮
class SetSingleChoiceButton extends StatelessWidget {
  final String name;

  final Color chooseTextColor;

  final Color unChooseTextColor;

  final Color chooseUnderlineColor;

  final Color unChooseUnderlineColor;

  final VoidCallback onTap;

  final double fontSize;

  final bool checked;

  const SetSingleChoiceButton({
    super.key,
    required this.name,
    this.chooseTextColor = Colors.black,
    this.unChooseTextColor = PublicData.color4DA7A9,
    this.chooseUnderlineColor = Colors.black,
    this.unChooseUnderlineColor = Colors.transparent,
    this.fontSize = 14,
    required this.onTap,
    required this.checked,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: checked ? chooseUnderlineColor : unChooseUnderlineColor,
              width: 1.0,
            ),
          ),
        ),
        child: Text(
          name,
          style: TextStyle(
            color: checked ? chooseTextColor : unChooseTextColor,
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}