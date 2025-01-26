import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:longswipe/longswipe.dart';

class LongSwipeClient {
  final String baseUrl;
  final String apiKey;

  LongSwipeClient({required this.baseUrl, required this.apiKey});

  Future<VoucherResponse> verifyVoucher({required String voucherCode}) async {
    final response = await postData('/merchant-integrations/details', {
      'voucherCode': voucherCode,
    });

    return VoucherResponse.fromJson(jsonDecode(response.body));
  }

  Future<SuccessResponse> redeemVoucher(
      {required String voucher, required double amount, lockpin}) async {
    final response = await postData('/merchant-integrations/redeem', {
      'voucher': voucher,
      'amount': amount,
      'lockpin': lockpin,
    });

    if (response.statusCode != 200) {
      throw Exception('Failed to redeem voucher: ${response.body}');
    }

    return SuccessResponse.fromJson(jsonDecode(response.body));
  }

  Future<VoucherRedemptionCharges> getRedemptionCharges(
      {required String voucher, required double amount, lockpin}) async {
    final response =
        await postData('/merchant-integrations/redemptionCharges', {
      'voucher': voucher,
      'amount': amount,
      'lockpin': lockpin,
    });

    if (response.statusCode != 200) {
      throw Exception('Failed to get redemption charges: ${response.body}');
    }

    return VoucherRedemptionCharges.fromJson(jsonDecode(response.body));
  }

  Future<Invoices> fetchInvoices(
      {Map<String, dynamic>? queryParameters}) async {
    final response = await getData('/merchant-integrations/fetch-invoices',
        queryParameters: queryParameters);

    if (response.statusCode != 200) {
      throw Exception('Failed to get redemption charges: ${response.body}');
    }

    return Invoices.fromJson(jsonDecode(response.body));
  }

  Future<SuccessResponse> generateInvoice(
      {required String voucher, required double amount, lockpin}) async {
    final response = await postData('/merchant-integrations/redeem', {
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

    return response;
  }

  Future<http.Response> getData(String endpoint,
      {Map<String, dynamic>? queryParameters}) async {
    final url = Uri.https(baseUrl, endpoint, queryParameters);
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
    );

    return response;
  }

  Future<http.Response> deleteData(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.delete(url, headers: {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    });

    if (response.statusCode != 200) {
      throw Exception('Failed to delete data: ${response.body}');
    }

    return response;
  }
}
