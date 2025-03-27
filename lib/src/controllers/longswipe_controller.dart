import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../constants.dart';
import '../models/longswipe_options.dart';
import '../models/response_types.dart';

/// Controller for interacting with the Longswipe widget
class LongswipeController {
  /// Options for the Longswipe widget
  final LongswipeControllerOptions options;
  
  /// WebViewController for the WebView
  WebViewController? _webViewController;
  
  /// Whether the Longswipe script has been loaded
  bool _isLoaded = false;
  
  /// Whether the Longswipe script is currently loading
  bool _isLoading = false;
  
  /// Completer for script loading
  final Completer<void> _loadCompleter = Completer<void>();

  /// Constructor
  LongswipeController({
    required this.options,
  });

  /// Initialize the WebViewController
  void _initWebViewController() {
    if (_webViewController != null) return;
    
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            _injectLongswipeScript();
          },
          onPermissionRequest: (request) {
            if (request.types.contains(PermissionRequestType.camera)) {
              request.grant(request.types);
            }
          },
        ),
      )
      ..addJavaScriptChannel(
        'LongswipeFlutter',
        onMessageReceived: _handleJavaScriptMessage,
      )
      ..loadHtmlString(_getHtmlContent());
  }

  /// Get the HTML content for the WebView
  String _getHtmlContent() {
    return '''
      <!DOCTYPE html>
      <html>
        <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
          <title>Longswipe Widget</title>
          <style>
            body, html {
              margin: 0;
              padding: 0;
              width: 100%;
              height: 100%;
              overflow: hidden;
              background-color: transparent;
            }
          </style>
        </head>
        <body>
          <div id="longswipe-container"></div>
        </body>
      </html>
    ''';
  }

  /// Inject the Longswipe script into the WebView
  Future<void> _injectLongswipeScript() async {
    if (_isLoaded || _isLoading) return;
    
    _isLoading = true;
    options.onResponse(ResType.loading, null);
    
    final String uri = DEFAULT_URI;
    
    final String javascript = '''
      // Load script
      var script = document.createElement('script');
      script.src = '$uri';
      script.async = true;
      
      script.onload = function() {
        window.LongswipeFlutter.postMessage(JSON.stringify({
          type: 'start'
        }));
      };
      
      script.onerror = function() {
        window.LongswipeFlutter.postMessage(JSON.stringify({
          type: 'error',
          data: 'Failed to load Longswipe script'
        }));
      };
      
      document.head.appendChild(script);
    ''';
    
    await _webViewController?.runJavaScript(javascript);
  }

  /// Handle messages from JavaScript
  void _handleJavaScriptMessage(JavaScriptMessage message) {
    try {
      final Map<String, dynamic> data = jsonDecode(message.message);
      final String type = data['type'];
      final dynamic responseData = data['data'];
      
      switch (type) {
        case 'start':
          _isLoaded = true;
          _isLoading = false;
          if (!_loadCompleter.isCompleted) {
            _loadCompleter.complete();
          }
          options.onResponse(ResType.start, null);
          break;
        case 'success':
          options.onResponse(ResType.success, responseData);
          break;
        case 'error':
          _isLoaded = false;
          _isLoading = false;
          options.onResponse(ResType.error, responseData);
          break;
        case 'close':
          options.onResponse(ResType.close, null);
          break;
        default:
          options.onResponse(ResType.error, 'Unknown response type: $type');
      }
    } catch (e) {
      options.onResponse(ResType.error, 'Failed to parse message: $e');
    }
  }

  /// Open the Longswipe modal
  Future<void> openModal() async {
    if (!_isLoaded) {
      if (!_isLoading) {
        await loadScript();
      }
      await _loadCompleter.future;
    }
    
    final Map<String, dynamic> optionsMap = options.toMap();
    final String optionsJson = jsonEncode(optionsMap);
    
    final String javascript = '''
      if (window.LongswipeConnect) {
        try {
          // Create options with callbacks
          var options = $optionsJson;
          
          // Add callbacks
          options.onSuccess = function(data) {
            window.LongswipeFlutter.postMessage(JSON.stringify({
              type: 'success',
              data: data
            }));
          };
          
          options.onError = function(error) {
            window.LongswipeFlutter.postMessage(JSON.stringify({
              type: 'error',
              data: error
            }));
          };
          
          options.onClose = function() {
            window.LongswipeFlutter.postMessage(JSON.stringify({
              type: 'close'
            }));
          };
          
          // Create instance if it doesn't exist
          if (!window.longswipeInstance) {
            window.longswipeInstance = new LongswipeConnect(options);
            window.longswipeInstance.setup();
          }
          
          // Open the modal
          window.longswipeInstance.open();
        } catch (e) {
          window.LongswipeFlutter.postMessage(JSON.stringify({
            type: 'error',
            data: 'Error opening modal: ' + e.message
          }));
        }
      } else {
        window.LongswipeFlutter.postMessage(JSON.stringify({
          type: 'error',
          data: 'LongswipeConnect not available'
        }));
      }
    ''';
    
    await _webViewController?.runJavaScript(javascript);
  }

  /// Load the Longswipe script
  Future<void> loadScript() async {
    _initWebViewController();
    
    if (_isLoaded) return;
    if (_isLoading) return await _loadCompleter.future;
    
    // Reset completer if needed
    if (_loadCompleter.isCompleted) {
      _loadCompleter = Completer<void>();
    }
    
    await _injectLongswipeScript();
    return _loadCompleter.future;
  }

  /// Get the WebViewController
  WebViewController? get webViewController => _webViewController;

  /// Whether the Longswipe script has been loaded
  bool get isLoaded => _isLoaded;

  /// Whether the Longswipe script is currently loading
  bool get isLoading => _isLoading;
}
