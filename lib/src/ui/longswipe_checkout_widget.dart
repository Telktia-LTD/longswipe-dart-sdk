import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:longswipe_payment/src/ui/voucher_details_dialog.dart';
import '../../longswipe_payment.dart';
import '../common/longswipe_theme.dart';

class LongswipeCheckoutWidget extends StatefulWidget {
  const LongswipeCheckoutWidget({
    super.key,
    required this.publicKey,
    required this.isSandbox,
    required this.currencyCode,
    required this.amount,
    this.walletAddress = '',
    this.theme,
  });

  final String publicKey;
  final bool isSandbox;
  final String currencyCode;
  final int amount;
  final String walletAddress;
  final LongswipeTheme? theme;

  @override
  State<LongswipeCheckoutWidget> createState() =>
      _LongswipeCheckoutWidgetState();
}

class _LongswipeCheckoutWidgetState extends State<LongswipeCheckoutWidget> {
  late final LongswipeClient _client;
  final TextEditingController _voucherController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _client = LongswipeClient(
      apiKey: widget.publicKey,
      isSandbox: widget.isSandbox,
    );
  }

  @override
  void dispose() {
    _voucherController.dispose();
    super.dispose();
  }

  Future<void> _handleVoucherSubmission() async {
    if (_voucherController.text.isEmpty) {
      _showErrorMessage('Please enter a voucher code');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await _client.fetchVoucherDetails(
        voucherCode: _voucherController.text,
        amount: widget.amount,
        receivingCurrencyCode: widget.currencyCode,
      );

      if (!mounted) return;

      if (response.data == null) {
        _showErrorMessage(response.message);
      } else {
        _showVoucherDetailsDialog(response);
      }
    } catch (e) {
      _showErrorMessage(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showVoucherDetailsDialog(VoucherChargesDetailsResponse response) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => VoucherDetailsDialog(
        details: response.data!,
        client: _client,
        voucherCode: _voucherController.text,
        amount: widget.amount,
        currencyCode: widget.currencyCode,
        walletAddress: widget.walletAddress,
        theme: widget.theme,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme ?? LongswipeTheme.defaultTheme;

    return Container(
      padding: theme.contentPadding,
      margin: theme.containerMargin,
      decoration: BoxDecoration(
        color: theme.backgroundColor,
        borderRadius: BorderRadius.circular(theme.borderRadius),
        boxShadow: theme.containerShadow,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(theme),
          const SizedBox(height: 16),
          _buildVoucherInput(theme),
          const SizedBox(height: 16),
          _buildSubmitButton(theme),
        ],
      ),
    );
  }

  Widget _buildHeader(LongswipeTheme theme) {
    return Row(
      children: [
        Icon(Icons.credit_card, color: theme.iconColor),
        const SizedBox(width: 8),
        Text(
          'Pay With Longswipe',
          style: theme.titleStyle,
        ),
      ],
    );
  }

  Widget _buildVoucherInput(LongswipeTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enter your Longswipe voucher code',
          style: theme.labelStyle,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _voucherController,
          style: theme.inputTextStyle,
          decoration: theme.inputDecoration.copyWith(
            suffixIcon: IconButton(
              icon: const Icon(Icons.paste_rounded),
              color: theme.iconColor,
              onPressed: () async {
                final clipboardData = await Clipboard.getData('text/plain');
                if (clipboardData != null) {
                  _voucherController.text = clipboardData.text ?? '';
                }
              },
            ),
          ),
          enabled: !_isLoading,
        ),
      ],
    );
  }

  Widget _buildSubmitButton(LongswipeTheme theme) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleVoucherSubmission,
        style: theme.primaryButtonStyle,
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text('Proceed', style: theme.buttonTextStyle),
      ),
    );
  }
}
