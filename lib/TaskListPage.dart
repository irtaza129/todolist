import 'package:flutter/material.dart';

class TaskListPage extends StatefulWidget {
  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  List<Map<String, dynamic>> tasks = [
    {'title': 'Buy groceries', 'dueDate': '2024-09-25', 'completed': false, 'priority': 'High', 'archived': false},
    {'title': 'Doctor Appointment', 'dueDate': '2024-09-26', 'completed': true, 'priority': 'Low', 'archived': false},
  ];

  String filter = 'All'; // To hold the filter value

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredTasks = tasks.where((task) {
      if (filter == 'All') return !task['archived'];
      if (filter == 'Completed') return task['completed'] && !task['archived'];
      if (filter == 'Incomplete') return !task['completed'] && !task['archived'];
      if (filter == 'High Priority') return task['priority'] == 'High' && !task['archived'];
      return !task['archived'];
    }).toList();

    return Scaffold(
      backgroundColor: Color(0xFFF8F9FC),
      appBar: AppBar(
        title: Text('To-Do List'),
        backgroundColor: Color(0xFF2196F3),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                filter = value;
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'All', child: Text('All Tasks')),
              PopupMenuItem(value: 'Completed', child: Text('Completed Tasks')),
              PopupMenuItem(value: 'Incomplete', child: Text('Incomplete Tasks')),
              PopupMenuItem(value: 'High Priority', child: Text('High Priority')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: filteredTasks.length,
                itemBuilder: (context, index) {
                  final task = filteredTasks[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Checkbox(
                        value: task['completed'],
                        activeColor: Color(0xFF8BC34A),
                        onChanged: (bool? value) {
                          setState(() {
                            task['completed'] = value!;
                          });
                        },
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              task['title'],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: task['completed'] ? Colors.grey : Colors.black,
                                decoration: task['completed']
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            task['priority'],
                            style: TextStyle(
                              color: task['priority'] == 'High'
                                  ? Colors.red
                                  : task['priority'] == 'Medium'
                                      ? Colors.orange
                                      : Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Text(
                        'Due: ${task['dueDate']}',
                        style: TextStyle(
                          fontSize: 14,
                          color: task['completed'] ? Colors.grey : Colors.black54,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.archive, color: Colors.grey),
                            onPressed: () {
                              setState(() {
                                task['archived'] = true;
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.edit, color: Color(0xFF2196F3)),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => AddEditTaskPage(task: task)),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddEditTaskPage()),
                );
              },
              backgroundColor: Color(0xFF8BC34A),
              label: Text('Add Task', style: TextStyle(color: Colors.white)),
              icon: Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
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
  String selectedPriority = 'Medium';  // Default priority

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      titleController.text = widget.task!['title'];
      dueDateController.text = widget.task!['dueDate'];
      selectedPriority = widget.task!['priority'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FC),
      appBar: AppBar(
        title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
        backgroundColor: Color(0xFF2196F3),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Task Title',
                labelStyle: TextStyle(color: Color(0xFF2196F3)),
                filled: true,
                fillColor: Colors.white,
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
                labelStyle: TextStyle(color: Color(0xFF2196F3)),
                filled: true,
                fillColor: Colors.white,
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
            DropdownButtonFormField<String>(
              value: selectedPriority,
              onChanged: (String? newValue) {
                setState(() {
                  selectedPriority = newValue!;
                });
              },
              items: ['High', 'Medium', 'Low'].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Priority',
                labelStyle: TextStyle(color: Color(0xFF2196F3)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF8BC34A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                'Save Task',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
