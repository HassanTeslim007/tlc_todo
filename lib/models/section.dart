import 'package:tlc_todo/models/task.dart';

class Section {
  final String id;
  String name;
  String description;
  List<Task> tasks;
  DateTime createdAt;

  Section({
    required this.id,
    required this.name,
    this.description = '',
    List<Task>? tasks,
    DateTime? createdAt,
  }) : tasks = tasks ?? [],
        createdAt = createdAt ?? DateTime.now();

  Section copyWith({
    String? name,
    String? description,
    List<Task>? tasks,
  }) {
    return Section(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      tasks: tasks ?? this.tasks,
      createdAt: createdAt,
    );
  }

  int get completedTasksCount => tasks.where((task) => task.isCompleted).length;
  int get totalTasksCount => tasks.length;
  double get completionPercentage => 
      totalTasksCount == 0 ? 0.0 : completedTasksCount / totalTasksCount;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'tasks': tasks.map((task) => task.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      tasks: (json['tasks'] as List?)
              ?.map((taskJson) => Task.fromJson(taskJson))
              .toList() ?? [],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}