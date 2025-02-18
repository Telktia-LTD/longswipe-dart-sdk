import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:longswipe_payment/longswipe_payment.dart';

import '../shared_widgets/custom_button.dart';
import '../shared_widgets/custom_input.dart';
import '../shared_widgets/custom_loading_indicator.dart';

class CustomUIExample extends StatelessWidget {
  const CustomUIExample({super.key});

  static const walletAddress = 'your-wallet-address';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom UI Example')),
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
          voucherCodeBuilder: (context, controller) {
            return CustomInput(
              controller: controller,
              label: 'Voucher Code',
              icon: Icons.confirmation_number,
            );
          },
          voucherPinBuilder: (context, controller) {
            return CustomInput(
              controller: controller,
              label: 'Lock PIN (Optional)',
              icon: Icons.lock,
              obscureText: true,
            );
          },
          amountBuilder: (context, controller) {
            return CustomInput(
              controller: controller,
              label: 'Amount',
              icon: Icons.attach_money,
              keyboardType: TextInputType.number,
            );
          },
          submitButtonBuilder: (context, onSubmit) {
            return CustomButton(
              onPressed: onSubmit,
              label: 'Complete Payment',
            );
          },
          loadingWidget: const CustomLoadingIndicator(),
          onSuccessFetchVoucherDetails: (result) {
            log(result.toJson().toString());
          },
          onSuccess: (result) {
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
