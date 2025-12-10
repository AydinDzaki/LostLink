import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  bool _isLoading = false;
  String _userRole = 'user'; // Default role

  bool get isLoading => _isLoading;
  User? get user => _authService.currentUser;
  String get userRole => _userRole; 

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // REGISTER
  Future<String?> register(String email, String password) async {
    if (!email.endsWith('@student.unhas.ac.id') && !email.endsWith('@staff.unhas.ac.id')) {
      return "Email harus menggunakan domain @student.unhas.ac.id atau @staff.unhas.ac.id";
    }

    setLoading(true);
    try {
      await _authService.signUp(email: email, password: password);
      
      User? currentUser = _authService.currentUser;
      if (currentUser != null) {
        await _firestore.collection('users').doc(currentUser.uid).set({
          'email': email,
          'role': 'user', // Default role user biasa
          'createdAt': DateTime.now(),
        });
      }

      setLoading(false);
      return null; 
    } on FirebaseAuthException catch (e) {
      setLoading(false);
      return e.message; 
    }
  }

  // LOGIN
  // bakal cek Role di Firestore setelah login berhasil
  Future<String?> login(String email, String password) async {
    setLoading(true);
    try {
      await _authService.signIn(email: email, password: password);
  
      User? currentUser = _authService.currentUser;
      if (currentUser != null) {
        DocumentSnapshot userDoc = await _firestore
            .collection('users')
            .doc(currentUser.uid)
            .get();
        
        if (userDoc.exists) {
          _userRole = userDoc.get('role') ?? 'user';
          notifyListeners(); 
        }
      }

      setLoading(false);
      return null; 
    } on FirebaseAuthException catch (e) {
      setLoading(false);
      return e.message;
    }
  }

  // Reset Password 
  Future<String?> resetPassword(String email) async {
    setLoading(true);
    try {
      await _authService.sendPasswordResetEmail(email);
      setLoading(false);
      return null; 
    } on FirebaseAuthException catch (e) {
      setLoading(false);
      return e.message;
    }
  }

  void logout() {
    _authService.signOut();
    _userRole = 'user'; // Reset role saat logout
    notifyListeners();
  }
}