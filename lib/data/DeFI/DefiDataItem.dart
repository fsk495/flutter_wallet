// ignore_for_file: file_names, non_constant_identifier_names
import 'package:json_annotation/json_annotation.dart';
part 'DefiDataItem.g.dart';

@JsonSerializable()
class DefiDataItem {
  final String id;
  final String symbol;
  final String name;
  final String image;
  final dynamic current_price;
  final double market_cap;
  final double market_cap_rank;
  final double fully_diluted_valuation;
  final double total_volume;
  final double high_24h;
  final double low_24h;
  final double price_change_24h;
  final double price_change_percentage_24h;
  final double market_cap_change_24h;
  final double market_cap_change_percentage_24h;
  final double circulating_supply;
  final double total_supply;
  final dynamic max_supply;
  final double ath;
  final double ath_change_percentage;
  final String ath_date;
  final double atl;
  final double atl_change_percentage;
  final String atl_date;
  final dynamic roi;
  final String last_updated;

  DefiDataItem({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.current_price,
    required this.market_cap,
    required this.market_cap_rank,
    required this.fully_diluted_valuation,
    required this.total_volume,
    required this.high_24h,
    required this.low_24h,
    required this.price_change_24h,
    required this.price_change_percentage_24h,
    required this.market_cap_change_24h,
    required this.market_cap_change_percentage_24h,
    required this.circulating_supply,
    required this.total_supply,
    required this.max_supply,
    required this.ath,
    required this.ath_change_percentage,
    required this.ath_date,
    required this.atl,
    required this.atl_change_percentage,
    required this.atl_date,
    required this.roi,
    required this.last_updated,
  });

  // 添加工厂方法用于从 json 反序列化
  factory DefiDataItem.fromJson(Map<String, dynamic> json) => _$DefiDataItemFromJson(json);

  // 添加 toJson 方法用于序列化到 json
  Map<String, dynamic> toJson() => _$DefiDataItemToJson(this);
}
