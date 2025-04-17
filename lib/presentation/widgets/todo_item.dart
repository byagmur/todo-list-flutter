// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:todo_app_flutter/constants/theme.dart';
import 'package:todo_app_flutter/data/models/todo_model.dart';

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

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    
    _opacityAnimation = Tween<double>(begin: 0.0, end:1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
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
      leading: Icon(
        (widget.todo.completed ?? false)
            ? Icons.check_box
            : Icons.check_box_outline_blank,
        color: AppTheme.primaryColor,
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
      trailing: Container(
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
    );
  }
}
