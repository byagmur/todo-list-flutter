import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app_flutter/data/dto/todo_dto.dart';
import 'package:todo_app_flutter/data/models/todo_model.dart';
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

class TodoProvider with ChangeNotifier {
  List<ToDo> _todos = [];
  List<ToDo> get todos => _todos;

  static List<ToDo> todoList = [
    //   ToDo(id: '1', title: 'Mailleri kontrol et', completed: true),
    //   ToDo(id: '2', title: 'Markete git'),
    //   ToDo(id: '3', title: 'Alışveriş yap'),
    //   ToDo(id: '4', title: 'Yürüyüşe çık'),
    //  ToDo(id: '5', title: 'Kitap oku'),
  ];

  static Future<List<ToDo>> fetchTodos() async {
    final dio = Dio(); 
    final url = 'https://dummyjson.com/todos';

    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        List<dynamic> todosList =
            response
                .data['todos']; //dio , http kütüphanesinden farklı olarak otomatik json decode yapar

        List<ToDo> fetchedTodos =
            todosList
                .map((item) => ToDoDTO.fromJson(item).toModel())
                .take(5)
                .toList();

        return fetchedTodos;
      } else {
        throw Exception('Veriler yüklenemedi.');
      }
    } catch (e) {
      throw Exception('Bir hata oluştu.');
    }
  }

  TodoProvider() {
    _loadToDos();
  }

  void addToDo(String title) {
 
    _saveToDos();
    addToDoApi(title);

    notifyListeners();
  }

  void deleteToDo(int id) {
    _todos.removeWhere((todo) => todo.id == id);
    deleteToDoApi(id);
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
      String encodedData = jsonEncode(
        _todos.map((todo) => ToDoDTO.fromModel(todo).toJson()).toList(),
      );

      await prefs.setString('todos', encodedData);
    } catch (e) {
      print("Hata oluştu: $e");
    }
  }

  Future<void> _loadToDos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      bool firstRun =
          prefs.getBool('firstRun') ??
          true; // ilk kez çalışıp çalışmadığını kontrol et

      if (firstRun) {
       //  ilk kez çalışıyorsa, API'den verileri çek
        //  ve belleğe kaydet
        List<ToDo> fetchedTodos = await fetchTodos();
        _todos = fetchedTodos;

        await prefs.setBool('firstRun', false);
        _saveToDos();
      } else {
        //  ilk kez çalışmıyorsa,
        //  lokal bellekteki veriyi yükle
        //  ve listeyi güncelle
        String? todosString = prefs.getString('todos');
        if (todosString != null) {
          List<dynamic> decodedData = jsonDecode(todosString);
          _todos =
              decodedData
                  .map((item) => ToDoDTO.fromJson(item).toModel())
                  .toList();
        }
      }

      notifyListeners();
    } catch (e) {
      print("Hata oluştu: $e");
    }
  }

  Future<void> addToDoApi(String title) async {
    final dio = Dio();
    final url = 'https://dummyjson.com/todos/add';
    final uuid = Uuid();
    final uniqueid = uuid.v4();

    try {
      final response = await dio.post(
        url,
        data: {"id": uniqueid  ,"todo": title, "completed": false, "userId": 1},
      );

      print('API Yanıt Kodu: ${response.statusCode}');
      print('API Yanıtı: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {



        final newToDo = ToDoDTO.fromJson(response.data).toModel();
        _todos.add(newToDo);
        notifyListeners();
      } else {
        throw Exception('Görev eklenemedi.');
      }
    } catch (e) {
      print('Hata oluştu: $e');
    }
  }

  Future<void> deleteToDoApi(int id) async {
    final dio = Dio();
    final url = 'https://dummyjson.com/todos/$id';

    print('Silinmek istenen ID: $id');
print('Silinmek istenen URL: $url');
    try {
      final response = await dio.delete(url);

      print('----API Yanıt Kodu: ${response.statusCode}');
      print('---API Yanıtı: ${response.data}');

      if (response.statusCode == 200) {
        _todos.removeWhere((todo) => todo.id == id);

        _saveToDos();
        notifyListeners();
      } else {
        throw Exception('Görev silinemedi.');
      }
    } catch (e) {
      print('Hata oluştu: $e');
    }
  }
}
