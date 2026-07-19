import 'package:flutter/foundation.dart';
import 'package:taskflow/features/tasks/domain/entities/task.dart';
import 'package:taskflow/features/tasks/domain/repositories/task_respository.dart';
import 'package:taskflow/features/tasks/domain/usecases/get_tasks_usecase.dart';

enum TaskState { idle, loading, loaded, error }

class TaskViewmodel extends ChangeNotifier {
  final GetTasksUsecase getTasksUsecase;
  final TaskRepository repository;
  
  TaskViewmodel(this.getTasksUsecase, this.repository);

  TaskState state = TaskState.idle;
  List<Task> tasks = [];
  String? errorMessage;

  Future<void> loadTasks() async{
    state = TaskState.loading;
    notifyListeners();
    try{
      tasks = await getTasksUsecase();
      state = TaskState.loaded;
    } catch (e){
      errorMessage = 'No se pudieron cargar las tareas';
      state = TaskState.error;
    }
    notifyListeners();
  }

  Future<void> createTask(String title) async {
    final nueva = await repository.createTask(title);
    tasks = [...tasks, nueva];
    notifyListeners();
  }
}
