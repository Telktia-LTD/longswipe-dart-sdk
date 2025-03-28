import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
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
  late InAppWebViewController _webViewController;
  bool isPermissionGranted = false;
  double progress = 0;
  late PullToRefreshController pullToRefreshController;

  InAppWebViewSettings options = InAppWebViewSettings(
    allowsInlineMediaPlayback: true,
    cacheEnabled: false,
    clearCache: true,
    javaScriptEnabled: true,
    useShouldInterceptAjaxRequest: true,
    useShouldInterceptFetchRequest: true,
    useHybridComposition: true,  // Important for Android
  );

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    pullToRefreshController = PullToRefreshController(
      onRefresh: () async {
        if (Platform.isAndroid) {
          _webViewController.reload();
        } else if (Platform.isIOS) {
          _webViewController.loadUrl(
            urlRequest: URLRequest(url: await _webViewController.getUrl()),
          );
        }
      },
    );
  }

  Future<void> _requestPermissions() async {
    var status = await Permission.camera.request();
    
    if (status.isGranted) {
      setState(() {
        isPermissionGranted = true;
      });
    } else if (status.isDenied) {
      // Permission is denied, show a dialog or retry
      status = await Permission.camera.request();
      if (status.isGranted) {
        setState(() {
          isPermissionGranted = true;
        });
      }
    } else if (status.isPermanentlyDenied) {
      // Permission is permanently denied, open app settings
      openAppSettings();
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
                InAppWebView(
                  key: webViewKey,
                  gestureRecognizers: gestureRecognizers,
                  initialSettings: options,
                  initialData: InAppWebViewInitialData(
                    baseUrl: WebUri('https://longswipe.com'),
                    historyUrl: WebUri('https://longswipe.com'),
                    mimeType: 'text/html',
                    data: _getHtmlContent(),
                  ),
                  initialUrlRequest: URLRequest(
                    url: WebUri('https://longswipe.com'),
                  ),
                  pullToRefreshController: pullToRefreshController,
                  onWebViewCreated: (controller) {
                    _webViewController = controller;

                    _webViewController.addJavaScriptHandler(
                      handlerName: 'onSuccessCallback',
                      callback: (response) {
                        widget.success(response.first);
                        Navigator.pop(context);
                      },
                    );

                    _webViewController.addJavaScriptHandler(
                      handlerName: 'onErrorCallback',
                      callback: (error) {
                        widget.error(error.first);
                      },
                    );

                    _webViewController.addJavaScriptHandler(
                      handlerName: 'onCloseCallback',
                      callback: (response) {
                        widget.close('close');
                        Navigator.pop(context);
                      },
                    );

                    _webViewController.addJavaScriptHandler(
                      handlerName: 'onStartCallback',
                      callback: (response) {
                        widget.success(null); // Notify that the script is loaded
                      },
                    );
                    
                    // Add a handler for WebView crashes
                    _webViewController.addJavaScriptHandler(
                      handlerName: 'onCrashCallback',
                      callback: (response) {
                        widget.error("WebView crashed or encountered a critical error");
                        Navigator.pop(context);
                      },
                    );
                  },
                  onPermissionRequest: Platform.isAndroid
                    ? null
                    : (controller, origin) async {
                        return PermissionResponse(
                          resources: [],
                          action: PermissionResponseAction.GRANT,
                        );
                      },
                  onLoadStop: (controller, url) {
                    pullToRefreshController.endRefreshing();
                  },
                  onReceivedError: (controller, request, error) {
                    pullToRefreshController.endRefreshing();
                    // Handle WebView errors
                    if (error.type == WebResourceErrorType.UNKNOWN) {
                      widget.error("WebView error: ${error.description}");
                    }
                  },
                  onProgressChanged: (controller, progress) {
                    if (progress == 100) {
                      pullToRefreshController.endRefreshing();
                    }
                    setState(() {
                      this.progress = progress / 100;
                    });
                  },
                  androidOnPermissionRequest: (controller, origin, resources) async {
                    return PermissionRequestResponse(
                      resources: resources,
                      action: PermissionRequestResponseAction.GRANT,
                    );
                  },
                  androidOnGeolocationPermissionsShowPrompt: (controller, origin) async {
                    return GeolocationPermissionShowPromptResponse(
                      allow: true,
                      origin: origin,
                      retain: true,
                    );
                  },
                  onConsoleMessage: (controller, consoleMessage) {
                    print('Console: ${consoleMessage.message}');
                    // Check for error messages that might indicate a crash
                    if (consoleMessage.messageLevel == ConsoleMessageLevel.ERROR) {
                      print('Console Error: ${consoleMessage.message}');
                    }
                  },
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
          
          <script src="$DEFAULT_URI"></script>
          <script>
            // Global error handler to catch any unhandled errors
            window.onerror = function(message, source, lineno, colno, error) {
              console.error('Global error:', message);
              if (window.flutter_inappwebview) {
                window.flutter_inappwebview.callHandler('onErrorCallback', 'Global error: ' + message);
              }
              return true; // Prevents the default error handling
            };
            
            // Store original setTimeout
            var originalSetTimeout = window.setTimeout;
            
            // Don't override setTimeout directly, as it might cause issues with the widget
            // Instead, create a safe version that we'll use in our code
            function safeSetTimeout(callback, delay) {
              if (typeof callback !== 'function') {
                console.warn('setTimeout called with non-function callback');
                return originalSetTimeout(function() {}, delay || 0);
              }
              
              return originalSetTimeout(function() {
                try {
                  callback();
                } catch (e) {
                  console.error('Error in setTimeout callback:', e);
                  if (window.flutter_inappwebview) {
                    window.flutter_inappwebview.callHandler('onErrorCallback', 'Error in setTimeout callback: ' + e.message);
                  }
                }
              }, delay || 0);
            }
            
            // Store original setInterval for reference
            var originalSetInterval = window.setInterval;
            
            // Monitor for potential crashes using recursive setTimeout instead of setInterval
            var lastActivityTime = Date.now();
            var crashMonitorActive = true;
            
            function monitorCrashes() {
              if (!crashMonitorActive) return;
              
              var now = Date.now();
              if (now - lastActivityTime > 5000) {
                // No activity for 5 seconds, might indicate a problem
                console.warn('No activity detected for 5 seconds, checking if UI is responsive');
                
                // Try to update the lastActivityTime
                lastActivityTime = now;
                
                // Check if we can still interact with the DOM
                try {
                  document.body.dataset.timestamp = now.toString();
                  if (document.body.dataset.timestamp !== now.toString()) {
                    throw new Error('DOM manipulation failed');
                  }
                } catch (e) {
                  console.error('UI appears to be frozen:', e);
                  if (window.flutter_inappwebview) {
                    window.flutter_inappwebview.callHandler('onCrashCallback');
                  }
                  crashMonitorActive = false;
                  return;
                }
              }
              
              // Schedule the next check using originalSetTimeout to avoid any issues
              originalSetTimeout(monitorCrashes, 1000);
            }
            
            // Start the crash monitor
            originalSetTimeout(monitorCrashes, 1000);
            
            // Update lastActivityTime on user interaction
            document.addEventListener('click', function() {
              lastActivityTime = Date.now();
            });
            
            document.addEventListener('touchstart', function() {
              lastActivityTime = Date.now();
            });
            
            document.addEventListener('keydown', function() {
              lastActivityTime = Date.now();
            });
            
            document.addEventListener('DOMContentLoaded', function() {
              try {
                // Create options with callbacks
                var options = $optionsJson;
                
                // Add callbacks with error handling
                options.onSuccess = function(data) {
                  try {
                    lastActivityTime = Date.now();
                    if (window.flutter_inappwebview) {
                      window.flutter_inappwebview.callHandler('onSuccessCallback', data);
                    }
                  } catch (e) {
                    console.error('Error in onSuccess callback:', e);
                  }
                };
                
                options.onError = function(error) {
                  try {
                    lastActivityTime = Date.now();
                    if (window.flutter_inappwebview) {
                      window.flutter_inappwebview.callHandler('onErrorCallback', error);
                    }
                  } catch (e) {
                    console.error('Error in onError callback:', e);
                  }
                };
                
                options.onClose = function() {
                  try {
                    lastActivityTime = Date.now();
                    if (window.flutter_inappwebview) {
                      window.flutter_inappwebview.callHandler('onCloseCallback');
                    }
                  } catch (e) {
                    console.error('Error in onClose callback:', e);
                  }
                };
                
                // Create instance
                window.longswipeInstance = new LongswipeConnect(options);
                window.longswipeInstance.setup();
                
                // Notify Flutter that the script is loaded
                if (window.flutter_inappwebview) {
                  window.flutter_inappwebview.callHandler('onStartCallback');
                }
                
                // Open the modal with a slight delay to ensure everything is initialized
                safeSetTimeout(function() {
                  lastActivityTime = Date.now();
                  window.longswipeInstance.open();
                }, 100);
              } catch (e) {
                console.error('Error initializing Longswipe:', e);
                if (window.flutter_inappwebview) {
                  window.flutter_inappwebview.callHandler('onErrorCallback', 'Error initializing Longswipe: ' + e.message);
                }
              }
            });
          </script>
        </body>
      </html>
    ''';
  }
}
