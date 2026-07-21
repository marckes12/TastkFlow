import 'package:flutter/foundation.dart';
import 'package:taskflow/features/tasks/domain/entities/task.dart';
import 'package:taskflow/features/tasks/domain/repositories/task_respository.dart';
import 'package:taskflow/features/tasks/domain/usecases/get_tasks_usecase.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taskflow/features/tasks/domain/usecases/upload_task_image_usecase.dart';

enum TaskState { idle, loading, loaded, error }

class TaskViewmodel extends ChangeNotifier {
  final GetTasksUsecase getTasksUsecase;
  final TaskRepository repository;
  final UploadTaskImageUsecase uploadTaskImageUsecase;
  
  TaskViewmodel(this.getTasksUsecase, this.repository, this.uploadTaskImageUsecase);

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

  //Metodo para subir una imagen a S3
  Future<XFile?> pickImage() async {
    final ImagePicker img = ImagePicker();
    final XFile? imagen = await img.pickImage(source: ImageSource.gallery);

    if (imagen != null){
      return imagen;
    }
    return null;
  }

   // NUEVO: Método para procesar la subida
  Future<void> uploadImage(XFile imagen) async {
    state = TaskState.loading;
    notifyListeners(); // Esto hará que tu pantalla muestre un CircularProgressIndicator
    try {
      // Llamamos al caso de uso como si fuera una función gracias a call()
      await uploadTaskImageUsecase(imagen.path);
      
      state = TaskState.loaded;
      // Aquí podrías recargar las tareas si tuvieran imágenes asignadas
    } catch (e) {
      errorMessage = 'Error al subir la imagen a S3';
      state = TaskState.error;
    }
    
    notifyListeners(); // Ocultamos el indicador de carga
  }
}
