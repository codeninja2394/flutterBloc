import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertask/domain/entities/task.dart';
import 'package:fluttertask/domain/usecases/tasks.dart';

abstract class TaskEvent {}

class LoadTasks extends TaskEvent {}

class AddTaskEvent extends TaskEvent {
  final Task task;
  AddTaskEvent(this.task);
}

class DeleteTaskEvent extends TaskEvent {
  final String taskId;
  DeleteTaskEvent(this.taskId);
}

abstract class TaskState {}

class TasksLoadSuccess extends TaskState {
  final List<Task> tasks;
  TasksLoadSuccess(this.tasks);
}

class TasksLoadInProgress extends TaskState {}

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTasks getTasks;
  final AddTask addTask;
  final DeleteTask deleteTask;

  TaskBloc(this.getTasks, this.addTask, this.deleteTask)
      : super(TasksLoadInProgress()) {
    on<LoadTasks>((event, emit) async {
      emit(TasksLoadInProgress());
      try {
        final tasks = await getTasks();
        emit(TasksLoadSuccess(tasks));
      } catch (error) {
        print("error is $error");
        // Handle any errors, possibly emitting a TasksLoadFailure state
      }
    });

    on<AddTaskEvent>((event, emit) async {
      await addTask(event.task);
      add(LoadTasks()); // Re-load tasks after adding
    });
    on<DeleteTaskEvent>((event, emit) async {
      await deleteTask(event.taskId);
      add(LoadTasks()); // Re-load tasks after deletion
    });
  }
}
