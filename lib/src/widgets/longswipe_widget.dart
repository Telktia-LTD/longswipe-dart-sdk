import 'package:flutter/material.dart';
import '../controllers/longswipe_controller.dart';
import '../models/longswipe_options.dart';
import '../models/response_types.dart';

/// A widget that displays the Longswipe payment widget
class LongswipeWidget extends StatefulWidget {
  /// Your Longswipe API key
  final String apiKey;
  
  /// Unique identifier for the transaction
  final String referenceId;

  final Environment? environment;
  
  /// Callback function for widget events
  final void Function(ResType type, dynamic data) onResponse;
  
  /// Default currency for redemption
  final Currency? defaultCurrency;
  
  /// Default amount for redemption
  final double? defaultAmount;
  
  /// Additional configuration options
  final Map<String, dynamic>? config;
  
  /// Metadata to pass to the widget
  final Map<String, dynamic>? metaData;
  
  /// Optional child widget as the trigger
  final Widget? child;
  
  /// Optional custom text for the default button
  final String? buttonText;
  
  /// Optional button style
  final ButtonStyle? buttonStyle;
  
  /// Constructor
  const LongswipeWidget({
    Key? key,
    required this.apiKey,
    required this.referenceId,
    required this.environment,
    required this.onResponse,
    this.defaultCurrency,
    this.defaultAmount,
    this.config,
    this.metaData,
    this.child,
    this.buttonText,
    this.buttonStyle,
  }) : super(key: key);

  @override
  State<LongswipeWidget> createState() => _LongswipeWidgetState();
}

class _LongswipeWidgetState extends State<LongswipeWidget> {
  /// Controller for the Longswipe widget
  late LongswipeController _controller;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  @override
  void didUpdateWidget(LongswipeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Reinitialize controller if key properties change
    if (oldWidget.apiKey != widget.apiKey ||
        oldWidget.referenceId != widget.referenceId) {
      _initController();
    }
  }

  /// Initialize the controller
  void _initController() {
    _controller = LongswipeController(
      options: LongswipeControllerOptions(
        environment: widget.environment,
        apiKey: widget.apiKey,
        referenceId: widget.referenceId,
        onResponse: widget.onResponse,
        defaultCurrency: widget.defaultCurrency,
        defaultAmount: widget.defaultAmount,
        config: widget.config,
        metaData: widget.metaData,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // If child is provided, wrap it with a GestureDetector
    if (widget.child != null) {
      return GestureDetector(
        onTap: () => _controller.openModal(context),
        child: widget.child!,
      );
    }
    
    // Otherwise, render the default button
    return ElevatedButton(
      onPressed: () => _controller.openModal(context),
      style: widget.buttonStyle ?? _defaultButtonStyle(),
      child: Text(widget.buttonText ?? 'Pay with Longswipe'),
    );
  }

  /// Default button style
  ButtonStyle _defaultButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF0066FF),
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
