import 'package:flutter_test/flutter_test.dart';
import 'package:homework_tracker/Models/course_model.dart';

void main(){
  test('Course model stores name and optional description', (){
    final course = Course(name: 'Test Course', description: 'Test Description');
    expect(course.name, 'Test Course');
    expect(course.description, 'Test Description');
  });
  test("Course model handles null description", () {
    final course = Course(name: 'Test Course');
    expect(course.name, 'Test Course');
    expect(course.description, null);
  });
}