import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:taskflow/features/tasks/data/datasources/task_local_datasource.dart';
import 'package:taskflow/features/tasks/data/datasources/task_remote_datasource.dart';
import 'package:taskflow/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:taskflow/features/tasks/domain/repositories/task_respository.dart';
import 'package:taskflow/features/tasks/domain/usecases/get_tasks_usecase.dart';
import 'package:taskflow/features/tasks/presentation/viewmodels/task_viewmodel.dart';

final getIt = GetIt.instance;

void setupDependencies(){
  final dio = Dio(BaseOptions(
    baseUrl: defaultTargetPlatform == TargetPlatform.android
        ? 'http://10.0.2.2:3002'
        : 'http://localhost:3002',
  ));

  // TEMPORAL: token hardcodeado solo para probar hoy.
  // Cuando construyamos el login real, esto se reemplaza por
  // un interceptor que lee el token guardado en shared_preferences.
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      options.headers['Authorization'] =
          'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIxNzg0MzMyNTY3MTMwIiwiZW1haWwiOiJ0ZXN0QHRlc3QuY29tIiwiaWF0IjoxNzg0MzM0NzQ2LCJleHAiOjE3ODQzNDE5NDZ9.7v0cJ1ik27oxeV2dZAW4XdgP43ceMrSZU3N7Ykp-8m4';
      return handler.next(options);
    },
  ));
  
  getIt.registerLazySingleton(() => Dio(BaseOptions(baseUrl: 'http://localhost:3002')));
  getIt.registerLazySingleton(() => TaskRemoteDatasource(getIt()));
  getIt.registerLazySingleton(() => TaskLocalDatasource());
  getIt.registerLazySingleton<TaskRepository>(() => TaskRepositoryImpl(getIt(), getIt()));
  getIt.registerLazySingleton(() => GetTasksUsecase(getIt()));
  getIt.registerFactory(() => TaskViewmodel(getIt(), getIt()));
}