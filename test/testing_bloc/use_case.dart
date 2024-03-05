import 'package:flutter_test/flutter_test.dart';
import 'package:fluttertask/domain/entities/task.dart';
import 'package:fluttertask/domain/repositories/task_repository.dart';
import 'package:fluttertask/domain/usecases/tasks.dart';

// Fake repository for testing
class FakeTaskRepository implements TaskRepository {
  final List<Task> _tasks = [];

  @override
  Future<List<Task>> getAllTasks() async => _tasks;

  @override
  Future<void> addTask(Task task) async {
    _tasks.add(task);
  }

  @override
  Future<void> deleteTask(String taskId) async {
    _tasks.removeWhere((task) => task.id == taskId);
  }
}

void main() {
  group('Task use case tests', () {
    late FakeTaskRepository fakeRepository;
    late GetTasks getTasks;
    late AddTask addTask;
    late DeleteTask deleteTask;

    setUp(() {
      fakeRepository = FakeTaskRepository();
      getTasks = GetTasks(fakeRepository);
      addTask = AddTask(fakeRepository);
      deleteTask = DeleteTask(fakeRepository);
    });

    test('GetTasks should return empty list initially', () async {
      expect(await getTasks(), []);
    });

    test('AddTask should add a task', () async {
      final task = Task(id: '1', title: 'Test Task');
      await addTask(task);
      expect(await getTasks(), [task]);
    });

    test('DeleteTask should remove a task', () async {
      final task = Task(id: '2', title: 'Another Test Task');
      await addTask(task);
      await deleteTask(task.id);
      expect(await getTasks(), isNot(contains(task)));
    });
  });
}
