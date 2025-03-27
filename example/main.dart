import 'package:flutter/material.dart';
import 'package:longswipe_flutter/longswipe_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Longswipe Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _status = '';
  dynamic _result;

  void _handleResponse(ResType type, dynamic data) {
    setState(() {
      _status = type.toValue();
      if (data != null) {
        _result = data;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Longswipe Flutter Demo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Longswipe Widget Demo',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            
            // Status and result display
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Status: $_status'),
                    const SizedBox(height: 10),
                    if (_result != null) ...[
                      const Text('Result:'),
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _result.toString(),
                          style: const TextStyle(fontFamily: 'monospace'),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            
            // Widget approach section
            const Text(
              'Widget Approach',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'The widget provides a default button if no children are provided:',
            ),
            const SizedBox(height: 10),
            Center(
              child: LongswipeWidget(
                apiKey: 'your_api_key_here', // Replace with your API key
                referenceId: 'flutter-sdk-demo-default',
                onResponse: _handleResponse,
                defaultCurrency: Currency.NGN,
                defaultAmount: 100,
                metaData: {'source': 'flutter-sdk-demo-default'},
                buttonText: 'Pay with Longswipe',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'You can provide your own custom button or any clickable widget:',
            ),
            const SizedBox(height: 10),
            Center(
              child: LongswipeWidget(
                apiKey: 'your_api_key_here', // Replace with your API key
                referenceId: 'flutter-sdk-demo-custom',
                onResponse: _handleResponse,
                defaultCurrency: Currency.USDT,
                defaultAmount: 100,
                metaData: {'source': 'flutter-sdk-demo-custom'},
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
                        color: Colors.green.withOpacity(0.3),
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
            
            // Controller approach section
            const Text(
              'Controller Approach',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'For more control, use the LongswipeController:',
            ),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ControllerDemoPage(),
                    ),
                  );
                },
                child: const Text('Go to Controller Demo'),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Note: This example demonstrates both approaches. In a real app, you would typically choose one approach based on your needs.',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ControllerDemoPage extends StatefulWidget {
  const ControllerDemoPage({Key? key}) : super(key: key);

  @override
  State<ControllerDemoPage> createState() => _ControllerDemoPageState();
}

class _ControllerDemoPageState extends State<ControllerDemoPage> {
  late LongswipeController _controller;
  String _status = '';
  dynamic _result;

  @override
  void initState() {
    super.initState();
    _controller = LongswipeController(
      options: LongswipeControllerOptions(
        apiKey: 'your_api_key_here', // Replace with your API key
        referenceId: 'flutter-sdk-controller-demo',
        defaultCurrency: Currency.USDT,
        defaultAmount: 100,
        metaData: {'source': 'flutter-sdk-controller-demo'},
        onResponse: _handleResponse,
      ),
    );
    
    // Load the script
    _controller.loadScript();
  }

  void _handleResponse(ResType type, dynamic data) {
    setState(() {
      _status = type.toValue();
      if (data != null) {
        _result = data;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Controller Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Longswipe Controller Demo',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            
            // Status and result display
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Status: $_status'),
                    const SizedBox(height: 10),
                    if (_result != null) ...[
                      const Text('Result:'),
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _result.toString(),
                          style: const TextStyle(fontFamily: 'monospace'),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            
            // Controller actions
            const Text(
              'Controller Actions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _controller.isLoaded ? _openPaymentModal : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  child: const Text('Open Payment Modal'),
                ),
                const SizedBox(width: 16),
                OutlinedButton(
                  onPressed: _controller.loadScript,
                  child: const Text('Reload Script'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'Script loaded: ${_controller.isLoaded ? 'Yes' : 'No'}',
                style: TextStyle(
                  fontSize: 14,
                  color: _controller.isLoaded ? Colors.green : Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 30),
            
            // Code example
            const Text(
              'Code Example',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '''
// Initialize controller
final controller = LongswipeController(
  options: LongswipeControllerOptions(
    apiKey: 'your_api_key_here',
    referenceId: 'unique-reference-id',
    onResponse: (type, data) {
      // Handle response
    },
    defaultCurrency: Currency.USDT,
    defaultAmount: 100,
  ),
);

// Load the script
controller.loadScript();

// Later in your code
ElevatedButton(
  onPressed: controller.isLoaded ? controller.openModal : null,
  child: Text('Open Payment'),
)
''',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openPaymentModal() async {
    await _controller.openModal();
  }
}
