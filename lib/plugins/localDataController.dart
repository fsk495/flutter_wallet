// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
/// 本地缓存数据的控制类
class LocalDataController extends GetxController{
  final storage = GetStorage();

  /// 保存数据到本地缓存
  void saveData(String key,dynamic value)
  {
    storage.write(key, value);
  }
  /// 读取本地缓存的数据
  dynamic loadData(String key)
  {
    return storage.read(key);
  }
  /// 删除本地缓存的数据
  void removeData(String key)
  {
    storage.remove(key);
  }
  /// 清理本地缓存
  void cleanData()
  {
    storage.erase();
  }

}