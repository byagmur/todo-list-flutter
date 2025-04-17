// apiden gelen veriyi model'e dönüştürmek için kullanılan sınıf
import 'package:todo_app_flutter/data/models/todo_model.dart';

class ToDoDTO {
  final int id;
  final String title;
  final bool completed;

  ToDoDTO({required this.id, required this.title, required this.completed});

  factory ToDoDTO.fromJson(Map<String, dynamic> json) {
    return ToDoDTO(
      id: json['id'],
      title: json['todo'],
      completed: json['completed'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'todo': title,
    'completed': completed,
  };

  // gelen json verisini model'e dönüştür
  ToDo toModel() => ToDo(id: id, title: title, completed: completed);

  factory ToDoDTO.fromModel(ToDo model) {
    return ToDoDTO(
      id: model.id ?? 0,
      title: model.title ?? "",
      completed: model.completed ?? false,
    );
  }
}
