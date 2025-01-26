import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:longswipe/longswipe.dart';
import 'models/voucher_response.dart';

class LongSwipeClient {
  final String baseUrl;
  final String apiKey;

  LongSwipeClient({required this.baseUrl, required this.apiKey});

  Future<VoucherResponse> verifyVoucher(String voucherCode) async {
    final response = await postData('vouchers/details', {
      'voucherCode': voucherCode,
    });

    return VoucherResponse.fromJson(jsonDecode(response.body));
  }

  Future<SuccessResponse> redeemVoucher(
      {required String voucher, required double amount, lockpin}) async {
    final response = await postData('vouchers/redeem', {
      'voucher': voucher,
      'amount': amount,
      'lockpin': lockpin,
    });

    if (response.statusCode != 200) {
      throw Exception('Failed to redeem voucher: ${response.body}');
    }

    return SuccessResponse.fromJson(jsonDecode(response.body));
  }

  Future<http.Response> postData(
      String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.post(url,
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: json.encode(data));

    if (response.statusCode != 200) {
      throw Exception('Failed to post data: ${response.body}');
    }

    return response;
  }

  Future<void> deleteData(String endpoint) async {
    final url = Uri.parse('\$baseUrl/\$endpoint');
    final response = await http.delete(url, headers: {
      'Authorization': 'Bearer \$apiKey',
      'Content-Type': 'application/json',
    });

    if (response.statusCode != 200) {
      throw Exception('Failed to delete data: \${response.body}');
    }
    return;
  }
}
