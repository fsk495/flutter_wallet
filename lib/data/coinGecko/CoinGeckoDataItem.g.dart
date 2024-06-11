// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CoinGeckoDataItem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoinGeckoDataItem _$CoinGeckoDataItemFromJson(Map<String, dynamic> json) =>
    CoinGeckoDataItem(
      id: json['id'] as String,
      symbol: json['symbol'] as String,
      name: json['name'] as String,
      image: json['image'] as String,
      web_slug: json['web_slug'] as String,
      asset_platform_id: json['asset_platform_id'],
      platforms: Map<String, String>.from(json['platforms'] as Map),
      detail_platforms: (json['detail_platforms'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, e as Map<String, dynamic>),
      ),
      block_time_in_minutes: (json['block_time_in_minutes'] as num).toInt(),
      hashing_algorithm: json['hashing_algorithm'],
      categories: (json['categories'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      localization: Map<String, String>.from(json['localization'] as Map),
      description: Map<String, String>.from(json['description'] as Map),
      genesis_date: json['genesis_date'],
      market_cap_rank: (json['market_cap_rank'] as num).toInt(),
      last_updated: json['last_updated'] as String,
      rpcs: (json['rpcs'] as List<dynamic>).map((e) => e as String).toList(),
      isDefault: json['isDefault'] as bool? ?? false,
      isClick: json['isClick'] as bool? ?? false,
    );

Map<String, dynamic> _$CoinGeckoDataItemToJson(CoinGeckoDataItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'symbol': instance.symbol,
      'name': instance.name,
      'image': instance.image,
      'web_slug': instance.web_slug,
      'asset_platform_id': instance.asset_platform_id,
      'platforms': instance.platforms,
      'detail_platforms': instance.detail_platforms,
      'block_time_in_minutes': instance.block_time_in_minutes,
      'hashing_algorithm': instance.hashing_algorithm,
      'categories': instance.categories,
      'localization': instance.localization,
      'description': instance.description,
      'genesis_date': instance.genesis_date,
      'market_cap_rank': instance.market_cap_rank,
      'last_updated': instance.last_updated,
      'rpcs': instance.rpcs,
      'isDefault': instance.isDefault,
      'isClick': instance.isClick,
    };
