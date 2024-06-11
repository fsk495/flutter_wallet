// ignore_for_file: file_names, non_constant_identifier_names
import 'package:json_annotation/json_annotation.dart';
part "CoinGeckoDataItem.g.dart";

@JsonSerializable()
class CoinGeckoDataItem {
  final String id;
  final String symbol;
  final String name;
  final String image;
  final String web_slug;
  final dynamic asset_platform_id;
  final Map<String,String> platforms;
  final Map<String, Map<String, dynamic>> detail_platforms;
  final int block_time_in_minutes;
  final dynamic hashing_algorithm;
  final List<String> categories;
  final Map<String,String> localization;
  final Map<String,String> description;
  final dynamic genesis_date;
  final int market_cap_rank;
  final String last_updated;
  final List<String> rpcs;

  bool isDefault;
  bool isClick;

  CoinGeckoDataItem({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.web_slug,
    required this.asset_platform_id,
    required this.platforms,
    required this.detail_platforms,
    required this.block_time_in_minutes,
    required this.hashing_algorithm,
    required this.categories,
    required this.localization,
    required this.description,
    required this.genesis_date,
    required this.market_cap_rank,
    required this.last_updated,
    required this.rpcs,
    this.isDefault = false,
    this.isClick = false,
  });

  // 添加工厂方法用于从 json 反序列化
  factory CoinGeckoDataItem.fromJson(Map<String, dynamic> json) => _$CoinGeckoDataItemFromJson(json);

  // 添加 toJson 方法用于序列化到 json
  Map<String, dynamic> toJson() => _$CoinGeckoDataItemToJson(this);
}