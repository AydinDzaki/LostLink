import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/claim_model.dart';

class ClaimProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // [USER] KIRIM REQUEST KLAIM
  Future<String?> submitClaim(ClaimModel claim) async {
    _isLoading = true;
    notifyListeners();

    try {
      print("------------------------------------------------");
      print("[DEBUG CLAIM] Bersiap mengirim klaim...");
      print("[DEBUG CLAIM] Barang ID: ${claim.itemId}");
      print("[DEBUG CLAIM] User: ${claim.userEmail}");
      print("[DEBUG CLAIM] Status Awal: ${claim.status}");

      DocumentReference docRef = await _firestore.collection('claims').add(claim.toJson());
      
      print("[DEBUG CLAIM] SUKSES! Data tersimpan dengan ID: ${docRef.id}");
      print("------------------------------------------------");

      _isLoading = false;
      notifyListeners();
      return null; 

    } catch (e) {
      print("[DEBUG CLAIM] ERROR SAAT SUBMIT: $e");
      print("------------------------------------------------");
      
      _isLoading = false;
      notifyListeners();
      return "Gagal mengirim klaim: $e";
    }
  }

  // [ADMIN] AMBIL DATA (STREAM)
  Stream<List<ClaimModel>> getPendingClaims() {
    print("[DEBUG CLAIM] Stream getPendingClaims dipanggil...");

    return _firestore.collection('claims')
        .where('status', isEqualTo: 'pending') 
        .orderBy('createdAt', descending: true) 
        .snapshots()
        .map((snapshot) {

          print("[DEBUG CLAIM] Stream Update! Ditemukan: ${snapshot.docs.length} dokumen 'pending'.");
          
          if (snapshot.docs.isEmpty) {
             print("[DEBUG CLAIM] PERINGATAN: Data kosong. Cek apakah ada data 'pending' di Firestore?");
          }

          return snapshot.docs.map((doc) {
            final data = doc.data();
            return ClaimModel.fromJson(data, doc.id);
          }).toList();
        });
  }
  
  // [ADMIN] APPROVE KLAIM (+ KIRIM NOTIFIKASI)
  Future<void> approveClaim(String claimId, String itemId) async {
    try {
      print("[DEBUG CLAIM] Menyetujui klaim: $claimId...");

      // A. Update Status Tiket & Isi Pesan Instruksi
      await _firestore.collection('claims').doc(claimId).update({
        'status': 'approved',
        'adminResponse': 'Selamat! Klaim disetujui. Silakan ambil barang di Kantor Admin (Lantai Dasar Gedung Classroom). Bawa kartu identitas Anda.' 
      });

      // B. Update Status Barang Asli
      await _firestore.collection('items').doc(itemId).update({
        'status': 'Diklaim'
      });

      print("[DEBUG CLAIM] SUKSES APPROVED + NOTIF TERKIRIM!");

    } catch (e) {
      print("[DEBUG CLAIM] Gagal Approve: $e");
    }
  }

  // [ADMIN] REJECT KLAIM
  Future<void> rejectClaim(String claimId) async {
    try {
      print("[DEBUG CLAIM] Menolak klaim: $claimId...");

      await _firestore.collection('claims').doc(claimId).update({
        'status': 'rejected'
      });

      print("[DEBUG CLAIM] SUKSES REJECTED!");

    } catch (e) {
      print("[DEBUG CLAIM] Gagal Reject: $e");
    }
  }
}