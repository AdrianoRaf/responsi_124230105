import 'package:flutter/material.dart';
import 'package:news/pages/LoginPage.dart';
import 'package:news/util/Shared_Preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String username = "";
  String password = "";
  String confirmPassword = "";
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text("Register Page"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  SizedBox(height: 0.001),
                  Image.asset('images/lock.jpg'),
                  SizedBox(height: 16),
                  _usernameField(),
                  SizedBox(height: 16),
                  _passwordField(),
                  SizedBox(height: 16),
                  _confirmPasswordField(),
                  SizedBox(height: 16),
                  _registerButton(context),
                  const SizedBox(height: 20),
                  // Pesan untuk pengguna yang sudah memiliki akun
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                          );
                        },
                        child: const Text(
                          "Login here",
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
      onChanged: (value) {
        setState(() {
          username = value;
        });
      },
      decoration: InputDecoration(
        labelText: "Username",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.blue),
        ),
      ),
    );
  }

  Widget _passwordField() {
    return TextFormField(
      onChanged: (value) {
        setState(() {
          password = value;
        });
      },
      obscureText: !isPasswordVisible,
      decoration: InputDecoration(
        labelText: "Password",
        suffixIcon: IconButton(
          icon:
              Icon(isPasswordVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              isPasswordVisible = !isPasswordVisible;
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.blue),
        ),
      ),
    );
  }

  Widget _confirmPasswordField() {
    return TextFormField(
      onChanged: (value) {
        setState(() {
          confirmPassword = value;
        });
      },
      obscureText: !isConfirmPasswordVisible,
      decoration: InputDecoration(
        labelText: "Confirm Password",
        suffixIcon: IconButton(
          icon: Icon(isConfirmPasswordVisible
              ? Icons.visibility
              : Icons.visibility_off),
          onPressed: () {
            setState(() {
              isConfirmPasswordVisible = !isConfirmPasswordVisible;
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.blue),
        ),
      ),
    );
  }

  Widget _registerButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (password == confirmPassword) {
          // Simpan akun ke SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('username', username);
          await prefs.setString('password', password);

          // Tampilkan pesan sukses dan navigasi ke halaman Login setelah registrasi berhasil
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration successful')),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        } else {
          // Tampilkan pesan kesalahan jika password tidak cocok
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Passwords do not match')),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blueGrey,
      ),
      child: const Text("Register"),
    );
  }
}
