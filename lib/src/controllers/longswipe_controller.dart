import 'dart:async';
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
  
  /// Check and request camera permission
  /// Returns true if permission is granted, false otherwise
  Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.status;
    
    if (status.isGranted) {
      return true;
    }
    
    final result = await Permission.camera.request();
    
    if (result.isPermanentlyDenied) {
      openAppSettings();
    }
    
    return result.isGranted;
  }

  /// Open the Longswipe modal
  /// If [checkCameraPermission] is true, camera permission will be requested before opening the modal
  Future<void> open(BuildContext context, {
    Function(dynamic result)? onSuccess,
    Function(dynamic close)? onClose,
    Function(dynamic error)? onError,
    bool checkCameraPermission = true,
  }) async {
    // Check camera permission if required
    if (checkCameraPermission) {
      final hasPermission = await requestCameraPermission();
      if (!hasPermission) {
        if (onError != null) {
          onError('Camera permission denied');
        }
        return;
      }
    }
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
  bool isGranted = false;
  double progress = 0;
  
  // Timer for auto-closing the webview if JavaScript fails
  Timer? _closeTimeoutTimer;
  bool _isWebViewClosed = false;
  
  @override
  void initState() {
    super.initState();
    getPermissions();
    
    // Initialize WebView controller
    _initWebViewController();
  }
  
  @override
  void dispose() {
    _closeTimeoutTimer?.cancel();
    super.dispose();
  }
  
  void _initWebViewController() {
    // Create a WebViewController with initial settings
    final WebViewController controller = WebViewController(
      onPermissionRequest: (request) => request.grant(),
    );
    
    // Configure JavaScript mode
    controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    
    // Set background color
    controller.setBackgroundColor(const Color(0x00000000));
    
    // Configure navigation delegate
    controller.setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          setState(() {
            this.progress = progress / 100;
          });
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {
          // Execute JavaScript to check camera permissions after page loads
          controller.runJavaScript('''
            if (navigator.permissions && navigator.permissions.query) {
              navigator.permissions.query({name: 'camera'}).then(function(permissionStatus) {
                window.consoleLog.postMessage('Camera permission status: ' + permissionStatus.state);
                permissionStatus.onchange = function() {
                  window.consoleLog.postMessage('Camera permission changed to: ' + this.state);
                };
              }).catch(function(error) {
                window.consoleLog.postMessage('Error querying camera permission: ' + error);
              });
            } else {
              window.consoleLog.postMessage('Permissions API not supported');
            }
          ''');
          
          // Set up a fallback timer to close the webview if JavaScript fails
          // This will ensure the webview is closed even if the JavaScript channel approach fails
          _closeTimeoutTimer?.cancel();
          _closeTimeoutTimer = Timer(const Duration(seconds: 600), () {
            if (!_isWebViewClosed && mounted) {
              debugPrint('Fallback timer triggered: closing webview');
              _isWebViewClosed = true;
              widget.close('close_fallback');
              Navigator.pop(context);
            }
          });
        },
        onWebResourceError: (WebResourceError error) {
          // Log the error
          debugPrint('WebView error: ${error.description}');
          
          // For critical errors, close the webview
          if (error.errorCode >= 400) {
            if (!_isWebViewClosed && mounted) {
              _isWebViewClosed = true;
              _closeTimeoutTimer?.cancel();
              widget.error("WebView error: ${error.description}");
              Navigator.pop(context);
            }
          } else {
            // For non-critical errors, just report them
            widget.error("WebView error: ${error.description}");
          }
        },
        onNavigationRequest: (NavigationRequest request) {
          // Handle deep links for Longswipe app
          if (request.url.startsWith('longswipe://')) {
            _handleDeepLink(request.url);
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    );
    
    // Enable JavaScript access to camera
    if (Platform.isAndroid) {
      controller.runJavaScript('''
        navigator.mediaDevices.getUserMedia({ video: true })
          .then(function(stream) {
            window.consoleLog.postMessage('Camera access granted on Android');
            stream.getTracks().forEach(track => track.stop());
          })
          .catch(function(err) {
            window.consoleLog.postMessage('Error accessing camera on Android: ' + err);
          });
      ''');
    }
    
    // Set up JavaScript channels for communication first
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
        if (!_isWebViewClosed) {
          _isWebViewClosed = true;
          _closeTimeoutTimer?.cancel(); // Cancel the fallback timer
          widget.close('close');
          Navigator.pop(context);
        }
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
        if (!_isWebViewClosed) {
          _isWebViewClosed = true;
          _closeTimeoutTimer?.cancel(); // Cancel the fallback timer
          widget.error("WebView crashed or encountered a critical error");
          Navigator.pop(context);
        }
      },
    );
    
    controller.addJavaScriptChannel(
      'consoleLog',
      onMessageReceived: (JavaScriptMessage message) {
        debugPrint('Console: ${message.message}');
        
        // Check if this is a fallback close message
        if (message.message.contains('Failed to close webview')) {
          if (!_isWebViewClosed && mounted) {
            debugPrint('Fallback close via consoleLog triggered');
            _isWebViewClosed = true;
            _closeTimeoutTimer?.cancel();
            widget.close('close_fallback_console');
            Navigator.pop(context);
          }
        }
      },
    );
    
    // Load HTML content after setting up channels
    controller.loadHtmlString(_getHtmlContent(), baseUrl: 'https://longswipe.com');
    
    _webViewController = controller;
  } 
  
   void _handleDeepLink(String url) {
    debugPrint('Deep link intercepted: $url');
    
    // Handle the longswipe://appapprove deep link by opening the Longswipe app
    // if (url.contains('longswipe://appapprove')) {
    //   _openLongswipeApp();
    // } else {
    //   debugPrint('Unhandled deep link: $url');
    // }
  }

  

  Future<void> getPermissions() async {
    await initPermissions();
  }

  Future<void> initPermissions() async {
    await Permission.camera.request().then((value) {
      if (value.isPermanentlyDenied) {
        openAppSettings();
      }
    });
    if (await Permission.camera.request().isGranted) {
      setState(() {
        isGranted = true;
      });
    } else {
      Permission.camera.onDeniedCallback(() {
        Permission.camera.request();
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
            if (!_isWebViewClosed) {
              _isWebViewClosed = true;
              _closeTimeoutTimer?.cancel(); // Cancel the fallback timer
              widget.close('close_button');
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: isGranted
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
    debugPrint(optionsJson);
    return '''
      <!DOCTYPE html>
      <html lang="en">
        <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1, maximum-scale=1, minimum-scale=1, shrink-to-fit=1"/>
          <!-- Camera permissions meta tags -->
          <meta name="apple-mobile-web-app-capable" content="yes">
          <meta name="mobile-web-app-capable" content="yes">
          <!-- Updated Content Security Policy to allow camera access -->
          <meta http-equiv="Content-Security-Policy" content="default-src * 'self' 'unsafe-inline' 'unsafe-eval' data: gap: blob: mediastream: https://ssl.gstatic.com; style-src * 'self' 'unsafe-inline'; media-src * blob: 'self' 'unsafe-inline'; img-src * 'self' data: content:; connect-src * 'self'; frame-src *;">
          <title>Longswipe Payment</title>
          <!-- Script to ensure JavaScript channels are initialized -->
          <script>
            // Create a global object to track channel availability
            window.channelsReady = {
              onSuccessCallback: false,
              onErrorCallback: false,
              onCloseCallback: false,
              onStartCallback: false,
              onCrashCallback: false,
              consoleLog: false
            };
            
            // Function to check if a channel exists and mark it as ready
            function checkChannel(channelName) {
              if (window[channelName]) {
                window.channelsReady[channelName] = true;
                console.log(channelName + ' is available');
                return true;
              }
              return false;
            }
            
            // Check channels periodically
            var channelCheckInterval = setInterval(function() {
              let allReady = true;
              
              for (let channel in window.channelsReady) {
                if (!window.channelsReady[channel]) {
                  if (checkChannel(channel)) {
                    window.channelsReady[channel] = true;
                  } else {
                    allReady = false;
                  }
                }
              }
              
              if (allReady) {
                console.log('All channels are ready');
                clearInterval(channelCheckInterval);
              }
            }, 100);
          </script>
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
      // Check for camera permissions
      if (navigator.mediaDevices && navigator.mediaDevices.getUserMedia) {
        console.log("Camera API is available");
        navigator.mediaDevices.getUserMedia({ video: true })
          .then(function(stream) {
            console.log("Camera access granted");
            stream.getTracks().forEach(track => track.stop()); // Stop the camera after permission check
          })
          .catch(function(err) {
            console.error("Error accessing camera:", err);
            window.onErrorCallback.postMessage("Error accessing camera: " + err.toString());
          });
      } else {
        console.error("Camera API is not available");
        window.onErrorCallback.postMessage("Camera API is not available on this device or browser");
      }
      
      // Initialize the widget with required defaultCurrency and defaultAmount
      const connect = new LongswipeConnect({
        ...${optionsJson},
        flutter: {
          enableFlutterIntegration: true,
          flutterChannelName: 'longswipe_channel'
        },
        onSuccess: function(data) {
          console.log('Success:', data);
         window.onSuccessCallback.postMessage(JSON.stringify(data));
          // showResult('Success', data);
        },
        onError: function(error) {
          console.error('Error:', error);
          window.onErrorCallback.postMessage(error);
                
          // showResult('Error', error);
        },
        onClose: function() {
          console.log('Widget closed');
          
          // Function to attempt closing with retry logic
          function attemptClose(retryCount) {
            // Check if the channel exists and is ready
            if (window.onCloseCallback && window.channelsReady.onCloseCallback) {
              console.log('Using onCloseCallback to close webview');
              window.onCloseCallback.postMessage('close');
              return true;
            } else {
              console.error('onCloseCallback channel not available (attempt ' + retryCount + ')');
              
              if (retryCount < 5) {
                // Retry with exponential backoff
                var delay = 200 * Math.pow(1.5, retryCount);
                console.log('Retrying in ' + delay + 'ms');
                
                setTimeout(function() {
                  attemptClose(retryCount + 1);
                }, delay);
              } else {
                console.error('Failed to close webview after multiple attempts');
                // Try to use consoleLog as a fallback if available
                if (window.consoleLog) {
                  window.consoleLog.postMessage('Failed to close webview: onCloseCallback not available');
                }
              }
              return false;
            }
          }
          
          // Start the close attempt process
          attemptClose(0);
        }
      });
      
      // Set up widget styles with modern options
      connect.setup({
        backgroundColor: 'white',
        textColor: '#111827',
        buttonColor: '#6366F1', // Indigo
        buttonTextColor: 'white',
        borderRadius: '0.75rem',
        boxShadow: '0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04)',
        fontFamily: "'DM Sans', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif",
        inputBackgroundColor: '#F9FAFB',
        inputBorderColor: '#D1D5DB',
        cardBackgroundColor: '#fff',
        cardBorderColor: '#E5E7EB',
        successColor: '#10B981', // Emerald
        errorColor: '#EF4444', // Red
        animationSpeed: '0.3s'
      });
      
      // Open widget automatically
      connect.open();
      
      // Function to display results
      function showResult(type, data) {
        const resultDiv = document.getElementById('result');
        const resultContent = document.getElementById('result-content');
        
        resultDiv.classList.remove('d-none');
        resultDiv.classList.remove('alert-success', 'alert-danger');
        resultDiv.classList.add(type === 'Success' ? 'alert-success' : 'alert-danger');
        resultContent.textContent = type + ': ' + JSON.stringify(data, null, 2);
      }
    });
  
          </script>
        </body>
      </html>
    ''';
  }
}
