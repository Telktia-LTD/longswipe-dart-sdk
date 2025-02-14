// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'redeem_voucher_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RedeemVoucherResponse _$RedeemVoucherResponseFromJson(
        Map<String, dynamic> json) =>
    RedeemVoucherResponse(
      code: (json['code'] as num).toInt(),
      message: json['message'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$RedeemVoucherResponseToJson(
        RedeemVoucherResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'status': instance.status,
    };
