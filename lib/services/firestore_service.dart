import 'package:cloud_firestore/cloud_firestore.dart';
import '../../LostLink/lib/models/item_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ... (Fungsi Anggota 2 seperti addItem, deleteItem, dll. ada di sini) ...

  // [TUGAS ANGGOTA 3] Fungsi untuk mengambil semua barang yang BELUM DIKLAIM
  Stream<List<ItemModel>> getItems() {
    return _firestore.collection('items')
        // Filter: Hanya tampilkan yang statusnya BUKAN 'Diklaim' dan BUKAN 'Selesai'
        .where('status', isNotEqualTo: 'Diklaim') 
        .where('status', isNotEqualTo: 'Selesai')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            // Gabungkan ID dokumen (doc.id) ke dalam ItemModel
            final data = doc.data();
            // Penting: Pastikan ItemModel.fromJson bisa menangani 'id'
            data['id'] = doc.id; 
            return ItemModel.fromJson(data);
          }).toList();
        });
  }

  // Fungsi searchItems tidak diimplementasikan di sini, tapi di provider (client-side)
}