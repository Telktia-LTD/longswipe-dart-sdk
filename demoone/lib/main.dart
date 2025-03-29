import 'package:flutter/material.dart';
import 'package:longswipe_flutter/longswipe_flutter.dart';
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
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
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

  void _incrementCounter() {
    setState(() {
      _counter++;
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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
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
              environment: Environment.sandbox,
              defaultAmount: 10.0,
              metaData: const {'userid':'343', 'useremail':'O5N3S@example.com'},
              buttonText: 'Pay with Longswipe',
              buttonStyle: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
              const SizedBox(height: 20),
            const Text(
              'You can provide your own custom button or any clickable widget:',
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
                  metaData: const {'userid':'343', 'useremail':'O5N3S@example.com', 'source':'flutter-sdk-custom-button'},
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
            
          ],
          
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
