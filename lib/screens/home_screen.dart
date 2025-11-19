import 'package:a4tech_webui/providers/model_provider.dart';
import 'package:a4tech_webui/screens/note_editor_screen.dart';
import 'package:flutter/material.dart';
import 'package:a4tech_webui/screens/chat_screen.dart';
import 'package:a4tech_webui/screens/models_screen.dart';
import 'package:a4tech_webui/screens/notes_screen.dart';
import 'package:a4tech_webui/screens/settings_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    ChatScreen(),
    ModelsScreen(),
    NotesScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('4Tech WebUI'),
        bottom: Provider.of<ModelProvider>(context).isDownloading
            ? PreferredSize(
                preferredSize: const Size.fromHeight(24.0),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    Provider.of<ModelProvider>(context).downloadStatus,
                    style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ),
              )
            : null,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      floatingActionButton: _buildFloatingActionButton(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.model_training),
            label: 'Models',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note),
            label: 'Notes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget? _buildFloatingActionButton() {
    if (_selectedIndex == 1) {
      return FloatingActionButton(
        onPressed: () => _showAddModelDialog(context),
        child: const Icon(Icons.add),
        tooltip: 'Add Model',
      );
    } else if (_selectedIndex == 2) {
      return FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const NoteEditorScreen()),
          );
        },
        child: const Icon(Icons.add_comment),
        tooltip: 'New Note',
      );
    }
    return null;
  }

  void _showAddModelDialog(BuildContext context) {
    final TextEditingController modelNameController = TextEditingController();
    final modelProvider = Provider.of<ModelProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Model'),
          content: TextField(
            controller: modelNameController,
            decoration: const InputDecoration(hintText: "Enter model name (e.g., 'llama3')"),
            autofocus: true,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                if (modelNameController.text.isNotEmpty) {
                  modelProvider.pullModel(modelNameController.text);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
