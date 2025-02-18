import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:longswipe_payment/longswipe_payment.dart';

class CustomThemeExample extends StatelessWidget {
  const CustomThemeExample({super.key});

  static const walletAddress = 'your-wallet-address';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom Theme Example')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: LongswipePaymentWidget(
          client: LongswipeClient(
            apiKey: 'public-key',
            isSandbox: true,
          ),
          toCurrencyAbbreviation: CurrencyType.USDC.value,
          walletAddress: walletAddress,
          useBottomSheet: true,
          voucherDetailsConfig: const VoucherDetailsConfig(
            showAmount: true,
            showBalance: true,
            showProcessingFee: false,
            showTotalAmount: true,
            showExchangeRate: true,
            showFromCurrency: true,
            showToCurrency: true,
            showPercentageCharge: false,
          ),
          theme: LongswipeTheme(
            paymentButtonStyle: PaymentButtonStyle(
              backgroundColor: Theme.of(context).colorScheme.primary,
              height: 56,
              borderRadius: 28,
              textStyle: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            inputFieldStyle: InputFieldStyle(
              borderRadius: 12,
              textStyle: GoogleFonts.inter(),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          onSuccessFetchVoucherDetails: (result) {
            log(result.toJson().toString());
          },
          onSuccess: (result) {
            log(result.toJson().toString());
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Payment successful!')),
            );
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
