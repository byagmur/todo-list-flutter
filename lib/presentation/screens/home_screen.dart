import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app_flutter/constants/app_strings.dart';
import 'package:todo_app_flutter/constants/color.dart';
import 'package:todo_app_flutter/constants/theme.dart';
import 'package:todo_app_flutter/presentation/screens/login_screen.dart';
import 'package:todo_app_flutter/presentation/widgets/loader.dart';
import 'package:todo_app_flutter/providers/todo_provider.dart';
import 'package:todo_app_flutter/presentation/widgets/todo_item.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _todoController = TextEditingController();
  var _isLoading = true;
  bool _isLoggingOut = false;

  String? _infoMessage;
  Timer? _infoTimer;

  void showInfoMessage(String message) {
    setState(() {
      _infoMessage = message;
    });
    _infoTimer?.cancel();
    _infoTimer = Timer(const Duration(seconds: 2), () {
      setState(() {
        _infoMessage = null;
      });
    });
  }

  @override
  void dispose() {
    _todoController.dispose();
    _infoTimer?.cancel();
    super.dispose();
  }

  void changeLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  String _searchQuery = '';
  @override
  void initState() {
    super.initState();
    _loadUserId();
    changeLoading();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    globalUserId = prefs.getString('userId');
  }

  Future<void> _logout(BuildContext context) async {
    setState(() {
      _isLoggingOut = true;
    });
    try {
      await FirebaseAuth.instance.signOut();
      globalUserId = null;
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('userId');
      // İsterseniz local user verilerini de temizleyebilirsiniz
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // await prefs.clear();
      if (mounted) {
        context.go('/');
      }
    } catch (e) {
      // Hata durumunda loader'ı kapat
      setState(() {
        _isLoggingOut = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Çıkış sırasında hata oluştu')));
    }
  }

  @override
  Widget build(BuildContext context) {
    var todoProvider = Provider.of<TodoProvider>(context);
    var todos =
        todoProvider.todos
            .where(
              (todo) => (todo.title ?? '').toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ),
            )
            .toList();

    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: [
          //actions kısmı sağdaki iconlar
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.logout, color: AppTheme.textColor, size: 24),
                onPressed: () {
                  _logout(context);
                },
              ),
              const SizedBox(width: 10),
            ],
          ),
        ],
        backgroundColor: Colors.white,
        shadowColor: gray,
        elevation: 0,
        toolbarHeight: 55,
      ),
      body:
          (_isLoading == true || _isLoggingOut)
              ? Loader()
              : Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color.fromARGB(255, 235, 235, 235),
                          const Color.fromARGB(255, 255, 255, 255),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                    child: Column(
                      children: [
                        searchBox(),
                        const SizedBox(height: 20),
                        if (_infoMessage != null)
                          _widgetInfoMessage(infoMessage: _infoMessage),
                        Expanded(
                          child: ListView.builder(
                            itemCount: todos.length,
                            itemBuilder: (context, index) {
                              final todo = todos[index];
                              return AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: TodoItem(
                                  key: ValueKey(todo.id),
                                  todo: todo,
                                  onToDoChanged: (_) {
                                    if (todo.id != null) {
                                      todoProvider.toggleToDo(todo.id!);
                                    }
                                  },
                                  onDeleteItem: (_) {
                                    if (todo.id != null) {
                                      todoProvider.deleteToDo(todo.id!);
                                    }
                                  },
                                ),
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
                              color: AppTheme.surfaceColor,

                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primaryColor.withAlpha(51),
                                  offset: const Offset(0, 0),
                                  blurRadius: 5,
                                  spreadRadius: 0.0,
                                ),
                              ],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TextField(
                              style: TextStyle(color: AppTheme.textColor),
                              controller: _todoController,
                              decoration: InputDecoration(
                                hintText: AppStrings.addNewTask,
                                hintStyle: TextStyle(color: AppTheme.hintColor),
                                border: InputBorder.none,

                                contentPadding: const EdgeInsets.only(
                                  left: 20,
                                  right: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 20, bottom: 20),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              backgroundColor: AppTheme.primaryColor,
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
                                showInfoMessage("Görev başarıyla eklendi!");
                                _todoController.clear();
                              }
                            },
                            child: const Center(
                              child: Icon(
                                Icons.add,

                                color: Colors.white,
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
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withAlpha(51),
            offset: const Offset(0, 0),
            blurRadius: 5,
            spreadRadius: 0.0,
          ),
        ],
      ),
      child: TextField(
        onChanged: (value) => setState(() => _searchQuery = value),
        style: TextStyle(color: AppTheme.textColor),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          prefixIconConstraints: const BoxConstraints(minWidth: 50),
          prefixIcon: Icon(Icons.search, color: AppTheme.primaryColor),
          border: InputBorder.none,
          hintText: AppStrings.searchTask,
          hintStyle: TextStyle(color: AppTheme.hintColor),
        ),
      ),
    );
  }
}

class _widgetInfoMessage extends StatelessWidget {
  const _widgetInfoMessage({super.key, required String? infoMessage})
    : _infoMessage = infoMessage;

  final String? _infoMessage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: AnimatedOpacity(
        opacity: _infoMessage != null ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.green[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            _infoMessage ?? '',
            style: const TextStyle(color: Colors.green, fontSize: 15),
          ),
        ),
      ),
    );
  }
}
