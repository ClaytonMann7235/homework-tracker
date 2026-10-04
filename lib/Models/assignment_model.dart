import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class Assignment {
  final String title;
  bool isCompleted;
  Assignment({required this.title, this.isCompleted = false});

  static final _db = FirebaseDatabase.instance.ref();
  static final _auth = FirebaseAuth.instance;

  static Future<List<Assignment>> fetchAssignments() async {
    final userID = _auth.currentUser?.uid;
    if (userID == null) return [];

    final snapshot = await _db.child('assignments').child(userID).get();
    final List<Assignment> assignments = [];

    if (snapshot.exists && snapshot.value is Map) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      data.forEach((key, value) {
        if (value is Map) {
          assignments.add(Assignment(
            title: value['title']?.toString() ?? '',
            isCompleted: value['isCompleted'] == true,
          ));
        }
      });
    }

    return assignments;
  }

  static Future<void> addAssignment(Assignment assignment) async {
    final userID = _auth.currentUser?.uid;
    if (userID == null) return;

    final newRef = _db.child('assignments').child(userID).push();
    await newRef.set({
      'title': assignment.title,
      'isCompleted': assignment.isCompleted,
    });
  }

  static Future<void> updateCompletionStatus(int index, List<Assignment> currentAssignments) async {
    final userID = _auth.currentUser?.uid;
    if (userID == null || index < 0 || index >= currentAssignments.length) return;

    final snapshot = await _db.child('assignments').child(userID).get();
    if (!snapshot.exists || snapshot.value is! Map) return;

    final data = Map<String, dynamic>.from(snapshot.value as Map);
    final entry = data.entries.elementAt(index);
    final ref = _db.child('assignments').child(userID).child(entry.key);
    final updatedStatus = !currentAssignments[index].isCompleted;
    await ref.update({'isCompleted': updatedStatus});
  }

}