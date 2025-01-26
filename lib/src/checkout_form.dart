import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DynamicCheckoutForm extends StatefulWidget {
  final String buttonText;
  final Color buttonColor;
  final Function(String) onVoucherSubmit;
  final Function() onButtonPressed;
  final TextStyle? buttonTextStyle;
  final InputDecoration? inputDecoration;

  const DynamicCheckoutForm({
    Key? key,
    this.buttonText = 'Apply Voucher',
    this.buttonColor = const Color(0xFF6366F1), // Indigo color
    required this.onVoucherSubmit,
    required this.onButtonPressed,
    this.buttonTextStyle,
    this.inputDecoration,
  }) : super(key: key);

  @override
  _DynamicCheckoutFormState createState() => _DynamicCheckoutFormState();
}

class _DynamicCheckoutFormState extends State<DynamicCheckoutForm>
    with SingleTickerProviderStateMixin {
  final TextEditingController _voucherController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isLoading = false;
  bool _isSuccess = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _handleSubmit() async {
    if (_voucherController.text.isEmpty) {
      setState(() {
        _errorText = 'Please enter a voucher code';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    try {
      await Future.delayed(
          const Duration(milliseconds: 1000)); // Simulate API call
      widget.onVoucherSubmit(_voucherController.text);
      widget.onButtonPressed();
      setState(() {
        _isSuccess = true;
        _isLoading = false;
      });

      // Reset success state after animation
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isSuccess = false;
          });
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorText = 'Invalid voucher code';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          Text(
            'Got a Voucher?',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Enter your code below to redeem your discount',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.black54,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextField(
                  controller: _voucherController,
                  decoration: widget.inputDecoration ??
                      InputDecoration(
                        hintText: 'Enter voucher code',
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
                        enabledBorder: OutlineInputBorder(
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
              ),
              const SizedBox(width: 12),
              ScaleTransition(
                scale: _scaleAnimation,
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.buttonColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : _isSuccess
                            ? const Icon(
                                Icons.check_circle_outline,
                                size: 24,
                              )
                            : Text(
                                widget.buttonText,
                                style: widget.buttonTextStyle ??
                                    const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _voucherController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}
