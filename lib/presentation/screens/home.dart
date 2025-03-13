import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app_flutter/constants/color.dart';
import 'package:todo_app_flutter/presentation/widgets/todo_item.dart';
import 'package:todo_app_flutter/data/models/todo.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //var vTodosList = ToDo.todoList;
  final _todoController = TextEditingController();
  List<ToDo> _searchToDo = [];

    List<ToDo> _fullToDoList = []; // Tam listeyi saklamak için

  @override
  void initState() {
    super.initState();
      _searchToDo = []; // Başlangıçta boş liste
    _loadToDos(); // Uygulama açıldığında kayıtlı verileri yükle
    

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false, //klavye açıldığında ekranın kaymasını engeller
      appBar: AppBar(
        backgroundColor: darkGray,
        elevation: 0,
        toolbarHeight: 55,
        title: Row(
          children: [const Icon(Icons.access_time, color: lightGray, size: 25)
          ,],
        ),
      ),
      body: Stack(
        // container widget i column widget i ile sarmalandı ,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                      for (ToDo _todo in _searchToDo /*vTodosList*/ )
                        TodoItem(
                          todo: _todo,
                          onToDoChanged: _handleToDoChange,
                          onDeleteItem:
                              _deleteToDoItem, //TodoItem componentine gönderilen fonksiyonlar
                        ),
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
                  child: SingleChildScrollView(
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
                        controller: _todoController,
                        decoration: InputDecoration(
                          hintText: "Yeni bir görev ekleyin",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 20, right: 20),
                        ),
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
                    onPressed: () {
                      if (_todoController.text.isNotEmpty) {
                        _addToDoItem(_todoController.text);
                      }
                    },
                    child: Icon(Icons.add, color: Colors.white, size: 30),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

void _deleteToDoItem(String id) {
  setState(() {
    _searchToDo.removeWhere((todo) => todo.id == id);
    _fullToDoList.removeWhere((todo) => todo.id == id); // Tam listeden de siliyoruz
    _saveToDos();
  });
}


 void _addToDoItem(String _toDo) {
  setState(() {
    final newToDo = ToDo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _toDo,
    );
    _searchToDo.add(newToDo);
    _fullToDoList.add(newToDo); // Tam listeye de ekliyoruz
    _todoController.clear();
    _saveToDos();
  });
}

  void _handleToDoChange(ToDo _todo) {
    setState(() {
      _todo.isDone = !(_todo.isDone ?? false);
    });
    print(
      _todo.isDone,
    ); //StatefulWidget olarak değiştirdikten sonra, widget.todo ifadesini kullandık çünkü
    // StatefulWidget'lar, dışarıdan gelen verilere (todo gibi) widget üzerinden erişir.
  }

void _filteredSearch(String query) {
  List<ToDo> results = [];

  if (query.isNotEmpty) {
    // Eğer arama yapılmışsa, query'ye göre listeyi filtrele
    results = _fullToDoList.where((item) => item.title!.toLowerCase().contains(query.toLowerCase())).toList();
  } else {
    // Eğer arama boşsa, tam listeyi göster
    results = _fullToDoList;
  }

  setState(() {
    _searchToDo = results;
  });
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
        
        onChanged: 
        (value) => _filteredSearch(value),
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

  Future<void> _saveToDos() async {
    //verileri kaydet
    try {
      final prefs = await SharedPreferences.getInstance();
      String encodedData = jsonEncode(
        _searchToDo.map((todo) => todo.toJson()).toList(),
      );
      await prefs.setString('todos', encodedData);
    } on Exception catch (e) {
      print("Hata oluştu" + e.toString());
    }
  }

Future<void> _loadToDos() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    String? todosString = prefs.getString('todos');
    if (todosString != null) {
      List<dynamic> decodedData = jsonDecode(todosString);
      setState(() {
         _fullToDoList = decodedData.map((item) => ToDo.fromJson(item)).toList();
        _searchToDo = _fullToDoList; // Başlangıçta tam listeyi göster
      });
    }
  } catch (e) {
    print("Hata oluştu: $e");
  }
}

}
