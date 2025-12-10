import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user; 
    final String role = authProvider.userRole.isNotEmpty ? authProvider.userRole : 'user';
    final bool isAdmin = role == 'admin';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Profil Saya', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // --- Foto Profil ---
              CircleAvatar(
                radius: 50,
                backgroundColor: isAdmin ? Colors.red[100] : Colors.blue[100],
                child: Icon(
                  Icons.person, 
                  size: 50, 
                  color: isAdmin ? Colors.red : Colors.blue
                ),
              ),
              const SizedBox(height: 15),

              // --- Email ---
              Text(
                user?.email ?? "Tamu",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),

              // --- Badge Role ---
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: isAdmin ? Colors.red : Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  role.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white, 
                    fontWeight: FontWeight.bold,
                    fontSize: 12
                  ),
                ),
              ),
              
              const SizedBox(height: 40),

              // --- Menu ---
              const Divider(),
              _buildProfileItem(
                icon: Icons.settings,
                title: 'Pengaturan Akun',
                onTap: () {
                   ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fitur belum tersedia')),
                  );
                },
              ),
              
              // --- LOGOUT ---
              _buildProfileItem(
                icon: Icons.logout,
                title: 'Keluar (Logout)',
                color: Colors.red,
                onTap: () {
                  // 1. Panggil Logout
                  authProvider.logout();
                  
                  // 2. Tutup Halaman Profil
                  Navigator.pop(context);

                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = Colors.black87,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w500, color: color)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}