import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../controllers/longswipe_controller.dart';
import '../models/longswipe_options.dart';
import '../models/response_types.dart';

/// A widget that displays the Longswipe payment widget
class LongswipeWidget extends StatefulWidget {
  /// Your Longswipe API key
  final String apiKey;
  
  /// Unique identifier for the transaction
  final String referenceId;
  
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
  
  /// Whether the widget is currently showing the modal
  bool _isShowingModal = false;

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
        apiKey: widget.apiKey,
        referenceId: widget.referenceId,
        onResponse: _handleResponse,
        defaultCurrency: widget.defaultCurrency,
        defaultAmount: widget.defaultAmount,
        config: widget.config,
        metaData: widget.metaData,
      ),
    );
    
    // Load the script
    _controller.loadScript();
  }

  /// Handle responses from the Longswipe widget
  void _handleResponse(ResType type, dynamic data) {
    // Forward the response to the widget's onResponse callback
    widget.onResponse(type, data);
    
    // Update state if needed
    if (type == ResType.close || type == ResType.success || type == ResType.error) {
      if (_isShowingModal) {
        setState(() {
          _isShowingModal = false;
        });
        Navigator.of(context).pop();
      }
    }
  }

  /// Open the Longswipe modal
  Future<void> _openModal() async {
    if (!_controller.isLoaded) {
      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Loading Longswipe...'),
          duration: Duration(seconds: 2),
        ),
      );
      
      // Wait for script to load
      await _controller.loadScript();
    }
    
    // Show modal
    setState(() {
      _isShowingModal = true;
    });
    
    // Show dialog with WebView
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: WebViewWidget(
            controller: _controller.webViewController!,
          ),
        ),
      ),
    );
    
    // Update state when dialog is closed
    setState(() {
      _isShowingModal = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // If child is provided, wrap it with a GestureDetector
    if (widget.child != null) {
      return GestureDetector(
        onTap: _controller.isLoaded ? _openModal : null,
        child: widget.child!,
      );
    }
    
    // Otherwise, render the default button
    return ElevatedButton(
      onPressed: _controller.isLoaded ? _openModal : null,
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
