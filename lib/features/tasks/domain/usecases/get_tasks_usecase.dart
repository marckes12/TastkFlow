import 'package:taskflow/features/tasks/domain/entities/task.dart';
import 'package:taskflow/features/tasks/domain/repositories/task_respository.dart';

class GetTasksUsecase {
  final TaskRepository repository;
  GetTasksUsecase(this.repository);

  Future<List<Task>> call() => repository.getTasks();
}