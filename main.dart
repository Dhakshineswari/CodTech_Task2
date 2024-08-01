import 'package:flutter/material.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vibrant Todo App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          primary: Colors.teal,
          secondary: Colors.orangeAccent,
        ),
        scaffoldBackgroundColor:
            Colors.teal[50], // Background color for the entire app
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TodoList(),
    );
  }
}

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final List<TodoItem> _todoItems = [];

  void _addTodoItem(String task) {
    if (task.isNotEmpty) {
      setState(() {
        _todoItems.add(TodoItem(task: task));
      });
    }
  }

  void _deleteTodoItem(TodoItem item) {
    setState(() {
      _todoItems.remove(item);
    });
  }

  void _toggleTodoItem(TodoItem item) {
    setState(() {
      item.completed = !item.completed;
    });
  }

  void _promptAddTodoItem() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddTodoDialog(addTodoItem: _addTodoItem);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vibrant Todo App'),
      ),
      body: ListView(
        children: _todoItems.map((item) => _buildTodoItem(item)).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _promptAddTodoItem,
        tooltip: 'Add task',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildTodoItem(TodoItem item) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        tileColor: item.completed ? Color(0xff191b1b) : Colors.white,
        title: Text(
          item.task,
          style: TextStyle(
            decoration: item.completed ? TextDecoration.lineThrough : null,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: item.completed ? Colors.teal : Colors.black,
          ),
        ),
        leading: Icon(
          item.completed ? Icons.check_circle : Icons.radio_button_unchecked,
          color: item.completed ? Colors.teal : Colors.grey,
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () => _deleteTodoItem(item),
        ),
        onTap: () => _toggleTodoItem(item),
      ),
    );
  }
}

class TodoItem {
  final String task;
  bool completed;

  TodoItem({required this.task, this.completed = false});
}

class AddTodoDialog extends StatefulWidget {
  final Function(String) addTodoItem;

  AddTodoDialog({required this.addTodoItem});

  @override
  _AddTodoDialogState createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends State<AddTodoDialog> {
  final _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add a new task'),
      backgroundColor: Colors.teal[50], // Background color for the dialog
      content: TextField(
        controller: _textFieldController,
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'Enter your task here',
        ),
        onSubmitted: _handleSubmitted,
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal, // Background color
            foregroundColor: Colors.white, // Text color
          ),
          child: Text('Add'),
          onPressed: () {
            _handleSubmitted(_textFieldController.text);
          },
        ),
      ],
    );
  }

  void _handleSubmitted(String task) {
    widget.addTodoItem(task);
    Navigator.of(context).pop();
  }
}
