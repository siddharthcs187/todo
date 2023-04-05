import 'package:flutter/material.dart';

import '../db/tasks_database.dart';
import '../model/task.dart';
import '../widgets/task_form_widget.dart';


class AddEditTaskPage extends StatefulWidget {
  final Task? task;

  const AddEditTaskPage({
    Key? key,
    this.task,
  }) : super(key: key);
  @override
  _AddEditTaskPageState createState() => _AddEditTaskPageState();
}

class _AddEditTaskPageState extends State<AddEditTaskPage> {
  final _formKey = GlobalKey<FormState>();
  late bool isChecked;
  late String title;
  late String description;

  @override
  void initState() {
    super.initState();

    isChecked = widget.task?.isChecked ?? false;
    title = widget.task?.title ?? '';
    description = widget.task?.description ?? '';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      actions: [buildButton()],
    ),
    body: Form(
      key: _formKey,
      child: TaskFormWidget(
        isChecked: isChecked,
        title: title,
        description: description,
        onChangedChecked: (isChecked) =>
            setState(() => this.isChecked = isChecked),
        onChangedTitle: (title) => setState(() => this.title = title),
        onChangedDescription: (description) =>
            setState(() => this.description = description),
      ),
    ),
  );

  Widget buildButton() {
    final isFormValid = title.isNotEmpty && description.isNotEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary: isFormValid ? null : Colors.grey.shade700,
        ),
        onPressed: addOrUpdateTask,
        child: Text('Save'),
      ),
    );
  }

  void addOrUpdateTask() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.task != null;

      if (isUpdating) {
        await updateTask();
      } else {
        await addTask();
      }

      Navigator.of(context).pop();
    }
  }

  Future updateTask() async {
    final task = widget.task!.copy(
      isChecked: isChecked,
      title: title,
      description: description,
    );

    await TasksDatabase.instance.update(task);
  }

  Future addTask() async {
    final task = Task(
      title: title,
      isChecked: true,
      description: description,
    );

    await TasksDatabase.instance.create(task);
  }
}