import 'package:flutter/material.dart';
import 'package:todo_list/utils/todo.dart';
import 'package:todo_list/widgets/todo_list_item.dart';
import 'package:universal_io/io.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController todoController = TextEditingController();
  final TextEditingController todoUpdateController = TextEditingController();
  bool isAndroid = Platform.isAndroid ? true : false;
  List<ToDo> todos = [];

  @override
  void initState() {
    super.initState();
    loadToDos();
  }

  void loadToDos() async {
    todos = await ToDoStorage.loadToDos();
    setState((){});
  }

  void saveToDos() async {
    await ToDoStorage.saveToDos(todos);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: todoController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Adicione uma tarefa',
                              hintText: 'Ex: Estudar Flutter'),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              ToDo toDo = ToDo(
                                  description: todoController.text,
                                  date: DateTime.now()
                              );
                              todos.add(toDo);
                              todoController.text = '';
                              saveToDos();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff00d7f3),
                            padding: const EdgeInsets.all(14),
                          ),
                          child: const Icon(Icons.add, size: 30))
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Flexible(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        for (ToDo todo in todos)
                          TodoListItem(toDo: todo, onDelete: onDelete, onUpdate: onUpdate),
                        const SizedBox(height: 8)
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Text(
                              'Você possui ${todos.length} tarefas pendentes')),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed:
                        todos.isNotEmpty ? showDeleteTodosConfirmationDialog : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff00d7f3),
                          padding: const EdgeInsets.all(14),
                        ),
                        child: const Text('Limpar tudo'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }

  void showDeleteTodosConfirmationDialog() {
    showDialog(context: context,
        builder: (context) =>
            AlertDialog(
                title: const Text("Limpar tudo?"),
                content: const Text("Tem certeza que deseja apagar todas as tarefas?"),
                actions: [
                TextButton(
                    onPressed: () {
                      setState((){
                        todos.clear();
                      });
                      saveToDos();
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.green
                    ),
                    child: const Text(
                      "Sim",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white
                      ),
                    ),
                ),
                TextButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.red
                    ),
                    child: const Text(
                        "Não",
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.white
                        ),
                    )
                )
    ],));

  }

  void onUpdate(ToDo todo) {
    showDialog(context: context, builder: (context) => AlertDialog(
      title: const Text("Atualizar tarefa"),
      content: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              controller: todoUpdateController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Descrição',
                  hintText: todo.description),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: (){
            setState((){
              todo.description = todoUpdateController.text;
            });
            todoUpdateController.text = '';
            saveToDos();
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
              backgroundColor: Colors.green
          ),
          child: const Text(
            "Atualizar",
            style: TextStyle(
                fontSize: 15,
                color: Colors.white
            ),
          ),
        ),
        TextButton(
            onPressed: (){
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
                backgroundColor: Colors.red
            ),
            child: const Text(
              "Cancelar",
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.white
              ),
            )
        )
      ],
    ));
  }

  void onDelete(ToDo todo) {
    int indexTodo = todos.indexOf(todo);
    setState(() {
      todos.remove(todo);
    });
    saveToDos();
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        'Tarefa ${todo.description} foi removida com sucesso',
        style: const TextStyle(color: Colors.black),
      ),
      backgroundColor: Colors.greenAccent,
      action: SnackBarAction(
        backgroundColor: Colors.green,
        label: "Restaurar",
        textColor: Colors.black,
        onPressed: () {
          setState(() {
            todos.insert(indexTodo, todo);
            saveToDos();
          });
        },
      ),
    ));
  }
}
