
import 'dart:convert';
import 'package:localstorage/localstorage.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class ToDo {
  String description;
  DateTime date;

  ToDo({required this.description, required this.date});

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'date': date.toIso8601String(),
    };
  }

  factory ToDo.fromMap(Map<String, dynamic> map) {
    return ToDo(
      description: map['description'],
      date: DateTime.parse(map['date']),
    );
  }
}

class ToDoStorage {
  static const String key = 'todos';

  static LocalStorage storage = LocalStorage(key);

  static Future<void> saveToDos(List<ToDo> todos) async {
    await storage.ready;
    final todosJson = todos.map((todo) => todo.toMap()).toList();
    storage.setItem(key, jsonEncode(todosJson));
  }

  static Future<List<ToDo>> loadToDos() async {
    await storage.ready;
    final todosJson = storage.getItem(key);

    if (todosJson != null) {
      final todosList = jsonDecode(todosJson) as List<dynamic>;
      return todosList.map((todo) => ToDo.fromMap(todo)).toList();
    } else {
      return [];
    }
  }
}




