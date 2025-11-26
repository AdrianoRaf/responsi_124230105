import 'package:flutter/material.dart';
import 'package:news/pages/Homepage.dart';
import 'package:news/pages/RegisterPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _checkIfAlreadyLoggedIn();
  }

  Future<void> _checkIfAlreadyLoggedIn() async {
    _prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = _prefs.getBool('login') ?? false;
    if (isLoggedIn) {
      String username = _prefs.getString('username') ?? '';
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(username: username)));
    }
  }

  Future<void> _login() async {
    // Simpan status login di SharedPreferences
    await _prefs.setBool('login', true);
    await _prefs.setString('username', usernameController.text.trim());

    // Navigasi ke halaman Home
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) =>
              HomePage(username: usernameController.text.trim())),
    );

    // Tampilkan pesan sukses
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Login Berhasil'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          centerTitle: true,
          title: Text("Login Page"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 20),
                  Image.asset('images/lock.jpg'),
                  SizedBox(height: 20),
                  _usernameField(),
                  SizedBox(height: 16),
                  _passwordField(),
                  SizedBox(height: 16),
                  _loginButton(),
                  const SizedBox(height: 20),
                  // Pesan untuk pengguna yang belum memiliki akun
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          // Navigasi ke halaman pendaftaran
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterPage()),
                          );
                        },
                        child: const Text(
                          "Register here",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _usernameField() {
    return TextFormField(
      controller: usernameController,
      decoration: InputDecoration(
        labelText: 'Username',
        contentPadding: EdgeInsets.all(8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
    );
  }

  Widget _passwordField() {
    return TextFormField(
      controller: passwordController,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
        contentPadding: EdgeInsets.all(8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
    );
  }

  Widget _loginButton() {
    return ElevatedButton(
      onPressed: _login,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blueGrey,
        padding: EdgeInsets.symmetric(vertical: 15),
        minimumSize: Size(double.infinity, 50), // Lebar tombol penuh
      ),
      child: Text("Login"),
    );
  }
}
