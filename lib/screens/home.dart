import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/storage_service.dart';
import '../widgets/section_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TLC TODOs',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfoDialog(context),
          ),
        ],
      ),
      body: Consumer<StorageService>(
        builder: (context, storageService, child) {
          if (storageService.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (storageService.sections.isEmpty) {
            return _buildEmptyState(context);
          }

          return RefreshIndicator(
            onRefresh: () async {
              await storageService.loadSections();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: storageService.sections.length,
              itemBuilder: (context, index) {
                final section = storageService.sections[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SectionCard(
                    section: section,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/section-detail',
                        arguments: section.id,
                      );
                    },
                    onDelete: () async {  await storageService.deleteSection(section.id);
                     
                    },
                    onEdit: () {
                      Navigator.pushNamed(
                        context,
                        '/add-edit-section',
                        arguments: section.id,
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-edit-section');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.checklist_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No sections yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first section to get started',
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/add-edit-section');
            },
            icon: const Icon(Icons.add),
            label: const Text('Create Section'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Flutter To-Do Demo'),
          content: const Text(
            'This is a simple to-do list app built with Flutter.\n\n'
            'Features:\n'
            '• Multiple sections for organizing tasks\n'
            '• Task creation, editing, and completion\n'
            '• Local data persistence\n'
            '• Mock notification system\n\n'
            'Swipe left on sections to delete them, or tap the edit icon to modify.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Got it'),
            ),
          ],
        );
      },
    );
  }
}
