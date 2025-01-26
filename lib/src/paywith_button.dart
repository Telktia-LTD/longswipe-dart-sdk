import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './models/voucher_redemption_charges_response.dart';

class PayWithLongswipe extends StatefulWidget {
  final String baseUrl;
  final String apiKey;
  final String buttonText;
  final Color buttonColor;
  final Function(String) onLongswipeSubmit;
  final bool showLockpin;

  const PayWithLongswipe({
    Key? key,
    this.buttonText = 'Pay with Longswipe',
    this.buttonColor = Colors.deepPurple,
    required this.onLongswipeSubmit,
    this.showLockpin = false,
    required this.baseUrl,
    required this.apiKey,
  }) : super(key: key);

  @override
  State<PayWithLongswipe> createState() => _PayWithLongswipeState();
}

class _PayWithLongswipeState extends State<PayWithLongswipe> {
  final TextEditingController _codeController = TextEditingController();
  bool _isLoading = false;
  bool _isSuccess = false;
  String? _errorText;

  void _submitCode() async {
    if (_codeController.text.isEmpty) {
      setState(() {
        _errorText = 'Please enter your Longswipe code';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    try {
      await Future.delayed(
          const Duration(milliseconds: 1200)); // Simulate API call
      widget.onLongswipeSubmit(_codeController.text);
      setState(() {
        _isSuccess = true;
        _isLoading = false;
      });

      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isSuccess = false;
            _codeController.clear();
          });
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorText = 'Invalid Longswipe code';
      });
    }
  }

  void _showConfirmationModal(Charges charges) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Confirm Transaction'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Amount Requested:'),
                  Text('${charges.amount}'), // Amount requested
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Amount in Wei:'),
                  Text('${charges.amountInWei}'), // Amount in Wei
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Balance After Charges:'),
                  Text(
                      '${charges.balanceAfterCharges}'), // Balance after charges
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Balance After Charges (Wei):'),
                  Text('${charges.balanceAfterChargesInWei}'), // Balance in Wei
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Gas Limit (Wei):'),
                  Text('${charges.gasLimitInWei}'), // Gas limit in Wei
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Gas Price (Wei):'),
                  Text('${charges.gasPriceInWei}'), // Gas price in Wei
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Processing Fee:'),
                  Text('${charges.processingFee}'), // Processing fee
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Processing Fee (Wei):'),
                  Text(
                      '${charges.processingFeeInWei}'), // Processing fee in Wei
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Gas Cost:'),
                  Text('${charges.totalGasCost}'), // Total gas cost
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Gas & Processing Fee:'),
                  Text('${charges.totalGasCostAndProcessingFee}'), // Total fee
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Gas & Fee (Wei):'),
                  Text(
                      '${charges.totalGasCostAndProcessingFeeInWei}'), // Total in Wei
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _submitCode(); // Call your submit method here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.buttonColor,
              ),
              child:
                  const Text('Confirm', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _pasteCode() async {
    final clipboardData = await Clipboard.getData('text/plain');
    if (clipboardData != null) {
      _codeController.text = clipboardData.text!.toUpperCase();
      setState(() {
        _errorText = null; // Clear any previous error when pasting a new code
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.qr_code, color: widget.buttonColor, size: 28),
              const SizedBox(width: 8),
              Text(
                'Pay With Longswipe',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Enter your Longswipe code below to complete the payment.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.black54,
                ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _codeController,
            decoration: InputDecoration(
              hintText: 'Enter Longswipe code',
              hintStyle: TextStyle(color: Colors.grey[400]),
              errorText: _errorText,
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.grey[300]!,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: widget.buttonColor,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.paste, color: Colors.grey),
                onPressed: _pasteCode,
              ),
            ),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textCapitalization: TextCapitalization.characters,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
            ],
            onChanged: (_) {
              if (_errorText != null) {
                setState(() {
                  _errorText = null;
                });
              }
            },
          ),
          widget.showLockpin ? const SizedBox(height: 20) : const SizedBox(),
          widget.showLockpin
              ? TextField(
                  controller: _codeController,
                  decoration: InputDecoration(
                    hintText: 'Enter lock pin',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    errorText: _errorText,
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: widget.buttonColor,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    suffixIcon: IconButton(
                      icon:
                          const Icon(Icons.remove_red_eye, color: Colors.grey),
                      onPressed: () {},
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textCapitalization: TextCapitalization.characters,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
                  ],
                  onChanged: (_) {
                    if (_errorText != null) {
                      setState(() {
                        _errorText = null;
                      });
                    }
                  },
                )
              : const SizedBox(),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _isLoading
                    ? null
                    : _showConfirmationModal(
                        Charges(
                            amount: 400,
                            amountInWei: 400,
                            balanceAfterCharges: 400,
                            balanceAfterChargesInWei: 400,
                            gasLimitInWei: 400,
                            gasPriceInWei: 400,
                            processingFee: 400,
                            processingFeeInWei: 400,
                            totalGasCost: 4000,
                            totalGasCostAndProcessingFee: 5000,
                            totalGasCostAndProcessingFeeInWei: 5000,
                            totalGasCostInWei: 700),
                      );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.buttonColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : _isSuccess
                      ? const Icon(
                          Icons.check_circle_outline,
                          size: 24,
                        )
                      : Text(
                          widget.buttonText,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }
}
