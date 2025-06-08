// apiden gelen veriyi model'e dönüştürmek için kullanılan sınıf
import 'package:todo_app_flutter/data/models/todo_model.dart';

class ToDoDTO {
  final String id;
  final String title;
  final bool isCompleted;

  ToDoDTO({required this.id, required this.title, required this.isCompleted});

  factory ToDoDTO.fromJson(Map<String, dynamic> json, String documentId) {
    return ToDoDTO(
      id: documentId,
      title: json['title'] ?? '', // Eksikse boş string
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'isCompleted': isCompleted,
  };

  // id artık string olarak model'e aktarılıyor
  ToDo toModel() => ToDo(id: id, title: title, completed: isCompleted);

  factory ToDoDTO.fromModel(ToDo model) {
    return ToDoDTO(
      id:
          (model.id ?? '')
              .toString(), // null ise boş string, String'e dönüştürüldü
      title: model.title as String,
      isCompleted: model.completed as bool,
    );
  }
}
