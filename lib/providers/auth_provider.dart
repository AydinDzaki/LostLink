import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  User? get user => _authService.currentUser;

  // Helper buat ubah status loading
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Register 
  Future<String?> register(String email, String password) async {
    // Validasi 
    if (!email.endsWith('@student.unhas.ac.id') && !email.endsWith('@staff.unhas.ac.id')) {
      return "Email harus menggunakan domain @student.unhas.ac.id atau @staff.unhas.ac.id";
    }

    setLoading(true);
    try {
      await _authService.signUp(email: email, password: password);
      setLoading(false);
      return null; 
    } on FirebaseAuthException catch (e) {
      setLoading(false);
      return e.message; 
    }
  }

  // Login
  Future<String?> login(String email, String password) async {
    setLoading(true);
    try {
      await _authService.signIn(email: email, password: password);
      setLoading(false);
      return null; 
    } on FirebaseAuthException catch (e) {
      setLoading(false);
      return e.message;
    }
  }

  void logout() {
    _authService.signOut();
  }
}