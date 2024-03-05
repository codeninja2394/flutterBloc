import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertask/domain/entities/task.dart';
import 'package:fluttertask/presentation/bloc/task_bloc.dart';

class TaskManagerPage extends StatefulWidget {
  const TaskManagerPage({super.key});

  @override
  State<TaskManagerPage> createState() => _TaskManagerPageState();
}

class _TaskManagerPageState extends State<TaskManagerPage> {
  @override
  void initState() {
    super.initState();
    // Dispatch the LoadTasks event
    BlocProvider.of<TaskBloc>(context, listen: false).add(LoadTasks());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Task Manager')),
        body: BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            if (state is TasksLoadSuccess) {
              final tasks = state.tasks;
              return ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(tasks[index].title),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        BlocProvider.of<TaskBloc>(context)
                            .add(DeleteTaskEvent(tasks[index].id));
                      },
                    ),
                  );
                },
              );
            } else if (state is TasksLoadInProgress) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return const Center(child: Text('Failed to load tasks'));
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) {
                TextEditingController titleController = TextEditingController();

                return AlertDialog(
                  title: const Text('Add Task'),
                  content: TextField(
                    controller: titleController,
                    decoration: const InputDecoration(hintText: "Task Title"),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Add'),
                      onPressed: () {
                        // Create a new task and add it using the BLoC.
                        final newTask = Task(
                            id: UniqueKey().toString(),
                            title: titleController.text);
                        BlocProvider.of<TaskBloc>(context)
                            .add(AddTaskEvent(newTask));
                        Navigator.of(context).pop(); // Dismiss the dialog
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: const Icon(Icons.add),
        ));
  }
}
