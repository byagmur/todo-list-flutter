import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app_flutter/data/dto/todo_dto.dart';
import 'package:todo_app_flutter/data/models/todo_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app_flutter/presentation/screens/login_screen.dart';

class TodoProvider with ChangeNotifier {
  List<ToDo> _todos = [];
  List<ToDo> get todos => _todos;

  TodoProvider() {
    // _loadToDos();
    fetchUserTodos(globalUserId!);
  }

  Future<void> toggleToDo(String id) async {
    int index = _todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      bool newCompleted = !(_todos[index].completed ?? false);
      _todos[index].completed = newCompleted;
      notifyListeners();
      try {
        await FirebaseFirestore.instance.collection('todos').doc(id).update({
          'isCompleted': newCompleted,
        });
      } catch (e) {
        print("Firestore güncelleme hatası: $e");
      }
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

  // Future<void> _loadToDos() async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     bool firstRun = prefs.getBool('firstRun') ?? true;

  //     if (firstRun) {
  //       String? userId = globalUserId;
  //       await fetchUserTodos(userId!);
  //       await prefs.setBool('firstRun', false);
  //     } else {
  //       String? todosString = prefs.getString('todos');
  //       if (todosString != null) {
  //         List<dynamic> decodedData = jsonDecode(todosString);
  //         _todos =
  //             decodedData
  //                 .map((item) {
  //                   return ToDoDTO.fromJson(
  //                     item,
  //                     item['id'] ?? '', // id null ise boş string gönder
  //                   ).toModel();
  //                 })
  //                 // userId eşleşmesini kontrol et
  //                 .where((todo) => todo.userId == globalUserId)
  //                 .toList();
  //       }
  //     }

  //     notifyListeners();
  //   } catch (e) {
  //     print("Hata oluştu: $e");
  //   }
  // }

  Future<void> fetchUserTodos(String userId) async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance
              .collection('todos')
              .where('userId', isEqualTo: userId)
              .get();

      _todos =
          snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return ToDoDTO.fromJson(
              data,
              doc.id, // Firestore'daki belge ID'sini kullan
            ).toModel();
          }).toList();

      notifyListeners();
    } catch (e) {
      print("Görevleri yüklerken hata: $e");
    }
  }

  Future<void> addToDo(String title, {String? category}) async {
    try {
      final now = DateTime.now();
      final todoData = {
        'title': title,
        'isCompleted': false,
        'userId': globalUserId,
        'createdAt': now.toIso8601String(),
        'category': category, // yeni alan
      };
      final docRef = await FirebaseFirestore.instance
          .collection('todos')
          .add(todoData);

      final newTodo = ToDo(
        id: docRef.id,
        title: title,
        completed: false,
        userId: globalUserId,
        createdAt: now,
        category: category,
      );
      _todos.add(newTodo);
      notifyListeners();
    } catch (e) {
      print("Todo eklerken hata: $e");
    }
  }

  Future<void> deleteToDo(String id) async {
    try {
      await FirebaseFirestore.instance.collection('todos').doc(id).delete();
      _todos.removeWhere((todo) => todo.id == id);
      notifyListeners();
    } catch (e) {
      print("Todo silinirken hata: $e");
    }
  }

  Future<void> updateToDoTitle(String id, String newTitle) async {
    int index = _todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      try {
        await FirebaseFirestore.instance.collection('todos').doc(id).update({
          'title': newTitle,
        });
        _todos[index].title = newTitle;
        notifyListeners();
      } catch (e) {
        print("Todo güncellenirken hata: $e");
        rethrow;
      }
    }
  }

  List<ToDo> getFilteredTodos({
    String searchQuery = '',
    DateTime? selectedDate,
    String? selectedCategory,
    bool showOnlyIncomplete = false,
  }) {
    return _todos.where((todo) {
      final titleMatch = (todo.title ?? '').toLowerCase().contains(
        searchQuery.toLowerCase(),
      );
      final categoryMatch =
          (selectedCategory == null || selectedCategory == 'Tümü')
              ? true
              : (todo.category == selectedCategory);
      final incompleteMatch =
          showOnlyIncomplete ? !(todo.completed ?? false) : true;
      final dateMatch =
          (selectedDate == null || todo.createdAt == null)
              ? true
              : (todo.createdAt!.year == selectedDate.year &&
                  todo.createdAt!.month == selectedDate.month &&
                  todo.createdAt!.day == selectedDate.day);
      return titleMatch && categoryMatch && incompleteMatch && dateMatch;
    }).toList();
  }
}
