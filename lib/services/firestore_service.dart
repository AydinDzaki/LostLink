import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/item_model.dart'; 

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fix
  // Fungsi Tambah Barang (Untuk Admin)
  // Wajib ada supaya add_item_screen.dart bisa jalan
  Future<void> addItem(ItemModel item) async {
    Map<String, dynamic> data = item.toJson();
    
    // plus imestamp biar tahu kapan diposting
    data['createdAt'] = FieldValue.serverTimestamp(); 

    await _firestore.collection('items').add(data);
  }

  // Fix
  // Ambil Data Barang (Untuk User Home)
  Stream<List<ItemModel>> getItems() {
    return _firestore.collection('items')
        .where('status', isEqualTo: 'Hilang') 
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id; 
            return ItemModel.fromJson(data);
          }).toList();
        });
  }

  // Update Status buat Admin klo approve klaim
  Future<void> updateStatus(String itemId, String newStatus) async {
    await _firestore.collection('items').doc(itemId).update({
      'status': newStatus,
    });
  }

  // Hapus Barang buat Admin
  Future<void> deleteItem(String itemId) async {
    await _firestore.collection('items').doc(itemId).delete();
  }
}