import 'package:flutter/material.dart';
import '../Presenters/course_presenter.dart';
import '../Presenters/assignment_presenter.dart';
import '../widgets.dart/add_fab.dart';

class AssignmentListScreen extends StatefulWidget {
  const AssignmentListScreen({super.key});

  @override
  State<AssignmentListScreen> createState() => _AssignmentListScreenState();
}

class _AssignmentListScreenState extends State<AssignmentListScreen> {
  final AssignmentPresenter _presenter = AssignmentPresenter();
  final CoursePresenter _coursePresenter = CoursePresenter();

  bool isLoading = true;
  String? _selectedCourseFilter;
  String _assignmentStatusFilter = 'all';
  String? _newAssignmentCourse;
  List<String> _courses = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _presenter.loadAssignments();
    await _coursePresenter.loadCourses();
    setState(() {
      isLoading = false;
      _courses = _coursePresenter.courses.map((c) => c.name).toList();
    });
  }

  void showAddAssignmentDialog() {
    String newAssignmentTitle = '';
    _newAssignmentCourse = _courses.isNotEmpty ? _courses.first : null;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Assignment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children:[
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Enter assignment title',
                ),
                onChanged: (value) => newAssignmentTitle = value,
              ),
              const SizedBox(height: 12),
              DropdownButton<String>(
                value: _newAssignmentCourse,
                items: _courses.map((name) {
                  return DropdownMenuItem<String>(
                    value: name,
                    child: Text(name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _newAssignmentCourse = value;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (newAssignmentTitle.trim().isNotEmpty) {
                  await _presenter.addAssignments(newAssignmentTitle, _newAssignmentCourse!);
                  setState(() {});
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

  Future<void> deleteAllAssignments() async {
    if (_presenter.assignments.isEmpty) return;

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete all assignments?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete all'),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      setState(() {
        _presenter.assignments.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final assignments = _presenter.assignments;
    final displayedAssignments = assignments.where((assignment) {
      final matchesCourse = _selectedCourseFilter == null ||
          assignment.courseName == _selectedCourseFilter;

      final matchesStatus = switch (_assignmentStatusFilter) {
        'completed' => assignment.isCompleted,
        'incomplete' => !assignment.isCompleted,
        _ => true,
      };

      return matchesCourse && matchesStatus;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignments'),
        actions: [
          if (_courses.isNotEmpty)
            DropdownButton<String?>(
              hint: const Text(
                'Filter by course',
                style: TextStyle(color: Colors.white),
              ),
              dropdownColor: Colors.blue[100],
              value: _selectedCourseFilter,
              onChanged: (value) {
                setState(() {
                  _selectedCourseFilter = value;
                });
              },
              items: [
                const DropdownMenuItem<String?>(
                  value: null,
                  child: Text('All Courses'),
                ),
                ..._courses.map(
                  (name) => DropdownMenuItem<String?>(
                    value: name,
                    child: Text(name),
                  ),
                ),
              ],
            ),
          DropdownButton<String>(
            value: _assignmentStatusFilter,
            dropdownColor: Colors.blue[100],
            onChanged: (value) {
              if (value == null) return;
              setState(() {
                _assignmentStatusFilter = value;
              });
            },
            items: const [
              DropdownMenuItem(value: 'all', child: Text('All')),
              DropdownMenuItem(value: 'completed', child: Text('Completed')),
              DropdownMenuItem(value: 'incomplete', child: Text('Incomplete')),
            ],
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: displayedAssignments.length,
              itemBuilder: (context, index) {
                final assignment = displayedAssignments[index];
                final realIndex = assignments.indexOf(assignment);

                return CheckboxListTile(
                  title: Text(assignment.title),
                  subtitle: Text('Course: ${assignment.courseName}'),
                  value: assignment.isCompleted,
                  onChanged: (_) async {
                    if (realIndex != -1) {
                      await _presenter.toggleCompleted(realIndex);
                      setState(() {});
                    }
                  },
                );
              },
            ),
      floatingActionButton: AddFAB(
        onPressed: showAddAssignmentDialog,
      ),
    );
  }
}
