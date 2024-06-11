// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'NFTDataItem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NFTDataItem _$NFTDataItemFromJson(Map<String, dynamic> json) => NFTDataItem(
      id: json['id'] as String,
      contract_address: json['contract_address'] as String,
      name: json['name'] as String,
      asset_platform_id: json['asset_platform_id'] as String,
      symbol: json['symbol'] as String,
      image: json['image'] as String,
    );

Map<String, dynamic> _$NFTDataItemToJson(NFTDataItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'contract_address': instance.contract_address,
      'name': instance.name,
      'asset_platform_id': instance.asset_platform_id,
      'symbol': instance.symbol,
      'image': instance.image,
    };
