// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_flutter/constants/theme.dart';
import 'package:todo_app_flutter/data/models/todo_model.dart';
import 'package:todo_app_flutter/providers/todo_provider.dart';

class TodoItem extends StatefulWidget {
  final ToDo todo;
  final onToDoChanged;
  final onDeleteItem;

  const TodoItem({
    super.key,
    required this.todo,
    required this.onToDoChanged,
    required this.onDeleteItem,
  });

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward(); //forward animasyonu başlatır
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withAlpha(51),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTileForTodoItem(),
    );
  }

  Widget ListTileForTodoItem() {
    return ListTile(
      onTap: () {
        widget.onToDoChanged(widget.todo);
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      tileColor: Colors.white,
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if ((widget.todo.category ?? '').isNotEmpty)
            Container(
              width: 12,
              height: 32,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: _categoryColor(widget.todo.category),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          Icon(
            (widget.todo.completed ?? false)
                ? Icons.check_box
                : Icons.check_box_outline_blank,
            color: AppTheme.primaryColor,
          ),
        ],
      ),
      title: Text(
        widget.todo.title!,
        style: TextStyle(
          color: AppTheme.textColor,
          fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
          decoration:
              (widget.todo.completed ?? false)
                  ? TextDecoration.lineThrough
                  : null,
          decorationColor: AppTheme.hintColor,
          decorationStyle: TextDecorationStyle.solid,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Düzenle butonu
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue, size: 18),
            tooltip: "Başlığı Düzenle",
            onPressed: () async {
              final newTitle = await showDialog<String>(
                context: context,
                builder:
                    (context) =>
                        _EditTodoDialog(initialTitle: widget.todo.title ?? ""),
              );
              if (newTitle != null &&
                  newTitle.trim().isNotEmpty &&
                  newTitle != widget.todo.title) {
                try {
                  await Provider.of<TodoProvider>(
                    context,
                    listen: false,
                  ).updateToDoTitle(widget.todo.id!, newTitle.trim());
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Başlık başarıyla güncellendi."),
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Başlık güncellenemedi!")),
                    );
                  }
                }
              }
            },
          ),
          // Sil butonu
          Container(
            padding: EdgeInsets.zero,
            margin: const EdgeInsets.symmetric(vertical: 12),
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              color: AppTheme.errorColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: IconButton(
              color: Colors.white,
              iconSize: 15,
              icon: const Icon(Icons.clear),
              alignment: Alignment.center,
              onPressed: () {
                widget.onDeleteItem(widget.todo.id);
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _categoryColor(String? category) {
    switch ((category ?? '').toLowerCase()) {
      case 'iş':
        return Colors.blue;
      case 'kişisel':
        return Colors.orange;
      case 'okul':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

// Modal dialog widget'ı
class _EditTodoDialog extends StatefulWidget {
  final String initialTitle;
  const _EditTodoDialog({required this.initialTitle});

  @override
  State<_EditTodoDialog> createState() => _EditTodoDialogState();
}

class _EditTodoDialogState extends State<_EditTodoDialog> {
  late TextEditingController _controller;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialTitle);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      setState(() {
        _errorText = "Başlık boş olamaz!";
      });
      return;
    }
    Navigator.of(context).pop(text);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Görev Başlığını Düzenle"),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: InputDecoration(labelText: "Başlık", errorText: _errorText),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("İptal"),
        ),
        ElevatedButton(onPressed: _submit, child: const Text("Kaydet")),
      ],
    );
  }
}
