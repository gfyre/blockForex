// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exchanges_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ExchangesResponse _$$_ExchangesResponseFromJson(Map<String, dynamic> json) =>
    _$_ExchangesResponse(
      result: (json['result'] as List<dynamic>)
          .map((e) => Exchange.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$_ExchangesResponseToJson(
        _$_ExchangesResponse instance) =>
    <String, dynamic>{
      'result': instance.result,
    };
