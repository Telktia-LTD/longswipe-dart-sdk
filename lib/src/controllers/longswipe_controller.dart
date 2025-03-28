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
    mediaPlaybackRequiresUserGesture: false, // Allow media playback without user gesture
    cacheEnabled: false,
    clearCache: true,
    javaScriptEnabled: true,
    useShouldInterceptAjaxRequest: true,
    useShouldInterceptFetchRequest: true,
    useHybridComposition: true,  // Important for Android
    // Camera and microphone access
    javaScriptCanOpenWindowsAutomatically: true,
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
                  onPermissionRequest: (controller, request) async {
                    // Grant all permission requests from the WebView
                    return PermissionResponse(
                      resources: request.resources,
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
            document.addEventListener('DOMContentLoaded', function() {
              try {
                // Create options with callbacks
                var options = $optionsJson;
                
                // Add callbacks
                options.onSuccess = function(data) {
                  window.flutter_inappwebview.callHandler('onSuccessCallback', data);
                };
                
                options.onError = function(error) {
                  window.flutter_inappwebview.callHandler('onErrorCallback', error);
                };
                
                options.onClose = function() {
                  window.flutter_inappwebview.callHandler('onCloseCallback');
                };
                
                // Request camera and microphone permissions explicitly
                if (navigator.mediaDevices && navigator.mediaDevices.getUserMedia) {
                  navigator.mediaDevices.getUserMedia({ video: true, audio: true })
                    .then(function(stream) {
                      console.log('Camera and microphone access granted');
                      // Stop the stream immediately, we just needed to request permission
                      stream.getTracks().forEach(track => track.stop());
                      
                      // Create instance
                      window.longswipeInstance = new LongswipeConnect(options);
                      window.longswipeInstance.setup();
                      
                      // Notify Flutter that the script is loaded
                      window.flutter_inappwebview.callHandler('onStartCallback');
                      
                      // Open the modal
                      window.longswipeInstance.open();
                    })
                    .catch(function(error) {
                      console.error('Error accessing camera or microphone:', error);
                      window.flutter_inappwebview.callHandler('onErrorCallback', 'Error accessing camera or microphone: ' + error.message);
                    });
                } else {
                  // Fallback for browsers that don't support getUserMedia
                  console.warn('getUserMedia not supported, proceeding without explicit permission request');
                  
                  // Create instance
                  window.longswipeInstance = new LongswipeConnect(options);
                  window.longswipeInstance.setup();
                  
                  // Notify Flutter that the script is loaded
                  window.flutter_inappwebview.callHandler('onStartCallback');
                  
                  // Open the modal
                  window.longswipeInstance.open();
                }
              } catch (e) {
                console.error('Error initializing Longswipe:', e);
                window.flutter_inappwebview.callHandler('onErrorCallback', 'Error initializing Longswipe: ' + e.message);
              }
            });
          </script>
        </body>
      </html>
    ''';
  
  }
}
