import 'dart:convert';
import 'package:http/http.dart' as http;

class ToDo {
  String? id;
  String? title;
  bool? isDone;

  ToDo({ //constructor
    required this.id, 
    required this.title, 
    this.isDone = false});

 // toJson: ToDo nesnesini Map'e dönüştürme, apiye veri gönderirken kullanılır.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isDone': isDone,
    };
  }

  // fromJson: Map'ten ToDo nesnesi oluşturma, apiden veri çektikten sonra json veriyi ToDo nesnesine dönüştürmek için kullanılır.
  factory ToDo.fromJson(Map<String, dynamic> json) {
    return ToDo(
      id: json['id'],
      title: json['title'],
      isDone: json['isDone'] ?? false,  // Varsayılan değer false
    );
  }


static List<ToDo> todoList = [
  ToDo(id: '1', title: 'Mailleri kontrol et', isDone: true),
  ToDo(id: '2', title: 'Markete git'),
  ToDo(id: '3', title: 'Alışveriş yap'),
  ToDo(id: '4', title: 'Yürüyüşe çık'),
 ToDo(id: '5', title: 'Kitap oku'),
];

  //verileri apiden çekmeyi dene!

  // factory ToDo.fromJson(Map<String, dynamic> json) {
  //   return ToDo(
  //     id: json['id'],
  //     title: json['title'],
  //     isDone: json['isDone'],
  //   ); //ilgili alanları json'dan alıp ToDo nesnesine bind ediyoruz..
  // }

  // //apiden verileri çekiyoruz
  // static Future<List<ToDo>> fetchTodos() async {
  //   final url =  Uri.parse("https://jsonplaceholder.typicode.com/todos");
  //   final response = await http.get(url);

  //   if (response.statusCode == 200) {
  //     List<dynamic> jsonData = jsonDecode(response.body);
  //     return jsonData.map((item) => ToDo.fromJson(item)).toList();
  //   } else {
  //     throw Exception('veriler yüklenemedi..');
  //   }
  // }
}
