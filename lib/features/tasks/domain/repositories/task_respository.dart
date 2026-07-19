import 'package:taskflow/features/tasks/domain/entities/task.dart';

abstract class TaskRepository {
  Future<List<Task>> getTasks();
  Future<Task> createTask(String title);
  Future<Task> toggleTask(String id, bool done);
}