import 'package:flutter/material.dart';

import '../../longswipe_payment.dart';

class VoucherDetailsBottomSheet extends StatelessWidget {
  final VoucherDetailsResponse details;
  final VoidCallback onProceed;
  final VoidCallback onCancel;

  const VoucherDetailsBottomSheet({
    Key? key,
    required this.details,
    required this.onProceed,
    required this.onCancel,
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
          _buildDetailRow('Amount', '${details.data?.charges.swapAmount ?? 0}'),
          _buildDetailRow('Balance', '${details.data?.voucher.balance ?? 0}'),
          _buildDetailRow(
              'Processing Fee', '${details.data?.charges.processingFee ?? 0}'),
          _buildDetailRow('Total Amount',
              '${details.data?.charges.totalGasAndProceesingFeeInFromCurrency ?? 0}'),
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
