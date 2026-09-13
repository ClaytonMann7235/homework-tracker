
import 'package:flutter/material.dart';

class AssignmentListScreen extends StatefulWidget {
  const AssignmentListScreen({super.key});

  @override
  State<AssignmentListScreen> createState() => _AssignmentListScreenState();
}
class _AssignmentListScreenState extends State<AssignmentListScreen> {
  final List<Map<String,dynamic>> assignments = [];

void showAddAssignmentDialog() {
  String newassignmenttitle = '';
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Add Assignment'),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Enter assignment title'),  
          onChanged: (value) {
            newassignmenttitle = value;
          },
      
        ),
        actions: [
          TextButton( 
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: (  ) {
              if (newassignmenttitle.isNotEmpty) {
                setState(() {
                  assignments.add({'title': newassignmenttitle, 'completed': false});
                });
                Navigator.of(context).pop();
              }
            },
            child: const Text('Add'),
          ),
        ],
      );
    },
  );
}
void toggleCompleted(int index,bool? value){
  setState(() {
    assignments[index]['completed'] = value ?? false;
  });
}
void deleteAssignment(int index) {
  setState(() {
    assignments.removeAt(index);
  });
}
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Assignments'),
    ),
    body: ListView.builder(
      itemCount: assignments.length,
      itemBuilder: (context, index) {
        return CheckboxListTile(
          title: Text(assignments[index]['title']),
          value: assignments[index]['completed'],
          onChanged: (value) {
            toggleCompleted(index, value);
          },
          secondary: IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Delete assignment',
            onPressed: () => deleteAssignment(index),
          ),
        );
      },
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: showAddAssignmentDialog,
      child: const Icon(Icons.add),
    ),
  );
}
}