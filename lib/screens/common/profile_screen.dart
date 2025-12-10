import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user; 

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Pengguna'),
        backgroundColor: Colors.blueGrey,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fitur Pengaturan belum tersedia')),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Bagian Foto Profil
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[300],
                backgroundImage: user?.photoURL != null 
                    ? NetworkImage(user!.photoURL!) 
                    : null,
                child: user?.photoURL == null 
                    ? const Icon(Icons.person, size: 60, color: Colors.grey) 
                    : null,
              ),
              const SizedBox(height: 15),

              // Bagian Email Pengguna
              Text(
                user?.email ?? "Tamu / Belum Login", 
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 5),
              // Display Role Pengguna
              Text(
                'Role: ${authProvider.userRole.toUpperCase()}', 
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),

              // Menu Profil
              const Divider(),
              _buildProfileItem(
                icon: Icons.person,
                title: 'Informasi Pribadi',
                subtitle: 'Nama, Tanggal Lahir, dll.',
                onTap: () {
                   ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fitur edit profil belum tersedia')),
                  );
                },
              ),
              _buildProfileItem(
                icon: Icons.lock,
                title: 'Ganti Kata Sandi',
                subtitle: 'Kelola keamanan akun Anda',
                onTap: () {
                   ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Silakan gunakan fitur Lupa Password di halaman Login')),
                  );
                },
              ),
              
              // Tombol Logout
              _buildProfileItem(
                icon: Icons.logout,
                title: 'Keluar (Logout)',
                subtitle: 'Hapus sesi Anda dari perangkat ini',
                color: Colors.red,
                onTap: () {
                  // Panggil fungsi logout di Provider
                  authProvider.logout();
                  
                  // Tutup halaman profile
                  Navigator.pop(context);
                  
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget pembantu untuk item-item di daftar profil
  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color color = Colors.black,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w500, color: color)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}