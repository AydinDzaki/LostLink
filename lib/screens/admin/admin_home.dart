import 'package:flutter/material.dart';
import '../../models/item_model.dart';
import '../../services/firestore_service.dart';
import 'add_item_screen.dart';
import '../common/profile_screen.dart'; 
import 'admin_claim_screen.dart';       

class AdminHome extends StatelessWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirestoreService _firestoreService = FirestoreService();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        backgroundColor: Colors.red[800],
        elevation: 0,
        actions: [
          // TOMBOL NOTIFIKASI KLAIM
          IconButton(
            icon: const Icon(Icons.notifications_active, size: 28),
            tooltip: "Cek Permintaan Klaim",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdminClaimScreen()),
              );
            },
          ),
          
          // 2. TOMBOL PROFIL
          IconButton(
            icon: const Icon(Icons.account_circle, size: 30),
            tooltip: "Profil Admin",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      
      // LIST DATA BARANG
      body: StreamBuilder<List<ItemModel>>(
        stream: _firestoreService.getAllItems(), // Ambil semua data tanpa filter
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmptyState();
          }

          final items = snapshot.data!;
          // Hitung Statistik Sederhana
          int hilangCount = items.where((i) => i.status == 'Hilang').length;
          int temuCount = items.length - hilangCount;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER STATISTIK 
              _buildHeaderStats(hilangCount, temuCount),

              const Padding(
                padding: EdgeInsets.fromLTRB(16, 20, 16, 10),
                child: Text(
                  "Kelola Katalog Barang",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
              ),

              // LIST ITEM
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _buildAdminItemCard(context, item, _firestoreService);
                  },
                ),
              ),
            ],
          );
        },
      ),

      // TOMBOL TAMBAH BARANG
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddItemScreen()),
          );
        },
        backgroundColor: Colors.red[800],
        icon: const Icon(Icons.add),
        label: const Text("Post Barang"),
      ),
    );
  }

  // --- WIDGET HELPERS ---

  Widget _buildHeaderStats(int hilang, int temu) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red[800],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatCard("Total Hilang", hilang.toString(), Icons.search_off),
          _buildStatCard("Selesai/Ditemukan", temu.toString(), Icons.check_circle_outline),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String count, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 30),
        const SizedBox(height: 8),
        Text(
          count,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text("Belum ada data barang.", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildAdminItemCard(BuildContext context, ItemModel item, FirestoreService service) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        // FOTO KECIL
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: item.imageUrl.isNotEmpty
              ? Image.network(
                  item.imageUrl, 
                  width: 60, height: 60, fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => Container(width: 60, height: 60, color: Colors.grey[300], child: const Icon(Icons.broken_image)),
                )
              : Container(width: 60, height: 60, color: Colors.grey[300], child: const Icon(Icons.image)),
        ),
        // JUDUL & INFO
        title: Text(
          item.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
          maxLines: 1, overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text("Lokasi: ${item.location}", style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: item.status == 'Hilang' ? Colors.red[50] : Colors.green[50],
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: item.status == 'Hilang' ? Colors.red : Colors.green),
              ),
              child: Text(
                item.status.toUpperCase(),
                style: TextStyle(
                  fontSize: 10, 
                  fontWeight: FontWeight.bold,
                  color: item.status == 'Hilang' ? Colors.red : Colors.green
                ),
              ),
            ),
          ],
        ),
        // TOMBOL AKSI 
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.check_circle, color: item.status == 'Hilang' ? Colors.grey : Colors.green),
              tooltip: "Tandai Selesai / Hilang",
              onPressed: () {
                service.updateStatus(item.id!, item.status == 'Hilang' ? 'Ditemukan' : 'Hilang');
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              tooltip: "Hapus Permanen",
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text("Hapus Barang?"),
                    content: const Text("Data yang dihapus tidak bisa dikembalikan."),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Batal")),
                      TextButton(
                        onPressed: () {
                          service.deleteItem(item.id!);
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Barang dihapus")));
                        },
                        child: const Text("Hapus", style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}