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

  DateTime? _selectedDate; // seçili tarih
  bool _showOnlyIncomplete = false; // yeni state
  String? _selectedCategory;
  final List<String> _categories = ['Tümü', 'İş', 'Kişisel', 'Okul'];

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

    // Doğrudan filtre fonksiyonunu kullanın:
    var todos = todoProvider.getFilteredTodos(
      searchQuery: _searchQuery,
      selectedDate: _selectedDate,
      selectedCategory: _selectedCategory,
      showOnlyIncomplete: _showOnlyIncomplete,
    );

    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: [
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
                        const SizedBox(height: 10),
                        categoryDropdownWidget(),
                        const SizedBox(height: 10),
                        datePickerWidget(),
                        const SizedBox(height: 10),
                        // Tamamlanmayanları göster butonu
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                icon: Icon(
                                  _showOnlyIncomplete
                                      ? Icons.check_box_outline_blank
                                      : Icons.check_box,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  _showOnlyIncomplete
                                      ? "Sadece tamamlanmayanlar"
                                      : "Tüm görevler",
                                  style: const TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _showOnlyIncomplete = !_showOnlyIncomplete;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
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
                            onPressed: () async {
                              if (_todoController.text.isNotEmpty) {
                                await todoProvider.addToDo(
                                  _todoController.text,
                                  category:
                                      _selectedCategory == null ||
                                              _selectedCategory == 'Tümü'
                                          ? null
                                          : _selectedCategory,
                                );
                                showInfoMessage("Görev başarıyla eklendi!");
                                _todoController.clear();
                                // fetchUserTodos çağrısını kaldırın!
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

  Widget datePickerWidget() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            icon: Icon(
              Icons.calendar_today,
              size: 18,
              color: AppTheme.primaryColor,
            ),
            label: Text(
              _selectedDate == null
                  ? "Tarihe göre filtrele"
                  : "${_selectedDate!.day}.${_selectedDate!.month}.${_selectedDate!.year}",
              style: TextStyle(color: AppTheme.primaryColor),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppTheme.primaryColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
              backgroundColor: Colors.white,
            ),
            onPressed: () async {
              DateTime now = DateTime.now();
              final picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate ?? now,
                firstDate: DateTime(now.year - 5),
                lastDate: DateTime(now.year + 5),
                locale: const Locale('tr', 'TR'),
              );
              if (picked != null) {
                setState(() {
                  _selectedDate = picked;
                });
              }
            },
          ),
        ),
        if (_selectedDate != null)
          IconButton(
            icon: Icon(Icons.clear, color: AppTheme.errorColor),
            onPressed: () {
              setState(() {
                _selectedDate = null;
              });
            },
            tooltip: "Filtreyi temizle",
          ),
      ],
    );
  }

  Widget categoryDropdownWidget() {
    return Row(
      children: [
        const Text("Kategori: ",
            style: TextStyle(
              color: AppTheme.textColor,
              fontSize: 16,
            )),
        const SizedBox(width: 8),
        DropdownButton<String>(
          style: TextStyle(
            color: AppTheme.textColor,
            fontSize: 16,
          ),
          underline: Container(
            height: 1,
            color: AppTheme.primaryColor,
          ),
          borderRadius: BorderRadius.circular(12),
          dropdownColor: Colors.white,
          icon: Icon(Icons.arrow_drop_down, color: AppTheme.primaryColor),
          value: _selectedCategory ?? 'Tümü',
          items:
              _categories
                  .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                  .toList(),
          onChanged: (value) {
            setState(() {
              _selectedCategory = value == 'Tümü' ? null : value;
            });
          },
        ),
      ],
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
