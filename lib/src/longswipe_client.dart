import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:longswipe_payment/src/models/redeem_voucher_response.dart';
import 'package:longswipe_payment/src/models/voucher_details_response.dart';
import 'models/voucher_charges_details_response.dart';
import 'longswipe_exception.dart';

class LongswipeClient {
  final String apiKey;
  final bool isSandbox;
  final String baseUrl;

  LongswipeClient({
    required this.apiKey,
    this.isSandbox = false,
  }) : baseUrl = isSandbox
            ? 'https://sandbox.longswipe.com'
            : 'https://api.longswipe.com';

  Map<String, String> get _headers => {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  Future<VoucherChargesDetailsResponse> fetchVoucherDetails({
    required String voucherCode,
    required int amount,
    required String receivingCurrencyCode,
    String lockPin = "",
    String walletAddress = "",
  }) async {
    try {
      log('URL... $baseUrl/merchant-integrations/fetch-voucher-redemption-charges');
      log('Body... ${jsonEncode({
            "amount": amount,
            "lockPin": lockPin,
            "toCurrencyAbbreviation": receivingCurrencyCode,
            "voucherCode": voucherCode,
            "walletAddress": walletAddress
          })}');

      final response = await http.post(
        Uri.parse(
            '$baseUrl/merchant-integrations/fetch-voucher-redemption-charges'),
        headers: _headers,
        body: jsonEncode({
          "amount": amount,
          "lockPin": lockPin,
          "toCurrencyAbbreviation": receivingCurrencyCode,
          "voucherCode": voucherCode,
          "walletAddress": walletAddress
        }),
      );

      if (response.statusCode != 200) {
        throw LongswipeException(
          message: jsonDecode(response.body)['message'],
          code: response.statusCode,
          data: jsonDecode(response.body),
        );
      }

      return VoucherChargesDetailsResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      log("Error... $e");
      if (e is LongswipeException) rethrow;
      throw LongswipeException(message: e.toString());
    }
  }

  Future<VoucherDetailsResponse> verifyVoucher({
    required String voucherCode,
  }) async {
    try {
      log('URL... $baseUrl/merchant-integrations/verify-voucher');
      log('Body... ${jsonEncode({
            "voucherCode": voucherCode,
          })}');

      final response = await http.post(
        Uri.parse('$baseUrl/merchant-integrations/verify-voucher'),
        headers: _headers,
        body: jsonEncode({
          "voucherCode": voucherCode,
        }),
      );

      if (response.statusCode != 200) {
        throw LongswipeException(
          message: jsonDecode(response.body)['message'],
          code: response.statusCode,
          data: jsonDecode(response.body),
        );
      }

      return VoucherDetailsResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      if (e is LongswipeException) rethrow;
      throw LongswipeException(message: e.toString());
    }
  }

  Future<RedeemVoucherResponse> processVoucherPayment({
    required String voucherCode,
    required int amount,
    required String receivingCurrencyCode,
    String lockPin = "",
    String walletAddress = "",
  }) async {
    try {
      log('URL... $baseUrl/merchant-integrations/redeem-voucher');
      log('Body... ${jsonEncode({
            "amount": amount,
            "lockPin": lockPin,
            "toCurrencyAbbreviation": receivingCurrencyCode,
            "voucherCode": voucherCode,
            "walletAddress": walletAddress
          })}');

      final response = await http.post(
        Uri.parse('$baseUrl/merchant-integrations/redeem-voucher'),
        headers: _headers,
        body: jsonEncode({
          "amount": amount,
          "lockPin": lockPin,
          "toCurrencyAbbreviation": receivingCurrencyCode,
          "voucherCode": voucherCode,
          "walletAddress": walletAddress
        }),
      );

      if (response.statusCode != 200) {
        throw LongswipeException(
          message: jsonDecode(response.body)['message'],
          code: response.statusCode,
          data: jsonDecode(response.body),
        );
      }

      return RedeemVoucherResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      log('ResponseCATCH... ${e.toString()}');
      if (e is LongswipeException) rethrow;
      throw LongswipeException(message: e.toString());
    }
  }
}
