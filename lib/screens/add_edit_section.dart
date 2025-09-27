import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tlc_todo/util/utils.dart';
import '../services/storage_service.dart';

class AddEditSectionScreen extends StatefulWidget {
  const AddEditSectionScreen({super.key});

  @override
  State<AddEditSectionScreen> createState() => _AddEditSectionScreenState();
}

class _AddEditSectionScreenState extends State<AddEditSectionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;
  bool _isEditing = false;
  String? _sectionId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Check if we're editing an existing section
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is String) {
      _sectionId = args;
      _isEditing = true;
      _loadSectionData();
    }
  }

  void _loadSectionData() {
    if (_sectionId != null) {
      final storageService = Provider.of<StorageService>(
        context,
        listen: false,
      );
      final section = storageService.getSectionById(_sectionId!);
      if (section != null) {
        _nameController.text = section.name;
        _descriptionController.text = section.description;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Section' : 'New Section'),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Section name field
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Section Name',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        hintText: 'Enter section name (e.g., Work, Shopping)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.folder_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a section name';
                        }
                        return null;
                      },
                      textCapitalization: TextCapitalization.words,
                      onFieldSubmitted: (_) => _focusDescription(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Description field
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Description (Optional)',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        hintText: 'Add a brief description of this section',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.description_outlined),
                      ),
                      maxLines: 3,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Save button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _saveSection,
                icon: _isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(_isEditing ? Icons.save : Icons.add),
                label: Text(_isEditing ? 'Update Section' : 'Create Section'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Helpful tips
            Card(
              color: secondaryColor,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lightbulb_outline),
                        const SizedBox(width: 8),
                        Text(
                          'Tips',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• Choose clear, descriptive names\n'
                      '• Group related tasks together\n'
                      '• Use descriptions to clarify the section\'s purpose',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),

            // Preview examples
            if (!_isEditing) ...[
              const SizedBox(height: 16),
              Card(
                color: secondaryColor,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.emoji_objects_outlined),
                          const SizedBox(width: 8),
                          Text(
                            'Example Sections',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _buildExampleSection(
                        'Work',
                        'Professional tasks and projects',
                      ),
                      _buildExampleSection(
                        'Shopping',
                        'Items to buy and errands',
                      ),
                      _buildExampleSection(
                        'Health & Fitness',
                        'Workout routines and health goals',
                      ),
                      _buildExampleSection(
                        'Home',
                        'Household chores and maintenance',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildExampleSection(String name, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• '),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 14, color: Colors.black),
                children: [
                  TextSpan(
                    text: name,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  TextSpan(text: ' - $description'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _focusDescription() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  Future<void> _saveSection() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final storageService = Provider.of<StorageService>(
        context,
        listen: false,
      );
      final name = _nameController.text.trim();
      final description = _descriptionController.text.trim();

      if (_isEditing && _sectionId != null) {
        await storageService.updateSection(_sectionId!, name, description);
      } else {
        await storageService.addSection(name, description);
      }

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditing ? 'Section updated!' : 'Section created!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
