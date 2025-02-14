import 'package:json_annotation/json_annotation.dart';

part 'redeem_voucher_response.g.dart';

@JsonSerializable()
class RedeemVoucherResponse {
  final int code;
  final String message;
  final String status;

  RedeemVoucherResponse({
    required this.code,
    required this.message,
    required this.status,
  });

  factory RedeemVoucherResponse.fromJson(Map<String, dynamic> json) =>
      _$RedeemVoucherResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RedeemVoucherResponseToJson(this);
}
