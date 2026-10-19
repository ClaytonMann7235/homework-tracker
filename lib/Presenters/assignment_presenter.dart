import '../Models/assignment_model.dart';

class AssignmentPresenter {
  final List<Assignment> _assignments = [];

  List<Assignment> get assignments => _assignments;

  Future<void> loadAssignments() async {
    final fetched = await Assignment.fetchAssignments();
    _assignments
      ..clear()
      ..addAll(fetched);
  }
  Future<void> addAssignments(String title, String coursename) async {
    
    await Assignment.addAssignment(title, coursename);
    _assignments.add(Assignment(title: title, courseName: coursename));
  }

  Future<void> toggleCompleted(int index) async {
    if (index < 0 || index >= _assignments.length) return;

    await Assignment.updateCompletionStatus(index, _assignments);
    _assignments[index].isCompleted = !_assignments[index].isCompleted;
  }
  
  int get totalAssignments => _assignments.length;

  int get completedAssignments => _assignments.where((assignment) => assignment.isCompleted).length;

  double get completionRatio => totalAssignments == 0 ? 0 : completedAssignments / totalAssignments;

}