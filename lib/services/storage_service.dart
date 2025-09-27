import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tlc_todo/services/notification_service.dart';
import 'package:uuid/uuid.dart';
import '../models/section.dart';
import '../models/task.dart';

class StorageService extends ChangeNotifier {
  static const String _sectionsKey = 'todo_sections';
  List<Section> _sections = [];
  bool _isLoading = false;
  final NotificationService _notificationService = NotificationService();

  List<Section> get sections => _sections;
  bool get isLoading => _isLoading;

  Future<void> loadSections() async {
    _isLoading = true;
    await Future.delayed(const Duration(seconds: 2)); // Simulate loading delay
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      final sectionsJson = prefs.getString(_sectionsKey);

      if (sectionsJson != null) {
        final List<dynamic> decoded = json.decode(sectionsJson);
        _sections = decoded
            .map((sectionJson) => Section.fromJson(sectionJson))
            .toList();
      } else {
        // Create default sections if none exist
        _createDefaultSections();
      }
    } catch (e) {
      debugPrint('Error loading sections: $e');
      _createDefaultSections();
    }

    _isLoading = false;
    notifyListeners();
  }

  void _createDefaultSections() {
    _sections = [
      Section(
        id: const Uuid().v4(),
        name: 'Work',
        description: 'Professional tasks and projects',
        tasks: [
          Task(id: const Uuid().v4(), title: 'Review quarterly reports'),
          Task(id: const Uuid().v4(), title: 'Prepare presentation for Monday'),
        ],
      ),
      Section(
        id: const Uuid().v4(),
        name: 'Shopping',
        description: 'Items to buy and errands to run',
        tasks: [
          Task(id: const Uuid().v4(), title: 'Buy groceries'),
          Task(id: const Uuid().v4(), title: 'Pick up dry cleaning'),
        ],
      ),
      Section(
        id: const Uuid().v4(),
        name: 'House Chores',
        description: 'Home maintenance and cleaning tasks',
        tasks: [
          Task(id: const Uuid().v4(), title: 'Clean the kitchen'),
          Task(id: const Uuid().v4(), title: 'Vacuum living room'),
        ],
      ),
    ];
    _saveSections();
  }

  Future<void> _saveSections() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final sectionsJson = json.encode(
        _sections.map((s) => s.toJson()).toList(),
      );
      await prefs.setString(_sectionsKey, sectionsJson);
    } catch (e) {
      debugPrint('Error saving sections: $e');
    }
  }

  // Section operations
  Future<void> addSection(String name, String description) async {
    final section = Section(
      id: const Uuid().v4(),
      name: name,
      description: description,
    );
    _sections.add(section);
    await _saveSections();
    notifyListeners();
  }

  Future<void> updateSection(
    String sectionId,
    String name,
    String description,
  ) async {
    final index = _sections.indexWhere((s) => s.id == sectionId);
    if (index != -1) {
      _sections[index] = _sections[index].copyWith(
        name: name,
        description: description,
      );
      await _saveSections();
      notifyListeners();
    }
  }

  Future<void> deleteSection(String sectionId) async {
    _sections.removeWhere((s) => s.id == sectionId);
    await _saveSections();
    notifyListeners();
  }

  // Task operations
  Future<void> addTask(
    String sectionId,
    String title, {
    DateTime? dueDate,
  }) async {
    final sectionIndex = _sections.indexWhere((s) => s.id == sectionId);
    if (sectionIndex != -1) {
      final task = Task(id: const Uuid().v4(), title: title, dueDate: dueDate);
      _sections[sectionIndex].tasks.add(task);

      // Schedule notification if due date is set
      if (dueDate != null) {
        await _notificationService.scheduleNotification(
          task.id.hashCode,
          'Task Reminder',
          'Don\'t forget: $title',
          dueDate,
        );
      }

      await _saveSections();
      notifyListeners();
    }
  }

  Future<void> updateTask(
    String sectionId,
    String taskId,
    String title, {
    DateTime? dueDate,
  }) async {
    final sectionIndex = _sections.indexWhere((s) => s.id == sectionId);
    if (sectionIndex != -1) {
      final taskIndex = _sections[sectionIndex].tasks.indexWhere(
        (t) => t.id == taskId,
      );
      if (taskIndex != -1) {
        _sections[sectionIndex].tasks[taskIndex] = _sections[sectionIndex]
            .tasks[taskIndex]
            .copyWith(title: title, dueDate: dueDate);
        await _saveSections();
        notifyListeners();
      }
    }
  }

  Future<void> toggleTaskCompletion(String sectionId, String taskId) async {
    final sectionIndex = _sections.indexWhere((s) => s.id == sectionId);
    if (sectionIndex != -1) {
      final taskIndex = _sections[sectionIndex].tasks.indexWhere(
        (t) => t.id == taskId,
      );
      if (taskIndex != -1) {
        _sections[sectionIndex].tasks[taskIndex] = _sections[sectionIndex]
            .tasks[taskIndex]
            .copyWith(
              isCompleted:
                  !_sections[sectionIndex].tasks[taskIndex].isCompleted,
            );
        await _saveSections();
        notifyListeners();
      }
    }
  }

  Future<void> deleteTask(String sectionId, String taskId) async {
    final sectionIndex = _sections.indexWhere((s) => s.id == sectionId);
    if (sectionIndex != -1) {
      _sections[sectionIndex].tasks.removeWhere((t) => t.id == taskId);
      // Cancel notification if it exists
      await _notificationService.cancelNotification(taskId.hashCode);
      await _saveSections();
      notifyListeners();
    }
  }

  Section? getSectionById(String id) {
    try {
      return _sections.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }
}
