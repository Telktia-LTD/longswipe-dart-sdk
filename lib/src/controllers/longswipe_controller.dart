import 'dart:convert';
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
  Future<void> openModal(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LongswipeWebView(
          options: options,
          onLoaded: () {
            _isLoaded = true;
            _isLoading = false;
          },
        ),
      ),
    );
  }

  /// Whether the Longswipe script has been loaded
  bool get isLoaded => _isLoaded;

  /// Whether the Longswipe script is currently loading
  bool get isLoading => _isLoading;
}

/// WebView screen for the Longswipe widget
class LongswipeWebView extends StatefulWidget {
  /// Options for the Longswipe widget
  final LongswipeControllerOptions options;
  
  /// Callback when the script is loaded
  final VoidCallback onLoaded;

  /// Constructor
  const LongswipeWebView({
    Key? key,
    required this.options,
    required this.onLoaded,
  }) : super(key: key);

  @override
  State<LongswipeWebView> createState() => _LongswipeWebViewState();
}

class _LongswipeWebViewState extends State<LongswipeWebView> {
  late InAppWebViewController _webViewController;
  bool isPermissionGranted = false;
  double progress = 0;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await Permission.camera.request().then((value) {
      if (value.isPermanentlyDenied) {
        openAppSettings();
      }
    });
    
    if (await Permission.camera.request().isGranted) {
      setState(() {
        isPermissionGranted = true;
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
            widget.options.onResponse(ResType.close, null);
            Navigator.pop(context);
          },
        ),
      ),
      body: isPermissionGranted
          ? Stack(
              children: [
                InAppWebView(
                  initialSettings: InAppWebViewSettings(
                    allowsInlineMediaPlayback: true,
                    cacheEnabled: false,
                    clearCache: true,
                  ),
                  initialData: InAppWebViewInitialData(
                    baseUrl: WebUri("https://longswipe.com"),
                    historyUrl: WebUri("https://longswipe.com"),
                    mimeType: "text/html",
                    data: _getHtmlContent(),
                  ),
                  onWebViewCreated: (controller) {
                    _webViewController = controller;

                    _webViewController.addJavaScriptHandler(
                      handlerName: 'onSuccessCallback',
                      callback: (response) {
                        widget.options.onResponse(ResType.success, response.first);
                        Navigator.pop(context);
                      },
                    );

                    _webViewController.addJavaScriptHandler(
                      handlerName: 'onErrorCallback',
                      callback: (error) {
                        widget.options.onResponse(ResType.error, error.first);
                      },
                    );

                    _webViewController.addJavaScriptHandler(
                      handlerName: 'onCloseCallback',
                      callback: (response) {
                        widget.options.onResponse(ResType.close, null);
                        Navigator.pop(context);
                      },
                    );

                    _webViewController.addJavaScriptHandler(
                      handlerName: 'onStartCallback',
                      callback: (response) {
                        widget.options.onResponse(ResType.start, null);
                        widget.onLoaded();
                      },
                    );
                  },
                  androidOnPermissionRequest: (controller, origin, resources) async {
                    return PermissionRequestResponse(
                      resources: resources,
                      action: PermissionRequestResponseAction.GRANT,
                    );
                  },
                  onProgressChanged: (controller, progress) {
                    setState(() {
                      this.progress = progress / 100;
                    });
                  },
                  onConsoleMessage: (controller, consoleMessage) {
                    print("Console: ${consoleMessage.message}");
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
                
                // Create instance
                window.longswipeInstance = new LongswipeConnect(options);
                window.longswipeInstance.setup();
                
                // Notify Flutter that the script is loaded
                window.flutter_inappwebview.callHandler('onStartCallback');
                
                // Open the modal
                window.longswipeInstance.open();
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
