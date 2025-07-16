import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:longswipe/longswipe.dart';
import 'package:permission_handler/permission_handler.dart';
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

  // Form-related variables
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  double _paymentAmount = 10000.0; // Default amount
  bool _isValidAmount = true;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
    // Initialize with default amount
    _amountController.text = _paymentAmount.toString();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
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

  void _validateAndUpdateAmount(String value) {
    setState(() {
      if (value.isEmpty) {
        _paymentAmount = 0.0;
        _isValidAmount = false;
      } else {
        try {
          _paymentAmount = double.parse(value);
          _isValidAmount = _paymentAmount > 0;
        } catch (e) {
          _paymentAmount = 0.0;
          _isValidAmount = false;
        }
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Response Messages
              if (_responseMessageSuccess.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _responseMessageSuccess,
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

              if (_responseMessage.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: _responseMessage.contains('Error') ? Colors.red[50] : Colors.blue[50],
                    border: Border.all(
                        color: _responseMessage.contains('Error') ? Colors.red : Colors.blue
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _responseMessage,
                    style: TextStyle(
                      color: _responseMessage.contains('Error') ? Colors.red : Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

              // Dynamic Amount Form
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Payment Amount',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Amount Input Field
                      TextFormField(
                        controller: _amountController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                        ],
                        decoration: InputDecoration(
                          labelText: 'Amount ',
                          prefixText: ' ',
                          border: const OutlineInputBorder(),
                          hintText: 'Enter amount to pay',
                          suffixIcon: _isValidAmount
                              ? const Icon(Icons.check_circle, color: Colors.green)
                              : null,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an amount';
                          }
                          try {
                            double amount = double.parse(value);
                            if (amount <= 0) {
                              return 'Amount must be greater than 0';
                            }
                            if (amount > 1000000) {
                              return 'Amount cannot exceed ₦1,000,000';
                            }
                          } catch (e) {
                            return 'Please enter a valid amount';
                          }
                          return null;
                        },
                        onChanged: _validateAndUpdateAmount,
                      ),

                      const SizedBox(height: 16),

                      // Quick Amount Buttons
                      const Text(
                        'Quick Select:',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: [1000, 5000, 10000, 20000, 50000].map((amount) {
                          return ElevatedButton(
                            onPressed: () {
                              _amountController.text = amount.toString();
                              _validateAndUpdateAmount(amount.toString());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _paymentAmount == amount
                                  ? Colors.deepPurple
                                  : Colors.grey[300],
                              foregroundColor: _paymentAmount == amount
                                  ? Colors.white
                                  : Colors.black87,
                            ),
                            child: Text('${amount.toString()}'),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 16),

                      // Amount Display
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Amount to Pay:',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              '${_paymentAmount.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Dynamic Longswipe Widget (NGN)
              if (_isValidAmount)
                LongswipeWidget(
                  apiKey: 'pk_live_key_here', // Replace with your actual API key
                  referenceId: 'order_${DateTime.now().millisecondsSinceEpoch}',
                  onResponse: _handleLongswipeResponse,
                  defaultCurrency: Currency.NGN,
                  environment: Environment.production,
                  defaultAmount: _paymentAmount,
                  metaData: const {
                    'userid':'343',
                    'useremail':'O5N3S@example.com'
                  },
                  buttonText: 'Pay ${_paymentAmount.toStringAsFixed(2)} with Longswipe',
                )
              else
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Enter a valid amount to continue',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ),

              const SizedBox(height: 30),

              // Divider
              const Divider(thickness: 2),

              const SizedBox(height: 20),

              const Text(
                'Fixed Amount Examples:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'You can provide your own custom button or any clickable widget:',
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: LongswipeWidget(
                  apiKey: 'your_public_key',
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
                      'Custom Payment Button (USDT 100)',
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
      ),
    );
  }
}