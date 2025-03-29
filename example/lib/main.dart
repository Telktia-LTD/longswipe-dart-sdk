import 'package:flutter/material.dart';
import 'package:longswipe/longswipe.dart';
import 'dart:io' show Platform;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Request all required permissions at app startup
  await _requestPermissions();

  runApp(const MyApp());
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
  for (var permission in permissions) {
    var status = await permission.status;

    if (!status.isGranted) {
      status = await permission.request();

      // If permission is permanently denied, show a dialog
      if (status.isPermanentlyDenied) {
        debugPrint('${permission.toString()} is permanently denied. Please enable it in app settings.');
      }
    }
  }
}

// Check if all required permissions are granted
Future<Map<Permission, PermissionStatus>> checkPermissions() async {
  Map<Permission, PermissionStatus> statuses = {};

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

  // Check each permission
  for (var permission in permissions) {
    statuses[permission] = await permission.status;
  }

  return statuses;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Longswipe Test App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Longswipe Test Application'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _responseMessage = '';
  String _responseMessageSuccess = '';
  Map<Permission, PermissionStatus> _permissionStatuses = {};

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final statuses = await checkPermissions();
    setState(() {
      _permissionStatuses = statuses;
    });
  }

  // Open app settings
  Future<void> _openAppSettings() async {
    await openAppSettings();
    // After returning from settings, check permissions again
    await Future.delayed(const Duration(seconds: 1));
    await _checkPermissions();
  }

  // Handle responses from the Longswipe widget
  void _handleLongswipeResponse(ResType type, dynamic data) {
    setState(() {
      switch (type) {
        case ResType.success:
          _responseMessageSuccess = 'Payment successful: ${data ?? 'No data'}';
          break;
        case ResType.error:
          _responseMessage = 'Error: ${data ?? 'Unknown error'}';
          break;
        case ResType.close:
          _responseMessage = 'Widget closed by user';
          break;
        case ResType.start:
          _responseMessage = 'Widget started';
          break;
        case ResType.loading:
          _responseMessage = 'Widget loading...';
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            Text(
              _responseMessageSuccess,
              style: TextStyle(
                color: _responseMessageSuccess.contains('Error') ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              _responseMessage,
              style: TextStyle(
                color: _responseMessage.contains('Error') ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            // Longswipe Widget Integration
            LongswipeWidget(
              apiKey: 'pk_live_ViHyq8ZyzPjZb3q0wC-IJeEhYwaoyA8bPUPb84DAUJ0=', // Replace with your actual API key
              referenceId: 'order_${DateTime.now().millisecondsSinceEpoch}',
              onResponse: _handleLongswipeResponse,
              defaultCurrency: Currency.NGN,
              environment: Environment.production,
              defaultAmount: 10.0,
              metaData: const {
                'userid':'343',
                'useremail':'O5N3S@example.com'
              },
              buttonText: 'Pay with Longswipe',
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: const Text(
                'You can provide your own custom button or any clickable widget:',
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: LongswipeWidget(
                apiKey: 'pk_live_ViHyq8ZyzPjZb3q0wC-IJeEhYwaoyA8bPUPb84DAUJ0=', // Replace with your API key
                referenceId: 'order_${DateTime.now().millisecondsSinceEpoch}',
                onResponse: _handleLongswipeResponse,
                defaultCurrency: Currency.USDT,
                environment: Environment.sandbox,
                defaultAmount: 100,
                metaData: const {
                  'userid':'343',
                  'useremail':'O5N3S@example.com',
                  'source':'flutter-sdk-custom-button',
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withValues(red: 0, green: 255, blue: 0, alpha: 0.3),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Text(
                    'Custom Payment Button',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],

        ),
      ),

    );
  }
}