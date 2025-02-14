import 'package:flutter/material.dart';

class LongswipeTheme {
  final PaymentButtonStyle paymentButtonStyle;
  final InputFieldStyle inputFieldStyle;
  final DialogStyle dialogStyle;

  const LongswipeTheme({
    this.paymentButtonStyle = const PaymentButtonStyle(),
    this.inputFieldStyle = const InputFieldStyle(),
    this.dialogStyle = const DialogStyle(),
  });
}

class PaymentButtonStyle {
  final double height;
  final double borderRadius;
  final Color backgroundColor;
  final Color textColor;
  final TextStyle? textStyle;

  const PaymentButtonStyle({
    this.height = 50,
    this.borderRadius = 8,
    this.backgroundColor = const Color(0xFF1A73E8),
    this.textColor = Colors.white,
    this.textStyle,
  });
}

class InputFieldStyle {
  final InputDecoration? decoration;
  final TextStyle? textStyle;
  final double borderRadius;
  final Color borderColor;

  const InputFieldStyle({
    this.decoration,
    this.textStyle,
    this.borderRadius = 8,
    this.borderColor = Colors.grey,
  });
}

class DialogStyle {
  final double borderRadius;
  final Color backgroundColor;
  final TextStyle? titleStyle;
  final TextStyle? messageStyle;

  const DialogStyle({
    this.borderRadius = 12,
    this.backgroundColor = Colors.white,
    this.titleStyle,
    this.messageStyle,
  });
}
