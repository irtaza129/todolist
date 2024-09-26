import 'package:flutter/material.dart';

class TaskListPage extends StatefulWidget {
  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  List<Map<String, dynamic>> tasks = [
    {'title': 'Buy groceries', 'dueDate': '2024-09-25', 'completed': false},
    {'title': 'Doctor Appointment', 'dueDate': '2024-09-26', 'completed': true},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
        backgroundColor: Color(0xFF2196F3),  // Blue color for AppBar
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: Checkbox(
                  value: task['completed'],
                  activeColor: Color(0xFF8BC34A),  // Green color for completed
                  onChanged: (bool? value) {
                    setState(() {
                      task['completed'] = value!;
                    });
                  },
                ),
                title: Text(
                  task['title'],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: task['completed'] ? Colors.grey : Colors.black,
                    decoration: task['completed']
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                subtitle: Text(
                  'Due: ${task['dueDate']}',
                  style: TextStyle(
                    fontSize: 14,
                    color: task['completed'] ? Colors.grey : Colors.black54,
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.edit, color: Color(0xFF2196F3)),  // Blue edit icon
                  onPressed: () {
                    // Navigate to edit task page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddEditTaskPage(task: task)),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add new task page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEditTaskPage()),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Color(0xFF8BC34A),  // Green color for add button
      ),
    );
  }
}

class AddEditTaskPage extends StatefulWidget {
  final Map<String, dynamic>? task;

  AddEditTaskPage({this.task});

  @override
  _AddEditTaskPageState createState() => _AddEditTaskPageState();
}

class _AddEditTaskPageState extends State<AddEditTaskPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController dueDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      titleController.text = widget.task!['title'];
      dueDateController.text = widget.task!['dueDate'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
        backgroundColor: Color(0xFF2196F3),  // Blue color for AppBar
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Task Title',
                labelStyle: TextStyle(color: Color(0xFF2196F3)),  // Blue label text
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF2196F3)),
                  borderRadius: BorderRadius.circular(12),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: dueDateController,
              decoration: InputDecoration(
                labelText: 'Due Date',
                labelStyle: TextStyle(color: Color(0xFF2196F3)),  // Blue label text
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF2196F3)),
                  borderRadius: BorderRadius.circular(12),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onTap: () async {
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (selectedDate != null) {
                  dueDateController.text = selectedDate.toLocal().toString().split(' ')[0];
                }
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Save the task logic here
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF8BC34A),  // Green for save button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                'Save Task',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            )
          ],
        ),
      ),
    );
  }
}
