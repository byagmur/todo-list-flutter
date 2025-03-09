import 'package:flutter/material.dart';
import 'package:todo_app_flutter/constants/color.dart';
import 'package:todo_app_flutter/presentation/widgets/todo_item.dart';
import 'package:todo_app_flutter/data/models/todo.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  final todosList = ToDo.todoList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkGray,
        elevation: 0,
        title: Row(
          children: [const Icon(Icons.menu, color: lightGray, size: 25)],
        ),
      ),
      body: Stack(
        // container widget i column widget i ile sarmalandı ,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              children: [
                searchBox(),
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 22, bottom: 15),
                        child: Text(
                          'Yapılacaklar',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      for (ToDo todo in todosList()) TodoItem(todo: todo),
                    ],
                  ),
                  //listWiew componenti içerisinde for döngüsü ile todoList elemanlarını TodoItem componentine gönderdik
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 25, right: 10, bottom: 20),
                    decoration: BoxDecoration(
                      color: gray,
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(255, 56, 56, 56),
                          offset: Offset(0, 0),
                          blurRadius: 5,
                          spreadRadius: 0.0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Yeni bir görev ekleyin",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 20, right: 20),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 20, bottom: 20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: lightBlue,

                      minimumSize: Size(47, 45),
                      maximumSize: Size(47, 45),
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: EdgeInsets.all(0),
                    ),
                    onPressed: () {},
                    child: Icon(Icons.add, color: Colors.white, size: 30),
                    // child: Text(
                    //   "+",
                    //   textAlign: TextAlign.center,
                    //   style: TextStyle(fontSize: 15, color: Colors.white),
                    // ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // searchBox custom component haline getirildi ve HomePage içerisinde kullanıldı
  Container searchBox() {
    return Container(
      margin: EdgeInsets.only(top: 15, left: 15, right: 15),
      decoration: BoxDecoration(
        color: darkGray,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: const Icon(Icons.search, color: lightGray),
          prefixIconConstraints: BoxConstraints(maxHeight: 40, minWidth: 50),
          border: InputBorder.none,
          hintText: 'Arama yap',
          hintStyle: TextStyle(color: lightGray),
        ),
      ),
    );
  }
}
