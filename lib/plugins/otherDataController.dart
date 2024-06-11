// ignore_for_file: file_names

import 'package:get/get.dart';
/// 乱七八糟的通用数据控制
/// 数据太杂太多，不值当为每个数据单独建立控制文件
class OtherDataController extends GetxController{
  /// 带有导航页面的选择下标
  final selectedHomeIndex = 0.obs;

  /// 设置带有导航页面的选择下标
  setHomeIndex(int index){
    selectedHomeIndex.value = index;
  }

}