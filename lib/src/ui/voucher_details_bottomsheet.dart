import 'package:flutter/material.dart';

import '../../longswipe_payment.dart';

class VoucherDetailsBottomSheet extends StatelessWidget {
  final VoucherDetailsResponse details;
  final VoidCallback onProceed;
  final VoidCallback onCancel;
  final VoucherDetailsConfig config;

  const VoucherDetailsBottomSheet({
    Key? key,
    required this.details,
    required this.onProceed,
    required this.onCancel,
    this.config = const VoucherDetailsConfig(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Voucher Details',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          if (config.showAmount)
            _buildDetailRow(
                'Amount', '${details.data?.charges.swapAmount ?? 0}'),
          if (config.showBalance)
            _buildDetailRow('Balance', '${details.data?.voucher.balance ?? 0}'),
          if (config.showProcessingFee)
            _buildDetailRow('Processing Fee',
                '${details.data?.charges.processingFee ?? 0}'),
          if (config.showTotalAmount)
            _buildDetailRow('Total Amount',
                '${details.data?.charges.totalGasAndProceesingFeeInFromCurrency ?? 0}'),
          if (config.showExchangeRate)
            _buildDetailRow(
                'Exchange Rate', '${details.data?.charges.exchangeRate ?? 0}'),
          if (config.showFromCurrency)
            _buildDetailRow('From Currency',
                '${details.data?.charges.fromCurrency.name ?? ""}'),
          if (config.showToCurrency)
            _buildDetailRow('To Currency',
                '${details.data?.charges.toCurrency.name ?? ""}'),
          if (config.showPercentageCharge)
            _buildDetailRow('Percentage Charge',
                '${details.data?.charges.percentageCharge ?? 0}%'),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onCancel,
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: onProceed,
                  child: const Text('Proceed'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class VoucherDetailsConfig {
  final bool showAmount;
  final bool showBalance;
  final bool showProcessingFee;
  final bool showTotalAmount;
  final bool showExchangeRate;
  final bool showFromCurrency;
  final bool showToCurrency;
  final bool showPercentageCharge;

  const VoucherDetailsConfig({
    this.showAmount = true,
    this.showBalance = true,
    this.showProcessingFee = true,
    this.showTotalAmount = true,
    this.showExchangeRate = false,
    this.showFromCurrency = false,
    this.showToCurrency = false,
    this.showPercentageCharge = false,
  });
}
