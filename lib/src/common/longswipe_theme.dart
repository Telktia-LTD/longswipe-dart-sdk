import 'package:flutter/material.dart';

class LongswipeTheme {
  final TextStyle titleStyle;
  final TextStyle labelStyle;
  final TextStyle inputTextStyle;
  final TextStyle buttonTextStyle;
  final TextStyle cancelButtonTextStyle;
  final TextStyle dialogContentTextStyle;
  final ButtonStyle primaryButtonStyle;
  final ButtonStyle secondaryButtonStyle;
  final InputDecoration inputDecoration;
  final InputDecoration lockPinInputDecoration;
  final EdgeInsets contentPadding;
  final EdgeInsets containerMargin;
  final double borderRadius;
  final Color backgroundColor;
  final Color iconColor;
  final List<BoxShadow> containerShadow;

  const LongswipeTheme({
    required this.titleStyle,
    required this.labelStyle,
    required this.inputTextStyle,
    required this.buttonTextStyle,
    required this.cancelButtonTextStyle,
    required this.dialogContentTextStyle,
    required this.primaryButtonStyle,
    required this.secondaryButtonStyle,
    required this.contentPadding,
    required this.containerMargin,
    required this.borderRadius,
    required this.backgroundColor,
    required this.iconColor,
    required this.containerShadow,
    required this.inputDecoration,
    required this.lockPinInputDecoration,
  });

  static final defaultTheme = LongswipeTheme(
    titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    dialogContentTextStyle:
        const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
    inputTextStyle: const TextStyle(
        color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
    labelStyle: const TextStyle(fontSize: 14),
    buttonTextStyle: const TextStyle(color: Colors.white),
    cancelButtonTextStyle: const TextStyle(color: Colors.purple),
    primaryButtonStyle: ElevatedButton.styleFrom(
      backgroundColor: Colors.purple,
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    secondaryButtonStyle: ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    inputDecoration: const InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    ),
    lockPinInputDecoration: const InputDecoration(
      contentPadding: EdgeInsets.all(4),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      hintText: 'Lock pin',
    ),
    contentPadding: const EdgeInsets.all(20),
    containerMargin: const EdgeInsets.all(20),
    borderRadius: 10,
    backgroundColor: Colors.white,
    iconColor: Colors.purple,
    containerShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 16,
        offset: const Offset(0, 4),
      ),
    ],
  );
}
