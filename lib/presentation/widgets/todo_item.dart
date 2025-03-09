import 'package:flutter/material.dart';
import 'package:todo_app_flutter/constants/color.dart';
import 'package:todo_app_flutter/data/models/todo.dart';

class TodoItem extends StatelessWidget {
  final ToDo todo;
  const TodoItem({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: ListTileForTodoItem(),
    );
  }

  ListTile ListTileForTodoItem() {
    return ListTile(
      onTap: () {},
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      tileColor: darkGray,
      leading: Icon(
        (todo.isDone ?? false)
            ? Icons.check_box
            : Icons.check_box_outline_blank,
        color: lightBlue,
      ),
      title: Text(
        todo.title!, //dinamik olarak title değerini alıyoruz
        style: TextStyle(
          color: lightGray,
          decoration:
              (todo.isDone ?? false) ? TextDecoration.lineThrough : null,
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
          alignment:
              Alignment
                  .center, //ikon boyutu kutu boyutunun yarısı kadar olmazsa ortalamıyor ve hata veriyor!
          onPressed: () {
            print('konsol deneme');
          },
        ),
      ),
    );
  }
}
