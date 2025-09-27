import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tlc_todo/screens/add_edit_section.dart';
import 'package:tlc_todo/screens/home.dart';
import 'package:tlc_todo/screens/section_details.dart';
import 'package:tlc_todo/util/utils.dart';
import 'services/storage_service.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StorageService()..loadSections(),
      child: MaterialApp(
        title: 'TLC Todo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor:primaryColor ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/section-detail': (context) => const SectionDetailScreen(),
          '/add-edit-section': (context) => const AddEditSectionScreen(),
        },
      ),
    );
  }
}

MaterialColor createMaterialColor(Color color) {
  return MaterialColor(color.toARGB32(), <int, Color>{
    50: color.withValues(alpha: 0.1),
    100: color.withValues(alpha: 0.2),
    200: color.withValues(alpha: 0.3),
    300: color.withValues(alpha: 0.4),
    400: color.withValues(alpha: 0.5),
    500: color.withValues(alpha: 0.6),
    600: color.withValues(alpha: 0.7),
    700: color.withValues(alpha: 0.8),
    800: color.withValues(alpha: 0.9),
    900: color.withValues(alpha: 1.0),
  });
}
