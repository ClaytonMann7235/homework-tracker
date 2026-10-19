import 'package:flutter_test/flutter_test.dart';
import 'package:homework_tracker/Models/assignment_model.dart';

void main(){

  test('New Assignment should default to isCompleted = false',(){
    final assignment = Assignment(title: 'Test Assignment', courseName: 'Test Course');
    expect(assignment.isCompleted, false);
  });

  test('Assignment should store title and course correctly',(){
    final assignment = Assignment(title: 'Test Assignment', courseName: 'Test Course');
    expect(assignment.title, 'Test Assignment');
    expect(assignment.courseName, 'Test Course');
  });
}