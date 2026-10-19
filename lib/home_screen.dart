import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../Presenters/assignment_presenter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AssignmentPresenter _assignmentPresenter = AssignmentPresenter();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadAssignments();
  }

  Future<void> _loadAssignments() async {
    await _assignmentPresenter.loadAssignments();
    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final percent = _assignmentPresenter.completionRatio;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Homework Tracker'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  Center(
                    child: CircularPercentIndicator(
                      radius: 120.0,
                      lineWidth: 14.0,
                      percent: percent,
                      center: Text(
                        '${(percent * 100).round()}%',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      progressColor: Colors.purple,
                      backgroundColor: Colors.grey.shade300,
                      animation: true,
                      animationDuration: 800,
                      footer: Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          '${_assignmentPresenter.completedAssignments} of ${_assignmentPresenter.totalAssignments} assignments completed',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Card(
                    child: ListTile(
                      title: const Text('View Assignments'),
                      trailing: Text('${_assignmentPresenter.totalAssignments}'),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: const Text('Completed Assignments'),
                      trailing: Text('${_assignmentPresenter.completedAssignments}'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}