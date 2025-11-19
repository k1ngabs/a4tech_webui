import 'package:a4tech_webui/providers/system_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildSectionTitle(context, 'Appearance'),
            _buildThemeSelector(context),
            const Divider(),
            _buildSectionTitle(context, 'Service Management'),
            _buildServiceController(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  Widget _buildThemeSelector(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return ListTile(
          title: const Text('Theme'),
          trailing: DropdownButton<ThemeMode>(
            value: themeProvider.themeMode,
            onChanged: (ThemeMode? newValue) {
              if (newValue != null) {
                themeProvider.setThemeMode(newValue);
              }
            },
            items: const [
              DropdownMenuItem(
                value: ThemeMode.system,
                child: Text('System'),
              ),
              DropdownMenuItem(
                value: ThemeMode.light,
                child: Text('Light'),
              ),
              DropdownMenuItem(
                value: ThemeMode.dark,
                child: Text('Dark'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildServiceController(BuildContext context) {
    return Consumer<SystemProvider>(
      builder: (context, systemProvider, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Ollama Service Status'),
                    Row(
                      children: [
                        Text(systemProvider.status.name.toUpperCase()),
                        const SizedBox(width: 8),
                        _buildStatusIndicator(systemProvider.status),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (systemProvider.status == ServiceStatus.loading)
                  const CircularProgressIndicator(),
                if (systemProvider.status != ServiceStatus.loading)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: systemProvider.status == ServiceStatus.running
                            ? null
                            : () => systemProvider.startService(),
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Start'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      ),
                      ElevatedButton.icon(
                        onPressed: systemProvider.status == ServiceStatus.stopped
                            ? null
                            : () => systemProvider.stopService(),
                        icon: const Icon(Icons.stop),
                        label: const Text('Stop'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      ),
                    ],
                  ),
                if(systemProvider.error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text('Error: ${systemProvider.error}', style: TextStyle(color: Theme.of(context).colorScheme.error)),
                  )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusIndicator(ServiceStatus status) {
    Color color;
    switch (status) {
      case ServiceStatus.running:
        color = Colors.green;
        break;
      case ServiceStatus.stopped:
        color = Colors.red;
        break;
      case ServiceStatus.loading:
        color = Colors.orange;
        break;
      case ServiceStatus.error:
        color = Colors.grey;
        break;
    }
    return Icon(Icons.circle, color: color, size: 16);
  }
}