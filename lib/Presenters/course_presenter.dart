import '../Models/course_model.dart';

class CoursePresenter {
  final List<Course> _courses = [];

  List<Course> get courses => _courses;

  void addCourse(String name, [String? description]) {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) return;

    _courses.add(
      Course(
        name: trimmedName,
        description: description?.trim().isEmpty == true ? null : description?.trim(),
      ),
    );
  }
}