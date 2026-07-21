import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskflow/features/tasks/presentation/views/cognito_test.dart';
import 'core/di/injector.dart';
import 'features/tasks/presentation/viewmodels/task_viewmodel.dart';

void main() {
  setupDependencies(); // registra Dio, repos, usecases, etc. en get_it
  runApp(const TaskFlowApp());
}

class TaskFlowApp extends StatelessWidget {
  const TaskFlowApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<TaskViewmodel>()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const CognitoTestView(),
      ),
    );
  }
}
