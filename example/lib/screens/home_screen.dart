import 'package:flutter/material.dart';
import 'basic_example_screen.dart';
import 'pay_with_longswipe_checkout_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Longswipe Payment Demo'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCard(
            context,
            'Pay With Longswipe Checkout Widget',
            'Pay with Longswipe Detailed Checkout Flow',
            () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => PayWithLongswipeCheckoutScreen()),
            ),
          ),
          const SizedBox(height: 16),
          _buildCard(
            context,
            'Basic Usage',
            'Basic implementation with LongswipeClient',
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => BasicExample()),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildCard(
    BuildContext context,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
