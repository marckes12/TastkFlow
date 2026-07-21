import 'dart:io';
import 'package:mime/mime.dart';
import 'package:taskflow/features/tasks/domain/repositories/task_respository.dart';

class UploadTaskImageUsecase {
  final TaskRepository repository;

  UploadTaskImageUsecase(this.repository);

  // Usamos call() para que sea invocable
  Future<void> call(String imagePath) async {
    try {
      final file = File(imagePath);
      final fileName = file.uri.pathSegments.last;
      
      // Intentamos detectar el MimeType, si falla usamos octet-stream
      final mimeType = lookupMimeType(imagePath) ?? 'application/octet-stream';
      final fileBytes = await file.readAsBytes();

      // Pedimos URL
      final presignedUrl = await repository.getPresignedUrl(fileName, mimeType);

      // Subimos a S3
      await repository.uploadToS3(presignedUrl, fileBytes, mimeType);
      
    } catch (e) {
      // Lanzamos la excepción para que el ViewModel la atrape
      throw Exception('Fallo al subir imagen: $e');
    }
  }
}