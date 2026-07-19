import 'package:dio/dio.dart';

class TaskRemoteDatasource {
  final Dio dio;
  TaskRemoteDatasource(this.dio);

  Future<List<Map<String, dynamic>>> fetchTasks() async{
    final response = await dio.get('/api/tasks');
    return List<Map<String, dynamic>>.from(response.data);
  }

  Future<Map<String, dynamic>> createTask(String title) async{
    final response = await dio.post('/api/tasks', data: {'title': title});
    return response.data;
  }
}