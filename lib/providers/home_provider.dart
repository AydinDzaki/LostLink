import 'package:flutter/material.dart';
import 'dart:async';
import '../models/item_model.dart';
import '../services/firestore_service.dart';

class HomeProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  List<ItemModel> _allItems = []; // Semua data dari Firestore
  List<ItemModel> _filteredItems = []; // Data yang ditampilkan di UI
  bool _isLoading = true;
  String _currentSearchQuery = '';
  StreamSubscription? _itemSubscription; // Untuk mengelola stream

  List<ItemModel> get filteredItems => _filteredItems;
  bool get isLoading => _isLoading;

  HomeProvider() {
    fetchItems();
  }

  void fetchItems() {
    // Batalkan langganan lama jika ada
    _itemSubscription?.cancel();

    // Langganan ke stream data barang
    _itemSubscription = _firestoreService.getItems().listen((items) {
      _allItems = items;
      _isLoading = false;
      // Setiap data baru datang, terapkan filter yang sedang berjalan
      filterAndSearch(_currentSearchQuery);
    });
  }

  // 2. Logic buat filtering list (termasuk searching)
  void filterAndSearch(String query) {
    _currentSearchQuery = query;
    String searchLower = query.toLowerCase();

    if (query.isEmpty) {
      _filteredItems = _allItems;
    } else {
      _filteredItems = _allItems.where((item) {
        // Cek judul ATAU deskripsi apakah mengandung query
        return item.title.toLowerCase().contains(searchLower) ||
               item.description.toLowerCase().contains(searchLower);
      }).toList();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _itemSubscription?.cancel();
    super.dispose();
  }
}