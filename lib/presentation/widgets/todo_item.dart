import 'package:flutter/material.dart';
import 'package:todo_app_flutter/constants/color.dart';
import 'package:todo_app_flutter/data/models/todo.dart';
import 'package:todo_app_flutter/theme/theme.dart';

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

class _TodoItemState extends State<TodoItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: ListTileForTodoItem(),
    );
  }

  Widget ListTileForTodoItem() {
        ThemeInheritedWidget? InheritedTheme = ThemeInheritedWidget.of(context);
    var _themeMode = InheritedTheme?.themeMode;
    return ListTile(
      onTap: () {
        widget.onToDoChanged(widget.todo);
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      tileColor: (_themeMode == ThemeMode.dark ? darkGray : lightestGray),
      leading: Icon(
        (widget.todo.completed ?? false)
            ? Icons.check_box
            : Icons.check_box_outline_blank,
        color: lightBlue,
      ),
      title: Text(
        widget.todo.title!,
        style: TextStyle(
          color: (_themeMode == ThemeMode.dark ? lightestGray : darkGray),
          decoration: (widget.todo.completed ?? false) ? TextDecoration.lineThrough : null,
        ),
      ),
      trailing: Container(
        padding: EdgeInsets.all(0),
        margin: EdgeInsets.symmetric(vertical: 12),
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          color: red,
          borderRadius: BorderRadius.circular(5),
        ),
        child: IconButton(
          color: Colors.white,
          iconSize: 15,
          icon: Icon(Icons.clear),
          alignment: Alignment.center,
          onPressed: () {
            widget.onDeleteItem(widget.todo.id);
          },
        ),
      ),
    );
  }
}