import 'package:fluttertask/domain/entities/task.dart';
import 'package:fluttertask/domain/repositories/task_repository.dart';

class GetTasks {
  final TaskRepository repository;

  GetTasks(this.repository);

  Future<List<Task>> call() async {
    return await repository.getAllTasks();
  }
}

class AddTask {
  final TaskRepository repository;

  AddTask(this.repository);

  Future<void> call(Task task) async {
    if (task.title.isEmpty) {
      throw Exception('Task title cannot be empty');
    }
    await repository.addTask(task);
  }
}

class DeleteTask {
  final TaskRepository repository;

  DeleteTask(this.repository);

  Future<void> call(String taskId) async {
    await repository.deleteTask(taskId);
  }
}
