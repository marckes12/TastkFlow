import 'package:taskflow/features/tasks/domain/entities/task.dart';
import 'package:taskflow/features/tasks/domain/repositories/task_respository.dart';
import 'package:taskflow/features/tasks/data/datasources/task_local_datasource.dart';
import 'package:taskflow/features/tasks/data/datasources/task_remote_datasource.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDatasource remote;
  final TaskLocalDatasource local;

  TaskRepositoryImpl(this.remote, this.local);
  
  @override
  Future<Task> createTask(String title) async {
    final data = await remote.createTask(title);
    return Task(id: data['id'], title: data['title'], done: false);
  }
  
  @override
  Future<List<Task>> getTasks() async {
    try{
      final remoteData = await remote.fetchTasks();
      await local.cacheTasks(remoteData);
      return remoteData.map((e) => Task(id: e['id'], title: e['title'], done: e['done'] == 1)).toList();
    } catch (_){
      //Sin conexión: usa el cache local
      final cached = await local.getCachedTasks();
      return cached.map((e) => Task(id: e['id'], title: e['title'], done: e['done'] == 1)).toList();
    }
  }
  
  @override
  Future<Task> toggleTask(String id, bool done) async {
    throw UnimplementedError(); //Similar a createTask
  }

}