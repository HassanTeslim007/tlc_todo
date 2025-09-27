# TLC To-Do List App

## Overview
A simple, lightweight to-do list app built with Flutter

## Features Implemented
- ✅ Multiple sections (work, shopping, house chores, etc.)
- ✅ Section descriptions
- ✅ Task creation, editing, and deletion
- ✅ Task completion status
- ✅ Local data persistence
- ✅ Clean, intuitive UI
- 🔄 Notification system (mocked implementation)

## Architecture & Structure

### Project Structure
```
lib/
├── main.dart                 # App entry point
├── models/
│   ├── section.dart         # Section data model
│   └── task.dart           # Task data model
├── services/
│   ├── storage_service.dart # Local storage handling
│   └── notification_service.dart # Notification service (mocked)
├── screens/
│   ├── home_screen.dart    # Main sections list
│   ├── section_detail_screen.dart # Tasks within a section
│   └── add_edit_section_screen.dart # Section creation/editing
├── widgets/
    ├── section_card.dart   # Section display widget
    ├── task_tile.dart     # Individual task widget
    └── add_task_dialog.dart # Task creation dialog
```

## Technical Decisions & Approach

### State Management
- **Provider Pattern**: Chose Provider for state management as it's simple, efficient, and perfect for this scope
- **Separation of Concerns**: Models handle data structure, services handle business logic, widgets handle UI

### Data Persistence
- **SharedPreferences**: Used for local storage as it's lightweight and sufficient for this demo
- **JSON Serialization**: Custom toJson/fromJson methods for easy data conversion

### Navigation
- **Named Routes**: Clean navigation structure with proper route management
- **Data Passing**: Efficient parameter passing between screens

### UI/UX Decisions
- **Material Design**: Consistent with platform conventions
- **Floating Action Buttons**: Intuitive task/section creation
- **Swipe to Delete**: Natural mobile interaction pattern
- **Visual Feedback**: Loading states, animations, and clear status indicators

## Key Components

### Models
- `Section`: Represents a category with id, name, description, and tasks list
- `Task`: Represents individual tasks with id, title, completion status, and optional due date

### Services
- `StorageService`: Handles all local data persistence
- `NotificationService`: Mock implementation for task reminders

### Screens
- `HomeScreen`: Main dashboard showing all sections
- `SectionDetailScreen`: Task management within a section
- `AddEditSectionScreen`: Section creation and editing

## Assumptions Made

1. **Local Storage Only**: No cloud sync needed for this demo
2. **Simple Task Structure**: Tasks only need title, completion status, and optional due date
3. **Basic Notifications**: Mocked the notification system to focus on core functionality
4. **No User Authentication**: Single-user app assumption
5. **Platform Agnostic**: Designed for both iOS and Android

## Trade-offs Made

### Chosen for Simplicity:
- Simple tructure over Clean architecture for simplicity
- Provider over more complex state management (BLoC, Riverpod)
- Basic Named Routes over GoRouter for Navigation
- SharedPreferences over local databases (SQLite, Hive)
- Basic UI over elaborate animations and custom designs
- Mocked notifications over full implementation with Flutter_local_notifications

### Prioritized:
- Clean, readable code structure
- Mobile UX patterns
- Efficient data flow
- Practical functionality

## What I'd Do With More Time

### Immediate Improvements (Next 2-4 hours):
1. **Full Notification Implementation**
   - Integrate `flutter_local_notifications`
   - Add date/time pickers for task due dates
   - Implement background notification scheduling

2. **Enhanced UI/UX**
   - Add subtle animations and transitions
   - Add task priority levels with color coding
   - Dark mode support

3. **Data Enhancements**
   - Task search and filtering

### Future Features (More Development Time):
1. **Advanced Functionality**
   - Recurring tasks
   - Task dependencies
   - File/photo attachments
   - Voice notes for tasks

2. **Cloud Integration**
   - Firebase backend for sync across devices
   - User authentication
   - Collaborative sections

## Installation & Running

1. Ensure Flutter is installed and configured
2. Clone/download the project
3. Run `flutter pub get` to install dependencies
4. Run `flutter run` to start the app

## Dependencies Used
- `provider` - State management
- `shared_preferences` - Local storage
- `uuid` - Unique ID generation

## Testing Approach
While not implemented in this demo, the structure supports easy testing:
- Unit tests for models and services
- Integration tests for user flows
