import 'package:flutter/material.dart';

class DynamicCheckoutForm extends StatefulWidget {
  final String buttonText;
  final Color buttonColor;
  final Function(String) onVoucherSubmit;
  final Function() onButtonPressed;
  final TextStyle? buttonTextStyle;
  final InputDecoration? inputDecoration;

  const DynamicCheckoutForm({
    Key? key,
    this.buttonText = 'Apply',
    this.buttonColor = Colors.blue,
    required this.onVoucherSubmit,
    required this.onButtonPressed,
    this.buttonTextStyle,
    this.inputDecoration,
  }) : super(key: key);

  @override
  _DynamicCheckoutFormState createState() => _DynamicCheckoutFormState();
}

class _DynamicCheckoutFormState extends State<DynamicCheckoutForm> {
  final TextEditingController _voucherController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _voucherController,
            decoration: widget.inputDecoration ??
                InputDecoration(
                  hintText: 'Enter longswipe voucher code',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: () {
            widget.onVoucherSubmit(_voucherController.text);
            widget.onButtonPressed();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.buttonColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            widget.buttonText,
            style: widget.buttonTextStyle ??
                const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _voucherController.dispose();
    super.dispose();
  }
}
