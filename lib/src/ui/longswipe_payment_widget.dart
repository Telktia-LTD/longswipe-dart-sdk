import 'package:flutter/material.dart';
import 'package:longswipe_payment/longswipe_payment.dart';

import 'longswipe_theme.dart';
import 'voucher_details_bottomsheet.dart';

class LongswipePaymentWidget extends StatefulWidget {
  final LongswipeClient client;
  final LongswipeTheme theme;
  final Function(VoucherDetailsResponse result) onSuccessFetchVoucherDetails;
  final Function(RedeemVoucherResponse result) onSuccess;
  final Function(LongswipeException error) onError;
  final Widget? loadingWidget;
  final Widget Function(BuildContext, TextEditingController)?
      voucherCodeBuilder;
  final Widget Function(BuildContext, TextEditingController)? voucherPinBuilder;
  final Widget Function(BuildContext, TextEditingController)? amountBuilder;
  final Widget Function(BuildContext, VoidCallback)? submitButtonBuilder;
  final bool useBottomSheet;
  final String receivingCurrencyId;
  final String walletAddress;

  const LongswipePaymentWidget({
    Key? key,
    required this.client,
    this.theme = const LongswipeTheme(),
    required this.onSuccess,
    required this.onSuccessFetchVoucherDetails,
    required this.onError,
    required this.receivingCurrencyId,
    required this.walletAddress,
    this.loadingWidget,
    this.voucherCodeBuilder,
    this.voucherPinBuilder,
    this.amountBuilder,
    this.submitButtonBuilder,
    this.useBottomSheet = true,
  }) : super(key: key);

  @override
  _LongswipePaymentWidgetState createState() => _LongswipePaymentWidgetState();
}

class _LongswipePaymentWidgetState extends State<LongswipePaymentWidget> {
  final _voucherCodeController = TextEditingController();
  final _lockPinController = TextEditingController();
  final _amountController = TextEditingController();
  bool _isLoading = false;

  VoucherDetailsResponse? _voucherDetails;

  Future<void> _fetchVoucherDetails() async {
    if (_voucherCodeController.text.isEmpty || _amountController.text.isEmpty) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final amount = int.parse(_amountController.text);
      final details = await widget.client.fetchVoucherDetails(
        voucherCode: _voucherCodeController.text,
        lockPin: _lockPinController.text,
        amount: amount,
        receivingCurrencyId: widget.receivingCurrencyId,
        walletAddress: widget.walletAddress,
      );

      setState(() => _voucherDetails = details);
      _showVoucherDetails();
    } on LongswipeException catch (e) {
      widget.onError(e);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showVoucherDetails() {
    if (_voucherDetails == null) return;

    if (widget.useBottomSheet) {
      showModalBottomSheet(
        context: context,
        builder: (context) => VoucherDetailsBottomSheet(
          details: _voucherDetails!,
          onProceed: () {
            Navigator.pop(context);
            _processPayment();
          },
          onCancel: () => Navigator.pop(context),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Voucher Details'),
          content: VoucherDetailsBottomSheet(
            details: _voucherDetails!,
            onProceed: () {
              _processPayment();
              Navigator.pop(context);
            },
            onCancel: () => Navigator.pop(context),
          ),
        ),
      );
    }
  }

  Future<void> _processPayment() async {
    if (_voucherCodeController.text.isEmpty || _amountController.text.isEmpty) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final amount = int.parse(_amountController.text);

      final result = await widget.client.processVoucherPayment(
        voucherCode: _voucherCodeController.text,
        lockPin: _lockPinController.text,
        amount: amount,
        receivingCurrencyId: widget.receivingCurrencyId,
        walletAddress: widget.walletAddress,
      );

      widget.onSuccess(result);
    } on LongswipeException catch (e) {
      widget.onError(e);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildDefaultInput({
    required String label,
    required TextEditingController controller,
    bool isNumber = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: widget.theme.inputFieldStyle.decoration?.copyWith(
              labelText: label,
            ) ??
            InputDecoration(
              labelText: label,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  widget.theme.inputFieldStyle.borderRadius,
                ),
                borderSide: BorderSide(
                  color: widget.theme.inputFieldStyle.borderColor,
                ),
              ),
            ),
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        style: widget.theme.inputFieldStyle.textStyle,
      ),
    );
  }

  Widget _buildDefaultButton(VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: widget.theme.paymentButtonStyle.height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.theme.paymentButtonStyle.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              widget.theme.paymentButtonStyle.borderRadius,
            ),
          ),
        ),
        child: Text(
          'Verify Voucher',
          style: widget.theme.paymentButtonStyle.textStyle ??
              TextStyle(
                color: widget.theme.paymentButtonStyle.textColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return widget.loadingWidget ??
          const Center(child: CircularProgressIndicator());
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        widget.voucherCodeBuilder?.call(context, _voucherCodeController) ??
            _buildDefaultInput(
              label: 'Voucher Code',
              controller: _voucherCodeController,
            ),
        widget.voucherPinBuilder?.call(context, _lockPinController) ??
            _buildDefaultInput(
              label: 'Lock PIN (Optional)',
              controller: _lockPinController,
            ),
        widget.amountBuilder?.call(context, _amountController) ??
            _buildDefaultInput(
              label: 'Amount',
              controller: _amountController,
              isNumber: true,
            ),
        const SizedBox(height: 16),
        widget.submitButtonBuilder?.call(context, _fetchVoucherDetails) ??
            _buildDefaultButton(_fetchVoucherDetails),
      ],
    );
  }

  @override
  void dispose() {
    _voucherCodeController.dispose();
    _lockPinController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}
