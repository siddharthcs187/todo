import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:todo_app/db/tasks_database.dart';
import 'package:todo_app/screens/tasks_detail_page.dart';

import '../model/task.dart';
import '../widgets/task_card_widget.dart';
import 'add_edit_task_page.dart';

class TasksPage extends StatefulWidget {
  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  late List<Task> tasks;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshTasks();
  }

  @override
  void dispose() {
    TasksDatabase.instance.close();

    super.dispose();
  }

  Future refreshTasks() async {
    setState(() => isLoading = true);

    this.tasks = await TasksDatabase.instance.readAllTasks();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text("TODO APP"),
    ),
    body: SafeArea(
      child: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : tasks.isEmpty
            ? const Text(
          'No Tasks',
          style: TextStyle(color: Colors.white, fontSize: 24),
        )
            : buildTasks(),
      ),
    ),
    floatingActionButton: FloatingActionButton(
      backgroundColor: Colors.black,
      child: Icon(Icons.add),
      onPressed: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => AddEditTaskPage()),
        );

        refreshTasks();
      },
    ),
  );

  Widget buildTasks() => StaggeredGridView.countBuilder(
    padding: EdgeInsets.all(8),
    itemCount: tasks.length,
    staggeredTileBuilder: (index) => StaggeredTile.fit(2),
    crossAxisCount: 4,
    mainAxisSpacing: 4,
    crossAxisSpacing: 4,
    itemBuilder: (context, index) {
      final task = tasks[index];

      return GestureDetector(
        onTap: () async {
          await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => TaskDetailPage(taskId: task.id!),
          ));

          refreshTasks();
        },
          child: TaskCardWidget(task: task, index: index,
            onTaskUpdated: (updatedTask) => setState(() {
              final index = tasks.indexWhere((task) => task.id == updatedTask.id);
              if (index != -1) {
                tasks[index] = updatedTask;
              }}),)
      );
    },
  );
}