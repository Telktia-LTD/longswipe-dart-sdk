import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import '../constants.dart';
import '../models/longswipe_options.dart';
import '../models/response_types.dart';

/// Controller for interacting with the Longswipe widget
class LongswipeController {
  /// Options for the Longswipe widget
  final LongswipeControllerOptions options;
  
  /// Whether the Longswipe script has been loaded
  bool _isLoaded = false;
  
  /// Whether the Longswipe script is currently loading
  bool _isLoading = false;

  /// Constructor
  LongswipeController({
    required this.options,
  });

  /// Open the Longswipe modal
  Future<void> open(BuildContext context, {
    Function(dynamic result)? onSuccess,
    Function(dynamic close)? onClose,
    Function(dynamic error)? onError
  }) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LongswipeWebView(
          options: options,
          success: (result) {
            _isLoaded = true;
            _isLoading = false;
            if (onSuccess != null) onSuccess(result);
          },
          close: (close) {
            if (onClose != null) onClose(close);
          },
          error: (error) {
            if (onError != null) onError(error);
          },
        ),
      ),
    );
  }

  /// Whether the Longswipe script has been loaded
  bool get isLoaded => _isLoaded;

  /// Whether the Longswipe script is currently loading
  bool get isLoading => _isLoading;
  
  /// Alias for open method to maintain backward compatibility
  @Deprecated('Use open() instead')
  Future<void> openModal(BuildContext context) async {
    return open(
      context,
      onSuccess: (result) => options.onResponse(ResType.success, result),
      onClose: (close) => options.onResponse(ResType.close, null),
      onError: (error) => options.onResponse(ResType.error, error),
    );
  }
}

/// WebView screen for the Longswipe widget
class LongswipeWebView extends StatefulWidget {
  /// Options for the Longswipe widget
  final LongswipeControllerOptions options;
  
  /// Callback functions
  final Function(dynamic) success;
  final Function(dynamic) error;
  final Function(dynamic) close;

  /// Constructor
  const LongswipeWebView({
    Key? key,
    required this.options,
    required this.success,
    required this.error,
    required this.close,
  }) : super(key: key);

  @override
  State<LongswipeWebView> createState() => _LongswipeWebViewState();
}

class _LongswipeWebViewState extends State<LongswipeWebView> {
  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers = {
    Factory(() => EagerGestureRecognizer())
  };
  final GlobalKey webViewKey = GlobalKey();
  late WebViewController _webViewController;
  bool isPermissionGranted = false;
  double progress = 0;
  
  @override
  void initState() {
    super.initState();
    _requestPermissions();
    
    // Initialize WebView controller
    _initWebViewController();
  }
  
  void _initWebViewController() {
    // Create a WebViewController with initial settings
    final WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              this.progress = progress / 100;
            });
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {
            widget.error("WebView error: ${error.description}");
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      );
    
    // Load HTML content
    controller.loadHtmlString(_getHtmlContent(), baseUrl: 'https://longswipe.com');
    
    // Set up JavaScript channels for communication
    controller.addJavaScriptChannel(
      'onSuccessCallback',
      onMessageReceived: (JavaScriptMessage message) {
        widget.success(jsonDecode(message.message));
      },
    );
    
    controller.addJavaScriptChannel(
      'onErrorCallback',
      onMessageReceived: (JavaScriptMessage message) {
        widget.error(message.message);
      },
    );
    
    controller.addJavaScriptChannel(
      'onCloseCallback',
      onMessageReceived: (JavaScriptMessage message) {
        widget.close('close');
        Navigator.pop(context);
      },
    );
    
    controller.addJavaScriptChannel(
      'onStartCallback',
      onMessageReceived: (JavaScriptMessage message) {
        widget.success(null); // Notify that the script is loaded
      },
    );
    
    controller.addJavaScriptChannel(
      'onCrashCallback',
      onMessageReceived: (JavaScriptMessage message) {
        widget.error("WebView crashed or encountered a critical error");
        Navigator.pop(context);
      },
    );
    
    controller.addJavaScriptChannel(
      'consoleLog',
      onMessageReceived: (JavaScriptMessage message) {
        debugPrint('Console: ${message.message}');
      },
    );
    
    _webViewController = controller;
  }

  Future<void> _requestPermissions() async {
    // List of permissions needed for the app
    List<Permission> permissions = [
      Permission.camera,
    ];
    
    // Add platform-specific permissions
    if (Platform.isIOS) {
      permissions.addAll([
        Permission.microphone,
        Permission.photos,
        Permission.location,
      ]);
    }
    
    // Request each permission
    bool allGranted = true;
    for (var permission in permissions) {
      var status = await permission.status;
      
      if (!status.isGranted) {
        status = await permission.request();
        
        if (!status.isGranted) {
          allGranted = false;
          debugPrint('${permission.toString()} is not granted. Status: $status');
          
          if (status.isPermanentlyDenied) {
            // Show a dialog to guide the user to app settings
            debugPrint('${permission.toString()} is permanently denied. Please enable it in app settings.');
          }
        }
      }
    }
    
    setState(() {
      isPermissionGranted = allGranted;
    });
    
    // If not all permissions are granted, but we still want to proceed
    // with limited functionality
    if (!allGranted) {
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          isPermissionGranted = true; // Allow the WebView to load anyway
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Longswipe Payment'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            widget.close('close');
            Navigator.pop(context);
          },
        ),
      ),
      body: isPermissionGranted
          ? Stack(
              children: [
                WebViewWidget(
                  key: webViewKey,
                  controller: _webViewController,
                  gestureRecognizers: gestureRecognizers,
                ),
                progress < 1.0
                    ? LinearProgressIndicator(value: progress)
                    : const SizedBox(),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  String _getHtmlContent() {
    final optionsMap = widget.options.toMap();
    final optionsJson = json.encode(optionsMap);
    
    return '''
      <!DOCTYPE html>
      <html lang="en">
        <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1, maximum-scale=1, minimum-scale=1, shrink-to-fit=1"/>
          <!-- Add permissions meta tags for iOS -->
          <meta http-equiv="Content-Security-Policy" content="default-src * 'self' 'unsafe-inline' 'unsafe-eval' data: gap: https://ssl.gstatic.com; style-src * 'self' 'unsafe-inline'; media-src * blob: 'self' 'unsafe-inline'; img-src * 'self' data: content:; connect-src * 'self'; frame-src *;">
          <title>Longswipe Payment</title>
          <style>
            body, html {
              margin: 0;
              padding: 0;
              width: 100%;
              height: 100%;
              overflow: hidden;
              background-color: #f5f5f5;
              font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
            }
            #container {
              display: flex;
              justify-content: center;
              align-items: center;
              height: 100%;
              width: 100%;
            }
          </style>
        </head>
        <body>
          <div id="container">
            <div id="longswipe-container"></div>
          </div>
          
          <script src="${DEFAULT_URI}"></script>
          <script>
            // Console log wrapper to send logs to Flutter
            console.log = (function(originalLog) {
              return function(...args) {
                originalLog.apply(console, args);
                window.consoleLog.postMessage(args.map(arg => 
                  typeof arg === 'object' ? JSON.stringify(arg) : String(arg)
                ).join(' '));
              };
            })(console.log);
            
            console.error = (function(originalError) {
              return function(...args) {
                originalError.apply(console, args);
                window.consoleLog.postMessage('ERROR: ' + args.map(arg => 
                  typeof arg === 'object' ? JSON.stringify(arg) : String(arg)
                ).join(' '));
              };
            })(console.error);
            
            document.addEventListener('DOMContentLoaded', function() {
              try {
                // Create options with callbacks
                var options = $optionsJson;
                
                // Add callbacks
                options.onSuccess = function(data) {
                  window.onSuccessCallback.postMessage(JSON.stringify(data));
                };
                
                options.onError = function(error) {
                  window.onErrorCallback.postMessage(error);
                };
                
                options.onClose = function() {
                  window.onCloseCallback.postMessage('close');
                };
                
                // Try to create the Longswipe instance regardless of camera access
                try {
                  // Create instance
                  window.longswipeInstance = new LongswipeConnect(options);
                  window.longswipeInstance.setup();
                  
                  // Notify Flutter that the script is loaded
                  window.onStartCallback.postMessage('started');
                  
                  // Open the modal
                  window.longswipeInstance.open();
                  
                  // Request camera and microphone permissions explicitly, but don't block UI
                  if (navigator.mediaDevices && navigator.mediaDevices.getUserMedia) {
                    navigator.mediaDevices.getUserMedia({ 
                      video: { facingMode: "user" }, // Prefer front camera
                      audio: true 
                    })
                    .then(function(stream) {
                      console.log('Camera and microphone access granted');
                      // Stop the stream immediately, we just needed to request permission
                      stream.getTracks().forEach(track => track.stop());
                    })
                    .catch(function(error) {
                      console.warn('Camera or microphone access issue (non-blocking):', error.name, error.message);
                      // Don't block the UI, just log the error
                    });
                  } else {
                    // Fallback for browsers that don't support getUserMedia
                    console.warn('getUserMedia not supported, proceeding anyway');
                  }
                } catch (e) {
                  console.error('Error initializing Longswipe:', e);
                  window.onErrorCallback.postMessage('Error initializing Longswipe: ' + e.message);
                }
              } catch (e) {
                console.error('Error initializing Longswipe:', e);
                window.onErrorCallback.postMessage('Error initializing Longswipe: ' + e.message);
              }
            });
          </script>
        </body>
      </html>
    ''';
  }
}
