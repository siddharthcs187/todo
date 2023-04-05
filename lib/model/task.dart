final String tableTasks = 'tasks';

class TaskFields {
  static final List<String> values = [
    id, isChecked, title, description
  ];

  static final String id = '_id';
  static final String isChecked = 'isChecked';
  static final String title = 'title';
  static final String description = 'description';
}

class Task {
  final int? id;
  final bool isChecked;
  final String title;
  final String description;

  const Task({
    this.id,
    required this.isChecked,
    required this.title,
    required this.description,
  });

  Task copy({
    int? id,
    bool? isChecked,
    String? title,
    String? description,
  }) =>
      Task(
        id: id ?? this.id,
        isChecked: isChecked ?? this.isChecked,
        title: title ?? this.title,
        description: description ?? this.description,
      );

  static Task fromJson(Map<String, Object?> json) => Task(
    id: json[TaskFields.id] as int?,
    isChecked: json[TaskFields.isChecked] == 1,
    title: json[TaskFields.title] as String,
    description: json[TaskFields.description] as String,
  );

  Map<String, Object?> toJson() => {
    TaskFields.id: id,
    TaskFields.title: title,
    TaskFields.isChecked: isChecked ? 1 : 0,
    TaskFields.description: description,
  };
}