import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Data Dummy: Ganti ini dengan data aktual dari state/provider aplikasi Anda
  final String _userEmail = "user.contoh@emailku.com";
  // Anda juga bisa menambahkan variabel lain seperti nama, foto profil, dll.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Pengguna'),
        backgroundColor: Colors.blueGrey,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Aksi navigasi ke halaman Pengaturan
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Buka Pengaturan')),
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
              // --- Bagian Foto Profil ---
              const CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(
                  'https://via.placeholder.com/150', // Ganti dengan URL foto profil aktual
                ),
                backgroundColor: Colors.grey,
              ),
              const SizedBox(height: 15),

              // --- Bagian Email Pengguna ---
              Text(
                _userEmail,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Email Akun',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 30),

              // --- Bagian Detail atau Aksi Lain ---
              const Divider(),
              _buildProfileItem(
                icon: Icons.person,
                title: 'Informasi Pribadi',
                subtitle: 'Nama, Tanggal Lahir, dll.',
                onTap: () {
                  // TODO: Aksi untuk Informasi Pribadi
                },
              ),
              _buildProfileItem(
                icon: Icons.lock,
                title: 'Ganti Kata Sandi',
                subtitle: 'Kelola keamanan akun Anda',
                onTap: () {
                  // TODO: Aksi untuk Ganti Kata Sandi
                },
              ),
              _buildProfileItem(
                icon: Icons.logout,
                title: 'Keluar (Logout)',
                subtitle: 'Hapus sesi Anda dari perangkat ini',
                onTap: () {
                  // TODO: Logika Logout di sini
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Melakukan Logout...')),
                  );
                },
                color: Colors.red,
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
