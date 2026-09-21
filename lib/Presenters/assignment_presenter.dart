import '../Models/assignment_model.dart';

class AssignmentPresenter {
  final List<Assignment> _assignments = [];

  List<Assignment> get assignments => _assignments;

  void addAssignment(String title) {
    final trimmedTitle = title.trim();
    if (trimmedTitle.isEmpty) return;
    _assignments.add(Assignment(title: trimmedTitle));
  }

  void toggleCompleted(int index) {
    if (index >= 0 && index < _assignments.length) {
      _assignments[index].isCompleted = !_assignments[index].isCompleted;
    }
  }

  void deleteAssignment(int index) {
    if (index >= 0 && index < _assignments.length) {
      _assignments.removeAt(index);
    }
  }

  void deleteAllAssignments() {
    _assignments.clear();
  }
}