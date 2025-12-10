// File: lib/screens/auth/register_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Daftar Akun")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _emailController, decoration: InputDecoration(labelText: "Email Kampus (@student/staff)")),
            TextField(controller: _passwordController, decoration: InputDecoration(labelText: "Password"), obscureText: true),
            SizedBox(height: 20),
            
            authProvider.isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      String? error = await authProvider.register(
                        _emailController.text.trim(),
                        _passwordController.text.trim(),
                      );
                      
                      if (error != null) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
                      } else {
                        Navigator.pop(context); // Balik ke login kalau sukses
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Akun berhasil dibuat! Silakan Login.")));
                      }
                    },
                    child: Text("Daftar Sekarang"),
                  ),
          ],
        ),
      ),
    );
  }
}