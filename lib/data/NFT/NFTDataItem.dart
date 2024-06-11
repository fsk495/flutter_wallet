// ignore_for_file: file_names, non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
part "NFTDataItem.g.dart";

@JsonSerializable()
class NFTDataItem {
  final String id;
  final String contract_address;
  final String name;
  final String asset_platform_id;
  final String symbol;
  final String image;

  NFTDataItem({
    required this.id,
    required this.contract_address,
    required this.name,
    required this.asset_platform_id,
    required this.symbol,
    required this.image,
  });

  // 添加工厂方法用于从 json 反序列化
  factory NFTDataItem.fromJson(Map<String, dynamic> json) => _$NFTDataItemFromJson(json);

  // 添加 toJson 方法用于序列化到 json
  Map<String, dynamic> toJson() => _$NFTDataItemToJson(this);
}
