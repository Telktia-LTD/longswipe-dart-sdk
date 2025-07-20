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
  final void Function(ResponseType type, dynamic data) onResponse;

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
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFA8518A), Color(0xFF3E4095)],
          // Light purple to darker purple
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8), // Pill shape
        boxShadow: const [
          BoxShadow(
            color: Color(0x668E44AD), // Semi-transparent shadow
            blurRadius: 8,
            offset: Offset(0, 3),
            spreadRadius: 1,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () => _controller.openModal(context),
        style: widget.buttonStyle ?? _defaultButtonStyle(),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.network(
                  'https://res.cloudinary.com/dm9s6bfd1/image/upload/v1738080416/longswipe/logo/Longswipe_logo_icon_white_swge3g.png',
                  height: 20,
                ),
                const SizedBox(width: 12),
                // Text
                Text(
                  widget.buttonText ?? 'Pay with Longswipe',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Default button style
  ButtonStyle _defaultButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      shadowColor: Colors.transparent,
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30), // Match container's radius
      ),
      elevation: 0, // No elevation, we're using the container's shadow
    );
  }
}
