import 'dart:typed_data';
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

  // ==========================================
  // NUEVOS MÉTODOS PARA SUBIR IMAGEN A S3
  // ==========================================

  Future<String> getPresignedUrl(String fileName, String mimeType) async{
    final response = await dio.post('api/task/upload-url', data: {
      'filename': fileName,
      'filetype': mimeType
    });

    return response.data['uploadUrl'];
  }

  //Subir los bytes de la imagen a S3
  Future<void> uploadToS3(String presignedUrl, Uint8List fileBytes, String mimeType) async {
    //Creamos una nueva instancia de Dio porque la que tenemos predefinida inyecta el header Authorization lo cual causara error con S3
    final S3Dio = Dio();

    await S3Dio.put(
      presignedUrl,
      data: fileBytes,
      options: Options(
        headers: {
          'Content-Type': mimeType,
          Headers.contentLengthHeader: fileBytes.length,  //Esto es recomendado para S3
        },
      )
    );
  }

}