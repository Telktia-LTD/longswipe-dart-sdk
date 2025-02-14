import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:longswipe_payment/longswipe_payment.dart';

class DefaultUIExample extends StatelessWidget {
  const DefaultUIExample({super.key});

  static const receivingCurrencyId = 'currency-id';
  static const walletAddress = 'your-wallet-address';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Default UI Example')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: LongswipePaymentWidget(
          client: LongswipeClient(
            apiKey: 'your-public-api-key',
            isSandbox: false,
          ),
          useBottomSheet: true,
          receivingCurrencyId: receivingCurrencyId,
          walletAddress: walletAddress,
          onSuccess: (result) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Payment successful!')),
            );
          },
          onSuccessFetchVoucherDetails: (result) {
            log(result.toJson().toString());
          },
          onError: (error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${error.message}')),
            );
          },
        ),
      ),
    );
  }
}
