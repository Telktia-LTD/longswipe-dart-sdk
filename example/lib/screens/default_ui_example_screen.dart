import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:longswipe_payment/longswipe_payment.dart';

class DefaultUIExample extends StatelessWidget {
  const DefaultUIExample({super.key});

  static const walletAddress = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Default UI Example')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: LongswipePaymentWidget(
          client: LongswipeClient(
            apiKey: 'pk_test_up6n93crC-JqzYRirGyFMHX4yMJr2V5tnjvcRyVrGAI=',
            isSandbox: false,
          ),
          useBottomSheet: true,
          voucherDetailsConfig: const VoucherDetailsConfig(
            showAmount: true,
            showBalance: true,
            showProcessingFee: true,
            showTotalAmount: true,
            showExchangeRate: true,
            showFromCurrency: true,
            showToCurrency: true,
            showPercentageCharge: true,
          ),
          toCurrencyAbbreviation: CurrencyType.USDC.value,
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
