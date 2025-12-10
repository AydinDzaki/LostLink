import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class HomeFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lost & Found Home"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              AuthService().signOut(); // Biar bisa logout nanti
            },
          ),
        ],
      ),
      body: Center(
        child: Text("Halaman Utama (Nanti diisi Anggota 3)"),
      ),
    );
  }
}