import 'package:flutter/material.dart';
import '../widgets.dart/add_fab.dart';
import '../Presenters/course_presenter.dart';

class CourseListScreen extends StatefulWidget {
  const CourseListScreen({super.key});

  @override
  State<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  final CoursePresenter presenter = CoursePresenter();
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    await presenter.loadCourses();
    setState(() {
      isLoading = false;
    });
  }

  void _showAddCourseDialog() {
    String name = '';
    String description = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Course'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Course name'),
                onChanged: (value) => name = value,
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                ),
                onChanged: (value) => description = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (name.trim().isNotEmpty) {
                  setState(() {
                    presenter.addCourse(name, description);
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final courses = presenter.courses;

    return Scaffold(
      appBar: AppBar(title: const Text('Courses')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                return _CourseListTile(
                  course: course,
                  onDelete: () {
                    presenter.removeCourse(index);
                    setState(() {});
                  },
                );
              },
            ),
      floatingActionButton: AddFAB(
        onPressed: _showAddCourseDialog,
      ),
    );
  }
}

class _CourseListTile extends StatelessWidget {
  final dynamic course;
  final VoidCallback onDelete;

  const _CourseListTile({
    required this.course,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(course.name),
      subtitle: course.description != null ? Text(course.description!) : null,
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline),
        onPressed: onDelete,
      ),
    );
  }
}
