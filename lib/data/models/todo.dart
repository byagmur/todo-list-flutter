import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app_flutter/presentation/screens/home.dart';

void main() async {
  try {
    await ToDo.fetchTodos();
    print(ToDo.todoList); // Verilerin geldiğini görmek için
  } catch (e) {
    print("Hata oluştu: $e");
  }
}

class ToDo {
  int? id;
  String? title;
  bool? completed;
  int? userId;

  ToDo({
    //constructor
    required this.id,
    required this.title,
    this.completed = false,
    this.userId,
  });

  // toJson: ToDo nesnesini Map'e dönüştürme, apiye veri gönderirken kullanılır.
  Map<String, dynamic> toJson() {
    return {'id': id, 'todo': title, 'completed': completed, 'userId': userId};
  }

  // fromJson: Map'ten ToDo nesnesi oluşturma, apiden veri çektikten sonra json veriyi ToDo nesnesine dönüştürmek için kullanılır.
  factory ToDo.fromJson(Map<String, dynamic> json) {
    return ToDo(
      id: json['id'],
      title: json['todo'] ?? "boş",
      completed: json['completed'] ?? false, // Varsayılan değer false
      userId: json['userId'],
    );
  }

  static List<ToDo> todoList = [
    //   ToDo(id: '1', title: 'Mailleri kontrol et', completed: true),
    //   ToDo(id: '2', title: 'Markete git'),
    //   ToDo(id: '3', title: 'Alışveriş yap'),
    //   ToDo(id: '4', title: 'Yürüyüşe çık'),
    //  ToDo(id: '5', title: 'Kitap oku'),
  ];

  //verileri apiden çekmeyi dene!

  //apiden verileri çekiyoruz
  // static Future<List<ToDo>> fetchTodos() async {
  //   final url = Uri.parse('https://dummyjson.com/todos');
  //   final response = await http.get(url);

  //   if (response.statusCode == 200) {
  //     Map<String, dynamic> jsonData = jsonDecode(response.body,); // Map olarak çözümle
  //     List<dynamic> todosList = jsonData['todos']; // 'todos' anahtarına eriş
  //     todoList =todosList
  //             .map((item) => ToDo.fromJson(item))
  //             .take(5)
  //             .toList(); // İlk 5 elemanı al
  //     return todoList;
  //   } else {
  //     print("HELP");
  //     throw Exception('veriler yüklenemedi..');
  //   }
  // }

  static Future<List<ToDo>> fetchTodos() async {
   

    final dio = Dio(); // Dio nesnesini oluştur
    final url = 'https://dummyjson.com/todos';

    try {
      
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        List<dynamic> todosList =
            response
                .data['todos']; //dio , http kütüphanesinden farklı olarak otomatik json decode yapar

        return todosList
            .map((item) => ToDo.fromJson(item))
            .take(5)
            .toList(); // İlk 5 elemanı al
        
      } else {
        throw Exception('Veriler yüklenemedi.');
      }
    } catch (e) {
      print('Hata: $e');
      throw Exception('Bir hata oluştu.');
    }
  }
}
