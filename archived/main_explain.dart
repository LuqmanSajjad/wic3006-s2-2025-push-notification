// Importing the Flutter material package which provides UI components and themes.
import 'package:flutter/material.dart';

// The main() function is the entry point of every Dart/Flutter app.
void main() {
  // runApp() tells Flutter to draw the UI starting from the MyApp widget.
  runApp(const MyApp());
}

// This is the root widget of your application.
// StatelessWidget means it doesn’t hold or change any state.
class MyApp extends StatelessWidget {
  // Constructor with a `key` for widget identity tracking
  const MyApp({super.key});

  // The build() method describes how to display this widget.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Title of the app (used in Android task switcher)
      title: 'Simple To-Do App',
      // Theme of the app; here it's using a blue primary color
      theme: ThemeData(primarySwatch: Colors.blue),
      // The widget that will be displayed as the home screen
      home: const TodoHomePage(),
    );
  }
}

// This is a StatefulWidget because the list of tasks will change over time.
class TodoHomePage extends StatefulWidget {
  const TodoHomePage({super.key});

  // Creates the mutable state for this widget.
  @override
  State<TodoHomePage> createState() => _TodoHomePageState();
}

// The state class associated with TodoHomePage
class _TodoHomePageState extends State<TodoHomePage> {
  // A list to hold the tasks entered by the user.
  final List<String> _tasks = [];

  // A controller to read and manipulate the text input field.
  final TextEditingController _controller = TextEditingController();

  // Method to add a new task from the input field
  void _addTask() {
    // Get the trimmed text from the controller
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      // Update the UI state to add the new task
      setState(() {
        _tasks.add(text);       // Add task to the list
        _controller.clear();    // Clear the text field
      });
    }
  }

  // Method to remove a task by its index
  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);   // Remove task from the list
    });
  }

  // This method builds the visual layout of the home screen.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar with title
      appBar: AppBar(title: const Text('To-Do List')),
      // Body of the screen laid out in a column
      body: Column(
        children: [
          // Padding around the input row
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // TextField expands to take all available space
                Expanded(
                  child: TextField(
                    controller: _controller, // Connect controller to get user input
                    decoration: const InputDecoration(
                      labelText: 'New Task',         // Placeholder/label
                      border: OutlineInputBorder(),  // Adds a border
                    ),
                  ),
                ),
                // Space between TextField and button
                const SizedBox(width: 8),
                // Add button
                ElevatedButton(
                  onPressed: _addTask,               // Calls _addTask on click
                  child: const Text('Add'),          // Button label
                ),
              ],
            ),
          ),
          // Expanded widget to take up remaining vertical space
          Expanded(
            // ListView.builder dynamically builds the list of tasks
            child: ListView.builder(
              itemCount: _tasks.length, // Number of items in the list
              itemBuilder: (context, index) => ListTile(
                title: Text(_tasks[index]), // Display the task text
                trailing: IconButton(
                  icon: const Icon(Icons.delete),          // Delete icon
                  onPressed: () => _removeTask(index),     // Deletes the selected task
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
