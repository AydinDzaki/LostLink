import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class AdminHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ADMIN DASHBOARD"), backgroundColor: Colors.red),
      body: Center(
        child: Column(
          children: [
            Text("Selamat Datang, Paduka Atmint!"),
            ElevatedButton(
                onPressed: () => AuthService().signOut(), 
                child: Text("Logout")
            )
          ],
        ),
      ),
    );
  }
}