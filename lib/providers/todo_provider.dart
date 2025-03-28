import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app_flutter/data/models/todo.dart';

class TodoProvider with ChangeNotifier {
  List<ToDo> _todos = [];
  
  List<ToDo> get todos => _todos;

  TodoProvider() {
    
    _loadToDos();
  }

  void addToDo(String title) {
    final newToDo = ToDo(
      id: DateTime.now().millisecondsSinceEpoch, 
      title: title,
      completed: false,
    );
    _todos.add(newToDo);
    _saveToDos();
    notifyListeners();
  }

  void deleteToDo(int id) {
    _todos.removeWhere((todo) => todo.id == id);
    _saveToDos();
    notifyListeners();
  }

  void toggleToDo(int id) {
    int index = _todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      _todos[index].completed = !_todos[index].completed!;
      _saveToDos();
      notifyListeners();
    }
  }

  Future<void> _saveToDos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String encodedData = jsonEncode(_todos.map((todo) => todo.toJson()).toList());
      await prefs.setString('todos', encodedData);
    } catch (e) {
      print("Hata oluştu: $e");
    }
  }

  Future<void> _loadToDos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      bool firstRun = prefs.getBool('firstRun') ?? true;

      if (firstRun) {
        // API'den veriyi çek ve kaydet
        List<ToDo> fetchedTodos = await ToDo.fetchTodos();
        _todos = fetchedTodos;
        await prefs.setBool('firstRun', false); // Bir daha API çağırma
        _saveToDos();
      } else {
        // API çağırmadan lokal bellekteki veriyi yükle
        String? todosString = prefs.getString('todos');
        if (todosString != null) {
          List<dynamic> decodedData = jsonDecode(todosString);
          _todos = decodedData.map((item) => ToDo.fromJson(item)).toList();
        }
      }

      notifyListeners();
    } catch (e) {
      print("Hata oluştu: $e");
    }
  }
}
