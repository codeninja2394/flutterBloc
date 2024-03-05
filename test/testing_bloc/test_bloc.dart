import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:fluttertask/domain/entities/task.dart';
import 'package:fluttertask/domain/repositories/task_repository.dart';
import 'package:fluttertask/domain/repositories/task_repository_impl.dart';
import 'package:fluttertask/domain/usecases/tasks.dart';
import 'package:fluttertask/presentation/bloc/task_bloc.dart';

void main() {
  group('TaskBloc Tests with Dummy Data', () {
    final TaskRepository taskRepository = TaskRepositoryImpl();
    // Dummy tasks
    final tasks = [Task(id: '1', title: 'Test Task')];

    // Simulate GetTasks use case
    final getTasks =
        GetTasks(taskRepository); // Replace null with your repository if needed
    // Simulate AddTask use case
    final addTask =
        AddTask(taskRepository); // Replace null with your repository if needed
    // Simulate DeleteTask use case
    final deleteTask = DeleteTask(
        taskRepository); // Replace null with your repository if needed

    blocTest<TaskBloc, TaskState>(
      'emits [TasksLoadSuccess] with tasks when LoadTasks is added',
      build: () => TaskBloc(getTasks, addTask, deleteTask),
      act: (bloc) => bloc.add(LoadTasks()),
      expect: () => [
        isA<TasksLoadInProgress>(),
        isA<TasksLoadSuccess>(),
      ],
    );

    blocTest<TaskBloc, TaskState>(
      'emits [TasksLoadSuccess] with new task when AddTaskEvent is added',
      build: () => TaskBloc(getTasks, addTask, deleteTask),
      act: (bloc) => bloc.add(AddTaskEvent(Task(id: '2', title: 'New Task'))),
      expect: () => [
        isA<TasksLoadInProgress>(),
        isA<TasksLoadSuccess>(),
      ],
    );

    blocTest<TaskBloc, TaskState>(
      'emits [TasksLoadSuccess] without deleted task when DeleteTaskEvent is added',
      build: () => TaskBloc(getTasks, addTask, deleteTask),
      act: (bloc) => bloc.add(DeleteTaskEvent('1')),
      expect: () => [
        isA<TasksLoadInProgress>(),
        isA<TasksLoadSuccess>(),
      ],
    );
  });
}
