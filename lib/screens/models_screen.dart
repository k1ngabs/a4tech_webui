import 'package:a4tech_webui/models/model_model.dart';
import 'package:a4tech_webui/providers/model_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ModelsScreen extends StatelessWidget {
  const ModelsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ModelProvider>(
        builder: (context, modelProvider, child) {
          if (modelProvider.isLoading && modelProvider.models.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (modelProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${modelProvider.error}',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => modelProvider.fetchModels(),
                    child: const Text('Retry'),
                  )
                ],
              ),
            );
          }

          if (modelProvider.models.isEmpty) {
            return const Center(child: Text('No local models found.'));
          }

          return RefreshIndicator(
            onRefresh: () => modelProvider.fetchModels(),
            child: ListView.builder(
              itemCount: modelProvider.models.length,
              itemBuilder: (context, index) {
                final model = modelProvider.models[index];
                return ListTile(
                  leading: const Icon(Icons.computer),
                  title: Text(model.name),
                  subtitle: Text('Size: ${(model.size / 1e9).toStringAsFixed(2)} GB'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    tooltip: 'Delete Model',
                    onPressed: () => _showDeleteConfirmDialog(context, model, modelProvider),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _showDeleteConfirmDialog(BuildContext context, OllamaModel model, ModelProvider provider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Model'),
          content: Text('Are you sure you want to delete the model "${model.name}"?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete', style: TextStyle(color: Theme.of(context).colorScheme.error)),
              onPressed: () {
                provider.deleteModel(model.name);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
