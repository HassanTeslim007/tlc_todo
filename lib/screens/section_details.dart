import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tlc_todo/util/utils.dart';
import '../services/storage_service.dart';
import '../models/section.dart';
import '../widgets/task_tile.dart';
import '../widgets/add_task_dialog.dart';

class SectionDetailScreen extends StatelessWidget {
  const SectionDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sectionId = ModalRoute.of(context)!.settings.arguments as String;

    return Consumer<StorageService>(
      builder: (context, storageService, child) {
        final section = storageService.getSectionById(sectionId);

        if (section == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Section Not Found')),
            body: const Center(child: Text('This section no longer exists.')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  section.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (section.description.isNotEmpty)
                  Text(
                    section.description,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey,
                    ),
                  ),
              ],
            ),
            actions: [
              if (section.tasks.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.analytics_outlined),
                  onPressed: () => _showStatsDialog(context, section),
                ),
            ],
          ),
          body: section.tasks.isEmpty
              ? _buildEmptyTaskState(context, section.name)
              : Column(
                  children: [
                    // Progress indicator
                    if (section.tasks.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: primaryColor),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Progress',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${section.completedTasksCount} of ${section.totalTasksCount} tasks completed',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: CircularProgressIndicator(
                                    value: section.completionPercentage,
                                    backgroundColor: primaryColor.withValues(
                                      alpha: 0.2,
                                    ),
                                    valueColor: AlwaysStoppedAnimation(
                                      primaryColor,
                                    ),
                                    strokeWidth: 6,
                                  ),
                                ),
                                Text(
                                  '${(section.completionPercentage * 100).round()}%',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    // Tasks list
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: section.tasks.length,
                        itemBuilder: (context, index) {
                          final task = section.tasks[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: TaskTile(
                              task: task,
                              onToggleComplete: () async {
                                await storageService.toggleTaskCompletion(
                                  section.id,
                                  task.id,
                                );
                              },
                              onEdit: () => _showEditTaskDialog(
                                context,
                                storageService,
                                section.id,
                                task,
                              ),
                              onDelete: () async {
                                await storageService.deleteTask(
                                  section.id,
                                  task.id,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () =>
                _showAddTaskDialog(context, storageService, section.id),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  Widget _buildEmptyTaskState(BuildContext context, String sectionName) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.task_alt_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No tasks yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first task to "$sectionName"',
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showAddTaskDialog(
              context,
              Provider.of<StorageService>(context, listen: false),
              ModalRoute.of(context)!.settings.arguments as String,
            ),
            icon: const Icon(Icons.add),
            label: const Text('Add Task'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddTaskDialog(
    BuildContext context,
    StorageService storageService,
    String sectionId,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddTaskDialog(
          onSave: (title, dueDate) async {
            await storageService.addTask(sectionId, title, dueDate: dueDate);
          },
        );
      },
    );
  }

  void _showEditTaskDialog(
    BuildContext context,
    StorageService storageService,
    String sectionId,
    task,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddTaskDialog(
          initialTitle: task.title,
          initialDueDate: task.dueDate,
          isEditing: true,
          onSave: (title, dueDate) async {
            await storageService.updateTask(
              sectionId,
              task.id,
              title,
              dueDate: dueDate,
            );
          },
        );
      },
    );
  }

  void _showStatsDialog(BuildContext context, Section section) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${section.name} Statistics'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatRow('Total Tasks', section.totalTasksCount.toString()),
              _buildStatRow(
                'Completed',
                section.completedTasksCount.toString(),
              ),
              _buildStatRow(
                'Remaining',
                (section.totalTasksCount - section.completedTasksCount)
                    .toString(),
              ),
              _buildStatRow(
                'Completion Rate',
                '${(section.completionPercentage * 100).round()}%',
              ),
              if (section.tasks.any((t) => t.dueDate != null))
                _buildStatRow(
                  'Tasks with Due Dates',
                  section.tasks
                      .where((t) => t.dueDate != null)
                      .length
                      .toString(),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
