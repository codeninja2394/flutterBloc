import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertask/domain/repositories/task_repository.dart';
import 'package:fluttertask/domain/repositories/task_repository_impl.dart';
import 'package:fluttertask/domain/usecases/tasks.dart';
import 'package:fluttertask/presentation/bloc/task_bloc.dart';
import 'package:fluttertask/presentation/screens/task_manager.dart';

void main() {
  final TaskRepository taskRepository = TaskRepositoryImpl();

  final getTasks = GetTasks(taskRepository);
  final addTask = AddTask(taskRepository);
  final deleteTask = DeleteTask(taskRepository);

  runApp(MyApp(taskBloc: TaskBloc(getTasks, addTask, deleteTask)));
}

class MyApp extends StatelessWidget {
  final TaskBloc taskBloc;

  const MyApp({super.key, required this.taskBloc});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider.value(
        value: taskBloc,
        child: const TaskManagerPage(),
      ),
    );
  }
}
