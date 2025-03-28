import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_flutter/constants/app_Strings.dart';
import 'package:todo_app_flutter/constants/color.dart';
import 'package:todo_app_flutter/data/models/todo.dart';
import 'package:todo_app_flutter/presentation/widgets/loader.dart';
import 'package:todo_app_flutter/providers/todo_provider.dart';
import 'package:todo_app_flutter/theme/theme.dart';
import 'package:todo_app_flutter/presentation/widgets/todo_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  final _todoController =
      TextEditingController(); // görev ekleme text alanı için controller
  var _isLoading = true;

    void changeLoading() {
      setState(() {
        _isLoading = !_isLoading;
      });
    }

  String _searchQuery = '';
  void initState() {
    super.initState();
    ToDo.fetchTodos();
    changeLoading();
    
  }

  @override
  Widget build(BuildContext context) {
    var todoProvider = Provider.of<TodoProvider>(context);
    ThemeInheritedWidget? InheritedTheme = ThemeInheritedWidget.of(context);
    var _themeMode = InheritedTheme?.themeMode;
    var todos =
        todoProvider.todos
            .where(
              (todo) => todo.title!.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ),
            )
            .toList();

    const WidgetStateProperty<Icon> thumbIcon =
        WidgetStateProperty<Icon>.fromMap(<WidgetStatesConstraint, Icon>{
          WidgetState.selected: Icon(Icons.brightness_2, color: Colors.black),
          WidgetState.any: Icon(Icons.sunny),
        });

  

    return Scaffold(
      appBar: AppBar(
        // leading: Switch(
        //   padding: const EdgeInsets.only(left: 10),
        //  thumbIcon: thumbIcon,
        //   activeColor: const Color.fromARGB(255, 241, 241, 241),
        //   value: _themeMode == ThemeMode.dark,
        //   onChanged: (value) {
        //   InheritedTheme?.toggleTheme();

        // }) ,
        // actions: [_isLoading ? const CircularProgressIndicator(
        //   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),

        // ) : const SizedBox.shrink()],
        backgroundColor:
            (_themeMode == ThemeMode.dark ? darkGray : lightestGray),
        shadowColor: gray,
        elevation: 0,
        toolbarHeight: 55,
        // title: Row(children: [const Icon(Icons.access_time, color: lightGray, size: 25)]),
      ),
      body: (_isLoading == true ) ? Loader() : 
      Stack(
        // stack widget ı ile search box ve görevler üst üste konuldu
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              children: [
                searchBox(),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    //.builder ile yalnızca ekranda gözüken itemler oluşturulur bu yapıyı kullanmamızdaki amaç
                    //ekranda gözükmeyen elemanların bellekte yer kaplamamasıdır
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final todo = todos[index];
                      return TodoItem(
                        todo: todo,
                        onToDoChanged: (_) {
                          //_, parametrenin kullanılmadığını belirtmek için kullanılan bir Dart diline özgü bir semboldür
                          if (todo.id != null) {
                            todoProvider.toggleToDo(todo.id!);
                          }
                        },
                        onDeleteItem: (_) {
                          if (todo.id != null) {
                            todoProvider.deleteToDo(todo.id!);
                          }
                        },
                      );
                    },
                  ),
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
                    margin: const EdgeInsets.only(
                      left: 25,
                      right: 10,
                      bottom: 20,
                    ),
                    decoration: BoxDecoration(
                      color: (_themeMode == ThemeMode.dark ? gray : null),
                      boxShadow: [
                        BoxShadow(
                          color:
                              (_themeMode == ThemeMode.dark
                                  ? Color.fromARGB(255, 56, 56, 56)
                                  : const Color.fromARGB(255, 236, 236, 236)),
                          offset: Offset(0, 0),
                          blurRadius: 5,
                          spreadRadius: 0.0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: _todoController,
                      decoration: const InputDecoration(
                        hintText: AppStrings.addNewTask,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 20, right: 20),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 20, bottom: 20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(0),
                      backgroundColor: lightBlue,
                      minimumSize: const Size(47, 45),
                      maximumSize: const Size(47, 45),
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      if (_todoController.text.isNotEmpty) {
                        todoProvider.addToDo(_todoController.text);
                        _todoController.clear();
                      }
                    },
                    child: Center(
                      child: Icon(
                        Icons.add,
                        color:
                            (_themeMode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black),
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget searchBox() {
    return Container(
      margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
      decoration: BoxDecoration(
        color: darkGray,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        onChanged: (value) => setState(() => _searchQuery = value),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(0),
          //texti hizalamak için
          prefixIconConstraints: BoxConstraints(minWidth: 50),
          prefixIcon: Icon(Icons.search, color: lightGray),
          border: InputBorder.none,
          hintText: AppStrings.searchTask,
          hintStyle: TextStyle(color: lightGray),
        ),
      ),
    );
  }
}
