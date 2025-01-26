import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PayWithLongswipe extends StatefulWidget {
  final String buttonText;
  final Color buttonColor;
  final Function(String) onLongswipeSubmit;

  const PayWithLongswipe({
    Key? key,
    this.buttonText = 'Pay with Longswipe',
    this.buttonColor = Colors.deepPurple,
    required this.onLongswipeSubmit,
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
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submitCode,
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
