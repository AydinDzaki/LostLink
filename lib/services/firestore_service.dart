import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/item_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fitur atmint (Create, Update, Delete, Read All)

  // Tambah Barang Baru
  Future<void> addItem(ItemModel item) async {
    Map<String, dynamic> data = item.toJson();
    // Tambah timestamp biar bisa diurutkan dari yang terbaru
    data['createdAt'] = FieldValue.serverTimestamp(); 
    await _firestore.collection('items').add(data);
  }

  // Ambil semua data untuk admin dashboard
  Stream<List<ItemModel>> getAllItems() {
    return _firestore.collection('items')
        .orderBy('createdAt', descending: true) 
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id; 
            return ItemModel.fromJson(data);
          }).toList();
        });
  }

  // Update Status
  Future<void> updateStatus(String itemId, String newStatus) async {
    await _firestore.collection('items').doc(itemId).update({
      'status': newStatus,
    });
  }

  // Hapus Barang Permanen
  Future<void> deleteItem(String itemId) async {
    await _firestore.collection('items').doc(itemId).delete();
  }

  // Fitur user 

  // cuma ambil hanya barang yang statusnya 'Hilang'
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
}