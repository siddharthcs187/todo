import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../db/tasks_database.dart';
import '../model/task.dart';

final lightColors = [
  Colors.amber.shade300,
  Colors.lightGreen.shade300,
  Colors.lightBlue.shade300,
  Colors.orange.shade300,
  Colors.pinkAccent.shade100,
  Colors.tealAccent.shade100
];

class TaskCardWidget extends StatefulWidget {
  TaskCardWidget({
    Key? key,
    required this.task,
    required this.index, required this.onTaskUpdated,
  }) : super(key: key);

  final Task task;
  final int index;
  final Function(Task) onTaskUpdated;

  @override
  State<TaskCardWidget> createState() => _TaskCardWidgetState();
}

class _TaskCardWidgetState extends State<TaskCardWidget> {
  @override
  Widget build(BuildContext context) {
    final color = lightColors[widget.index % lightColors.length];
    final minHeight = getMinHeight(widget.index);

    return Card(
      color: color,
      child: Stack(
        children:[Container(
          constraints: BoxConstraints(minHeight: minHeight),
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4),
              Text(
                widget.task.title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
          Positioned(
            bottom: 8,
            right: 8,
            child: Checkbox(
              value: widget.task.isChecked,
              onChanged: (bool? value) {
                updateTask();
                setState(() {
                  value = value;
                });
              },
            ),
          ),
    ],
      ),

    );
  }

  double getMinHeight(int index) {
    switch (index % 4) {
      case 0:
        return 100;
      case 1:
        return 150;
      case 2:
        return 150;
      case 3:
        return 100;
      default:
        return 100;
    }
  }

  Future updateTask() async {
    final task = widget.task!.copy(
      isChecked: widget.task.isChecked?false:true,
      title: widget.task.title,
      description: widget.task.description,
    );
    print(task.isChecked);
    await TasksDatabase.instance.update(task);
    widget.onTaskUpdated(task);
    setState(() {});

  }
}