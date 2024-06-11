// ignore_for_file: camel_case_types, file_names

import 'package:json_annotation/json_annotation.dart';
part 'browseInputUrlItem.g.dart';

@JsonSerializable()
class BrowseInputUrlItem {
  final String url;
  final String name;
  final String imageUrl;

  BrowseInputUrlItem({
    required this.url,
    required this.name,
    required this.imageUrl,
  });

 // 添加工厂方法用于从 json 反序列化
  factory BrowseInputUrlItem.fromJson(Map<String, dynamic> json) => _$BrowseInputUrlItemFromJson(json);

  // 添加 toJson 方法用于序列化到 json
  Map<String, dynamic> toJson() => _$BrowseInputUrlItemToJson(this);
}