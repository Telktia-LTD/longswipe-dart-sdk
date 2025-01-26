import 'package:flutter/material.dart';
import 'package:longswipe/longswipe.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Checkout Flow',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Dynamic Checkout Flow'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Welcome to the Checkout Example with Longswipe',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Use the form below to complete the checkout process by entering the voucher code.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            DynamicCheckoutForm(
              onVoucherSubmit: (voucherCode) async {
                // An example to verify the voucher code
                // This can be useful to check if the voucher is valid
                // before proceeding with the payment
                // Or to show them a preview of the voucher details
                // And possibly a section to enter the lockpin if required
                await verifyVoucher(voucherCode);
              },
              onButtonPressed: () async {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Button pressed!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            PayWithLongswipe(
              baseUrl: fetchBaseUrl(),
              apiKey: fetchApiKey(),
              buttonColor: Colors.deepPurple,
              showLockpin:
                  false, // Show the lockpin field for the user if the voucher requires it
              onLongswipeSubmit: (code) async {
                var amount =
                    100.0; // You can prefill this amount based on the value you want to charge
                await redeemVoucher(code, amount);
              },
            ),
          ],
        ),
      ),
    );
  }

  String fetchBaseUrl() {
    return Constants.productionBaseUrl;
  }

  String fetchApiKey() {
    return "YOUR PUBLIC API KEY";
  }

  Future<SuccessResponse> redeemVoucher(
    String voucherCode,
    double amount,
  ) async {
    try {
      // Using the production base Url
      var baseUrl = Constants.productionBaseUrl;
      // var baseUrl = Constants.sandboxBaseUrl;
      var apiKey = "YOUR PUBLIC API KEY";
      // Using the public API key
      var client = LongSwipeClient(baseUrl: baseUrl, apiKey: apiKey);
      var response =
          await client.redeemVoucher(voucher: voucherCode, amount: amount);
      print(response);
      return response;
    } catch (error) {
      print(error);
      throw Exception('Failed to redeem voucher');
    }
  }

  Future<VoucherResponse> verifyVoucher(String code) async {
    try {
      // Using the production base Url
      var baseUrl = Constants.productionBaseUrl;
      // var baseUrl = Constants.sandboxBaseUrl;
      var apiKey = "YOUR PUBLIC API KEY";
      // Using the public API key
      var client = LongSwipeClient(baseUrl: baseUrl, apiKey: apiKey);
      var response = await client.verifyVoucher(voucherCode: code);
      print(response);
      return response;
    } catch (error) {
      print(error);
      throw Exception('Failed to verify voucher');
    }
  }

  Future<VoucherRedemptionCharges> fetchRedemptionCharges(
    String voucherCode,
    double amount,
  ) {
    try {
      // Using the production base Url
      var baseUrl = Constants.productionBaseUrl;
      var apiKey = "YOUR PUBLIC API KEY";
      var client = LongSwipeClient(baseUrl: baseUrl, apiKey: apiKey);

      // // You can pass query parameters to the endpoint
      // var queryParameters = {
      //   'page': 2,
      //   'limit': 10,
      //   'search': 'email|name', // Optional search query
      // };

      var response = client.getRedemptionCharges(
        voucher: voucherCode,
        amount: amount,
      );

      return response;
    } catch (e) {
      throw Exception('Failed to fetch redemption charges');
    }
  }

  Future<Invoices> fetchInvoices(
    String voucherCode,
    double amount,
  ) {
    try {
      // Using the production base Url
      var baseUrl = Constants.productionBaseUrl;
      var apiKey = "YOUR PUBLIC API KEY";
      var client = LongSwipeClient(baseUrl: baseUrl, apiKey: apiKey);

      // You can pass query parameters to the endpoint
      var queryParameters = {
        'page': 2,
        'limit': 10,
        'search': 'email|name', // Optional search query
      };

      var response = client.fetchInvoices(queryParameters: queryParameters);

      return response;
    } catch (e) {
      throw Exception('Failed to fetch redemption charges');
    }
  }
}
