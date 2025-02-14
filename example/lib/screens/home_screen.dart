import 'package:flutter/material.dart';

import 'basic_example_screen.dart';
import 'custom_theme_example_screen.dart';
import 'custom_ui_example_screen.dart';
import 'default_ui_example_screen.dart';

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
            'Basic Usage',
            'Basic implementation with LongswipeClient',
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => BasicExample()),
            ),
          ),
          const SizedBox(height: 16),
          _buildCard(
            context,
            'Default UI',
            'Basic implementation with default styling',
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DefaultUIExample()),
            ),
          ),
          const SizedBox(height: 16),
          _buildCard(
            context,
            'Custom Theme',
            'Default UI with custom styling',
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CustomThemeExample()),
            ),
          ),
          const SizedBox(height: 16),
          _buildCard(
            context,
            'Custom UI',
            'Fully customized UI implementation',
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CustomUIExample()),
            ),
          ),
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
