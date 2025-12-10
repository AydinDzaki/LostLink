import 'package:flutter/material.dart';
import '../../../LostLink/lib/models/item_model.dart';
// Asumsi ClaimDialog ada di sini, dibuat oleh Anggota 4
import '../../../LostLink/lib/widgets/claim_dialog.dart'; 

class ItemDetailScreen extends StatelessWidget {
  final ItemModel item;

  const ItemDetailScreen({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto Barang Detail
            item.imageUrl.isNotEmpty
                ? Image.network(
                    item.imageUrl,
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: double.infinity,
                    height: 250,
                    color: Colors.grey[400],
                    child: const Center(child: Text("Foto Tidak Tersedia")),
                  ),
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Text('Deskripsi:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(item.description, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 16),
                  const Text('Lokasi Ditemukan:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(item.location, style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
      // Tombol Klaim yang akan memicu ClaimDialog
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            // Pastikan item.id tidak null saat tombol diklik
            if (item.id != null) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  // Memicu dialog dari Anggota 4 dan meneruskan ID Item
                  return ClaimDialog(itemId: item.id!); 
                },
              );
            } else {
               ScaffoldMessenger.of(context).showSnackBar(
                 const SnackBar(content: Text('ID barang tidak ditemukan.')),
               );
            }
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: Colors.red,
          ),
          child: const Text(
            'Klaim Barang Ini',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}