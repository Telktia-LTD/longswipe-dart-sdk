import 'package:flutter/material.dart';
import 'package:longswipe_payment/longswipe_payment.dart';

class BasicExample extends StatefulWidget {
  @override
  _BasicExampleState createState() => _BasicExampleState();
}

class _BasicExampleState extends State<BasicExample> {
  final client = LongswipeClient(
    apiKey: 'your-public-api-key',
    isSandbox: true,
  );

  final _voucherCodeController = TextEditingController();
  final _pinController = TextEditingController();
  final _amountController = TextEditingController();
  String walletAddress = 'your-wallet-id';
  bool _isLoading = false;

  Future<void> _verifyVoucher() async {
    if (_voucherCodeController.text.isEmpty || _amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final details = await client.fetchVoucherDetails(
        voucherCode: _voucherCodeController.text,
        lockPin: _pinController.text,
        amount: int.parse(_amountController.text),
        receivingCurrencyCode: CurrencyType.USDC.value,
        walletAddress: walletAddress,
      );

      if (!mounted) return;

      // Show bottom sheet with voucher details
      showModalBottomSheet(
        context: context,
        builder: (context) => VoucherDetailsSheet(
          details: details,
          onProceed: () {
            Navigator.pop(context);
            _processPayment();
          },
        ),
      );
    } on LongswipeException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.message}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _processPayment() async {
    setState(() => _isLoading = true);

    try {
      final result = await client.processVoucherPayment(
        voucherCode: _voucherCodeController.text,
        lockPin: _pinController.text,
        amount: int.parse(_amountController.text),
        receivingCurrencyCode: CurrencyType.USDC.value,
        walletAddress: walletAddress,
      );

      if (!mounted) return;

      if (result.status != 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${result.message}')),
        );
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment successful!')),
      );

      // Clear form after successful payment
      _voucherCodeController.clear();
      _pinController.clear();
      _amountController.clear();
    } on LongswipeException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.message}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Longswipe Payment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  TextField(
                    controller: _voucherCodeController,
                    decoration: const InputDecoration(
                      labelText: 'Voucher Code',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _amountController,
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _pinController,
                    decoration: const InputDecoration(
                      labelText: 'PIN (optional)',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _verifyVoucher,
                      child: const Text('Verify Voucher'),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  @override
  void dispose() {
    _voucherCodeController.dispose();
    _pinController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}

class VoucherDetailsSheet extends StatelessWidget {
  final VoucherChargesDetailsResponse details;
  final VoidCallback onProceed;

  const VoucherDetailsSheet({
    Key? key,
    required this.details,
    required this.onProceed,
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
          _buildDetailRowWithIcon(
              'Currency',
              details.data?.voucher.generatedCurrency!.name ?? '',
              details.data?.voucher.generatedCurrency!.image ?? ''),
          _buildDetailRow('Amount', '${details.data?.charges.swapAmount ?? 0}'),
          _buildDetailRow('Balance', '${details.data?.voucher.balance ?? 0}'),
          _buildDetailRow(
              'Processing Fee', '${details.data?.charges.processingFee}'),
          _buildDetailRow('Total Amount',
              '${details.data?.charges.totalGasAndProceesingFeeInFromCurrency ?? 0}'),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
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
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRowWithIcon(String label, String value, String imageIcon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Row(
            children: [
              Image.network(
                imageIcon,
                width: 24,
                height: 24,
              ),
              const SizedBox(width: 3),
              Text(
                value,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
