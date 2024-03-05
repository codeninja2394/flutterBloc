import 'package:fluttertask/domain/entities/task.dart';

abstract class TaskRepository {
  Future<List<Task>> getAllTasks();
  Future<void> addTask(Task task);
  Future<void> deleteTask(String id);
}
