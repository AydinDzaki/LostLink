import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../models/item_model.dart';
import '../services/firestore_service.dart';

class ItemProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final ImagePicker _picker = ImagePicker();

  Uint8List? _selectedImageBytes;
  bool _isLoading = false;

  Uint8List? get selectedImageBytes => _selectedImageBytes;
  bool get isLoading => _isLoading;

  Future<void> pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );

      if (pickedFile != null) {
        _selectedImageBytes = await pickedFile.readAsBytes();
        notifyListeners();
      }
    } catch (e) {
      print("Gagal ambil gambar: $e");
    }
  }

  void resetForm() {
    _selectedImageBytes = null;
    _isLoading = false;
    notifyListeners();
  }

  Future<String?> uploadItem({
    required String title,
    required String description,
    required String location,
    required String status,
  }) async {
    if (_selectedImageBytes == null) {
      return "Mohon pilih gambar barang terlebih dahulu.";
    }

    _isLoading = true;
    notifyListeners();

    try {
      String apiKey = '2c1684a9c2254b2144a864638e5f3e15'; // API 
      
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.imgbb.com/1/upload?key=$apiKey'),
      );

      request.files.add(
        http.MultipartFile.fromBytes(
          'image', 
          _selectedImageBytes!,
          filename: 'upload.jpg' // Nama dummy aja
        )
      );

      var res = await request.send();

      if (res.statusCode == 200) {
        var responseData = await res.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        var jsonResponse = jsonDecode(responseString);
        String downloadUrl = jsonResponse['data']['url'];

        final newItem = ItemModel(
          title: title,
          description: description,
          location: location,
          status: status,
          imageUrl: downloadUrl,
        );

        await _firestoreService.addItem(newItem);
        resetForm();
        return null;
      } else {
        return "Gagal upload: Status ${res.statusCode}";
      }
    } catch (e) {
      return "Terjadi kesalahan: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}