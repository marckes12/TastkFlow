import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskflow/features/tasks/presentation/viewmodels/task_viewmodel.dart';

class TaskListView extends StatefulWidget {
  const TaskListView({super.key});

  @override
  State<TaskListView> createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  @override
  void initState() {
    super.initState();
    context.read<TaskViewmodel>().loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TaskViewmodel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Mis Tareas'),),
      body: switch (vm.state){
        TaskState.loading => const Center(child: CircularProgressIndicator(),),
        TaskState.error => Center(child: Text(vm.errorMessage ?? 'Error'),),
        _=> ListView.builder(
          itemCount: vm.tasks.length,
          itemBuilder: (context, i){
            final task = vm.tasks[i];
            return ListTile(
              title: Text(task.title),
              trailing: Checkbox(value: task.done, onChanged: (_){}),
              //Accesibilidad: Semantics label explicito
              leading: Semantics(label: 'Tarea ${task.title}', child: const Icon(Icons.task),),
            );
          }
        ),
      },
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.read<TaskViewmodel>().createTask('Tarea desde Flutter');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}