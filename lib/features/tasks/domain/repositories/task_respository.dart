import 'dart:typed_data';
import 'package:taskflow/features/tasks/domain/entities/task.dart';

abstract class TaskRepository {
  Future<List<Task>> getTasks();
  Future<Task> createTask(String title);
  Future<Task> toggleTask(String id, bool done);
  //Metodos necesarios para la carga de la imagen a S3
  Future<String> getPresignedUrl(String fileName, String mimeType);
  Future<void> uploadToS3(String presignedUrl, Uint8List fileBytes, String mimeType);
}