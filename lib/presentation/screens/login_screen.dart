import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app_flutter/constants/app_strings.dart';
import 'package:todo_app_flutter/constants/color.dart';
import 'package:todo_app_flutter/constants/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_flutter/providers/todo_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? globalUserId; // Global kullanıcı ID'si

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // Giriş başarılı
      print("Giriş başarılı: ${userCredential.user?.uid}");

      // Kullanıcı ID'sini global değişkene ata
      globalUserId = userCredential.user!.uid;

      // Kullanıcı ID'sini localde sakla
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', globalUserId!);

      // Check if the widget is still mounted before navigating
      if (mounted) {
        // TodoProvider'dan görevleri yükle
        Provider.of<TodoProvider>(
          context,
          listen: false,
        ).fetchUserTodos(globalUserId!);

        // Ana sayfaya yönlendir
        context.go('/home');
      }
    } catch (e) {
      String errorMessage;
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'Kullanıcı bulunamadı.';
            break;
          case 'wrong-password':
            errorMessage = 'Parola hatalı.';
            break;
          case 'invalid-email':
            errorMessage = 'Geçersiz e-posta adresi.';
            break;
          case 'email-already-in-use':
            errorMessage = 'Bu e-posta adresi zaten kullanılıyor.';
            break;
          default:
            errorMessage = 'Bir hata oluştu. Lütfen tekrar deneyin.';
        }
      } else {
        errorMessage = 'Bir hata oluştu. Lütfen tekrar deneyin.';
      }

      // Hata mesajını göster
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline_outlined, color: Colors.red, size: 20),
                const SizedBox(width: 8),
                Text(errorMessage, style: TextStyle(color: Colors.red)),
              ],
            ),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Card(
                    elevation: 8,
                    shadowColor: Colors.grey.withOpacity(0.2),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.lock,
                              size: 80,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 32),
                          TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(color: Colors.black),
                              labelText: 'Email',
                              labelStyle: TextStyle(
                                color: const Color.fromARGB(162, 37, 37, 37),
                              ),
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              prefixIcon: Icon(
                                Icons.person,
                                color: Colors.black,
                              ),
                              border: OutlineInputBorder(),
                            ),
                            style: TextStyle(color: Colors.black),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: 'Şifre',
                              labelStyle: TextStyle(
                                color: const Color.fromARGB(162, 37, 37, 37),
                              ),
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              prefixIcon: Icon(Icons.lock, color: Colors.black),
                              border: OutlineInputBorder(),
                            ),
                            style: TextStyle(color: Colors.black),
                            obscureText: true,
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () {},
                            child: Text('Şifrenizi mi unuttunuz?'),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black87,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(double.infinity, 50),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                              ),
                              child: Text('Giriş Yap'),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(width: 8),
                              Container(
                                child: _buildSocialButton(
                                  Icons.g_mobiledata,
                                  () {},
                                ),
                              ),
                              const SizedBox(width: 16),
                              Container(
                                child: _buildSocialButton(Icons.apple, () {}),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () {},
                                child: Text('Kayıt Ol'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(51),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon),
        onPressed: onPressed,
        color: AppTheme.primaryColor,
      ),
    );
  }
}
