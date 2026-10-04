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
  Future<void> addAssignments(String title) async {
    final newAssignment = Assignment(title: title);
    await Assignment.addAssignment(newAssignment);
    _assignments.add(newAssignment);
  }

  Future<void> toggleCompleted(int index) async {
    if (index < 0 || index >= _assignments.length) return;

    await Assignment.updateCompletionStatus(index, _assignments);
    _assignments[index].isCompleted = !_assignments[index].isCompleted;
  }
  

}