import 'package:flutter_test/flutter_test.dart';
import 'package:homework_tracker/Models/assignment_model.dart';

void main() {
  test('preserves an explicitly completed state', () {
    final assignment = Assignment(
      title: 'Read chapter 4',
      courseName: 'Biology',
      isCompleted: true,
    );

    expect(assignment.isCompleted, isTrue);
  });

  test('allows the completion state to be changed', () {
    final assignment = Assignment(
      title: 'Read chapter 4',
      courseName: 'Biology',
    );

    assignment.isCompleted = true;
    expect(assignment.isCompleted, isTrue);

    assignment.isCompleted = false;
    expect(assignment.isCompleted, isFalse);
  });

  test('keeps completion states independent between assignments', () {
    final completedAssignment = Assignment(
      title: 'Read chapter 4',
      courseName: 'Biology',
      isCompleted: true,
    );
    final pendingAssignment = Assignment(
      title: 'Finish worksheet',
      courseName: 'Chemistry',
    );

    completedAssignment.isCompleted = false;

    expect(pendingAssignment.isCompleted, isFalse);
  });
}
