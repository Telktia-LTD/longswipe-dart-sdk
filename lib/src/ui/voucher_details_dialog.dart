import 'package:flutter/material.dart';

import '../../longswipe_payment.dart';
import '../common/longswipe_theme.dart';

class VoucherDetailsDialog extends StatefulWidget {
  const VoucherDetailsDialog({
    super.key,
    required this.details,
    required this.client,
    required this.voucherCode,
    required this.amount,
    required this.currencyCode,
    required this.walletAddress,
    this.theme,
  });

  final VoucherDetailsData details;
  final LongswipeClient client;
  final String voucherCode;
  final int amount;
  final String currencyCode;
  final String walletAddress;
  final LongswipeTheme? theme;

  @override
  State<VoucherDetailsDialog> createState() => _VoucherDetailsDialogState();
}

class _VoucherDetailsDialogState extends State<VoucherDetailsDialog> {
  final TextEditingController _lockPinController = TextEditingController();
  PaymentStatus _status = PaymentStatus.pending;
  String _message = '';
  bool _isProcessing = false;

  @override
  void dispose() {
    _lockPinController.dispose();
    super.dispose();
  }

  Future<void> _processPayment() async {
    if (_isProcessing) return;

    setState(() => _isProcessing = true);

    try {
      final response = await widget.client.processVoucherPayment(
        voucherCode: widget.voucherCode,
        amount: widget.amount,
        receivingCurrencyCode: widget.currencyCode,
        lockPin: _lockPinController.text,
        walletAddress: widget.walletAddress,
      );

      setState(() {
        _status = response.status == 'success'
            ? PaymentStatus.success
            : PaymentStatus.failed;
        _message = response.message;
      });
    } catch (e) {
      setState(() {
        _status = PaymentStatus.failed;
        _message = e.toString();
      });
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme ?? LongswipeTheme.defaultTheme;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 300,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: theme.contentPadding,
        decoration: BoxDecoration(
          color: theme.backgroundColor,
          borderRadius: BorderRadius.circular(theme.borderRadius),
        ),
        child: SingleChildScrollView(
          child: _status.isPending
              ? _buildPaymentDetails(theme)
              : _buildPaymentStatus(theme),
        ),
      ),
    );
  }

  Widget _buildPaymentDetails(LongswipeTheme theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeader(theme),
        const SizedBox(height: 16),
        _buildDetailsContent(theme),
        if (widget.details.voucher.isLocked == true) ...[
          const SizedBox(height: 16),
          _buildLockPinInput(theme),
        ],
        const SizedBox(height: 16),
        _buildActionButtons(theme),
      ],
    );
  }

  Widget _buildHeader(LongswipeTheme theme) {
    return Column(
      children: [
        Text('Voucher Details', style: theme.titleStyle),
        const SizedBox(height: 8),
        Text(
          'Review voucher details and confirm redemption',
          style: theme.labelStyle,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDetailsContent(LongswipeTheme theme) {
    final currency = widget.details.voucher.generatedCurrency;
    final symbol = currency?.symbol ?? '';

    return Column(
      children: [
        DetailRow(
          label: 'Code:',
          value: widget.details.voucher.code ?? '',
          theme: theme,
        ),
        const SizedBox(height: 8),
        DetailRow(
          label: 'Balance:',
          value: '$symbol ${widget.details.voucher.balance}',
          theme: theme,
        ),
        const SizedBox(height: 8),
        DetailRow(
          label: 'Amount:',
          value: '$symbol ${widget.amount}',
          theme: theme,
        ),
        const SizedBox(height: 8),
        DetailRow(
          label: 'Charges:',
          value:
              '$symbol ${widget.details.charges.totalGasAndProceesingFeeInFromCurrency}',
          theme: theme,
        ),
      ],
    );
  }

  Widget _buildLockPinInput(LongswipeTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enter your lock pin',
          style: theme.labelStyle,
        ),
        const SizedBox(height: 4),
        TextField(
          style: theme.inputTextStyle,
          controller: _lockPinController,
          decoration: theme.lockPinInputDecoration,
          obscureText: true,
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  Widget _buildActionButtons(LongswipeTheme theme) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: theme.secondaryButtonStyle,
            child: Text('Cancel', style: theme.cancelButtonTextStyle),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: _isProcessing ? null : _processPayment,
            style: theme.primaryButtonStyle,
            child: _isProcessing
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text('Proceed', style: theme.buttonTextStyle),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentStatus(LongswipeTheme theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        Icon(
          _status.isSuccess ? Icons.check_circle : Icons.error,
          color: _status.isSuccess ? Colors.green : Colors.red,
          size: 64,
        ),
        const SizedBox(height: 16),
        Text(
          _message,
          style: theme.titleStyle,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

enum PaymentStatus {
  pending,
  success,
  failed;

  bool get isPending => this == PaymentStatus.pending;
  bool get isSuccess => this == PaymentStatus.success;
  bool get isFailed => this == PaymentStatus.failed;
}

class DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final LongswipeTheme theme;

  const DetailRow({
    required this.label,
    required this.value,
    required this.theme,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: theme.dialogContentTextStyle,
        ),
        Expanded(
          child: Text(
            value,
            style: theme.dialogContentTextStyle,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
