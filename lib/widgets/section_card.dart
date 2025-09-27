import 'package:flutter/material.dart';
import 'package:tlc_todo/util/utils.dart';
import '../models/section.dart';

class SectionCard extends StatelessWidget {
  final Section section;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const SectionCard({
    super.key,
    required this.section,
    required this.onTap,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(section.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete, color: Colors.white, size: 28),
      ),
      // onDismissed: (direction) => onDelete(),
      confirmDismiss: (direction) async {
        final confirmed = await _showDeleteConfirmation(context, section.name);
        if (confirmed) {
          onDelete();
        }
        return confirmed;
      },
      child: Card(
        elevation: 2,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with title and action button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        section.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),

                // Description
                if (section.description.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    section.description,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],

                const SizedBox(height: 12),

                // Progress and stats
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Task count
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: secondaryColor.withValues(alpha: .4),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${section.totalTasksCount} task${section.totalTasksCount == 1 ? '' : 's'}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: primaryColor,
                        ),
                      ),
                    ),

                    // Completion indicator
                    if (section.totalTasksCount > 0) ...[
                      Row(
                        children: [
                          Text(
                            '${section.completedTasksCount}/${section.totalTasksCount}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 30,
                                height: 30,
                                child: CircularProgressIndicator(
                                  value: section.completionPercentage,
                                  backgroundColor: Colors.grey[200],
                                  valueColor: AlwaysStoppedAnimation(
                                    section.completionPercentage == 1.0
                                        ? Colors.green
                                        : Colors.blue,
                                  ),
                                  strokeWidth: 3,
                                ),
                              ),
                              if (section.completionPercentage == 1.0)
                                const Icon(
                                  Icons.check,
                                  size: 16,
                                  color: Colors.green,
                                ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<bool> _showDeleteConfirmation(
  BuildContext context,
  String sectionName,
) async {
  return await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete Section'),
            content: Text(
              'Are you sure you want to delete "$sectionName"?\n\nThis will also delete all tasks within this section.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          );
        },
      ) ??
      false;
}
