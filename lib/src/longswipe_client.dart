import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/voucher_response.dart';

class LongSwipeClient {
  final String baseUrl;
  final String apiKey;

  LongSwipeClient({required this.baseUrl, required this.apiKey});

  Future<VoucherResponse> verifyVoucher(String voucherCode) async {
    final url = Uri.parse('$baseUrl/vouchers/details');
    final headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({"voucherCode": voucherCode});

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      return VoucherResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          'Failed to fetch voucher details: ${response.statusCode} ${response.body}');
    }
  }

  Future<http.Response> _get(String endpoint) async {
    final url = Uri.parse('\$baseUrl/\$endpoint');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer \$apiKey',
      'Content-Type': 'application/json',
    });

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch data: \${response.body}');
    }

    return response;
  }

  Future<Map<String, dynamic>> fetchData(String endpoint) async {
    final response = await _get(endpoint);
    return json.decode(response.body) as Map<String, dynamic>;
  }

  Future<void> postData(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('\$baseUrl/\$endpoint');
    final response = await http.post(url,
        headers: {
          'Authorization': 'Bearer \$apiKey',
          'Content-Type': 'application/json',
        },
        body: json.encode(data));

    if (response.statusCode != 200) {
      throw Exception('Failed to post data: \${response.body}');
    }
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
