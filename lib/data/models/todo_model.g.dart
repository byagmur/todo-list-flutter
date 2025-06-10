// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ToDo _$ToDoFromJson(Map<String, dynamic> json) => ToDo(
      id: json['id'] as String?,
      title: json['title'] as String?,
      completed: json['completed'] as bool? ?? false,
      userId: json['userId'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      category: json['category'] as String?,
    );

Map<String, dynamic> _$ToDoToJson(ToDo instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'completed': instance.completed,
      'userId': instance.userId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'category': instance.category,
    };
