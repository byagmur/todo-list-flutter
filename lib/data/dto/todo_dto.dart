// apiden gelen veriyi model'e dönüştürmek için kullanılan sınıf
import 'package:todo_app_flutter/data/models/todo_model.dart';

class ToDoDTO {
  final String id;
  final String title;
  final bool isCompleted;
  final DateTime? createdAt;
  final String? category; // yeni alan

  ToDoDTO({
    required this.id,
    required this.title,
    required this.isCompleted,
    this.createdAt,
    this.category,
  });

  factory ToDoDTO.fromJson(Map<String, dynamic> json, String documentId) {
    return ToDoDTO(
      id: documentId,
      title: json['title'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
      createdAt:
          json['createdAt'] != null
              ? DateTime.tryParse(json['createdAt'])
              : null,
      category: json['category'], // yeni alan
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'isCompleted': isCompleted,
    'createdAt': createdAt?.toIso8601String(),
    'category': category,
  };

  // id artık string olarak model'e aktarılıyor
  ToDo toModel() => ToDo(
    id: id,
    title: title,
    completed: isCompleted,
    createdAt: createdAt,
    category: category,
  );

  factory ToDoDTO.fromModel(ToDo model) {
    return ToDoDTO(
      id: (model.id ?? '').toString(), //
      title: model.title as String,
      isCompleted: model.completed as bool,
      createdAt: model.createdAt,
      category: model.category,
    );
  }
}
