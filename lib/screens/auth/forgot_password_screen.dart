import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Wajib untuk Debugging

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final Color primaryBlue = const Color(0xFF2196F3);
  bool _isLoading = false; // Loading state lokal

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // --- FUNGSI RESET PASSWORD DENGAN DEBUGGING ---
  Future<void> _sendResetEmail() async {
    final email = _emailController.text.trim();

    // 1. Validasi Input Kosong
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email tidak boleh kosong")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // PRINT DEBUG 1: Cek apakah fungsi terpanggil
      print("DEBUG: Mencoba mengirim email reset ke: $email");

      // 2. Tembak langsung ke Firebase
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      // PRINT DEBUG 2: Sukses
      print("DEBUG: SUKSES! Firebase tidak menolak request.");

      if (!mounted) return;
      
      // Tampilkan pesan sukses
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Link terkirim! Cek Inbox & SPAM email kamu."),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 4),
        ),
      );
      
      Navigator.pop(context); // Kembali ke login

    } on FirebaseAuthException catch (e) {
      // PRINT DEBUG 3: Tangkap Error Spesifik
      print("--------------------------------------------------");
      print("DEBUG ERROR CODE: ${e.code}");
      print("DEBUG PESAN: ${e.message}");
      print("--------------------------------------------------");

      String pesanError = "Terjadi kesalahan.";

      // Terjemahkan error umum
      if (e.code == 'user-not-found') {
        pesanError = "Email ini belum terdaftar di aplikasi.";
      } else if (e.code == 'invalid-email') {
        pesanError = "Format email salah.";
      } else {
        pesanError = e.message ?? "Gagal mengirim email.";
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(pesanError), backgroundColor: Colors.red),
      );
    } catch (e) {
      // Error lain (koneksi internet, dll)
      print("DEBUG ERROR LAIN: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.lock_reset_rounded, size: 80, color: primaryBlue),
                ),
              ),
              const SizedBox(height: 30),
              
              const Text(
                "Lupa Password?",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Masukkan email akunmu. Kami akan mengirimkan link untuk mereset password.",
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 40),

              // Input Email
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email_outlined, color: Colors.blueAccent),
                    labelText: "Email Terdaftar",
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                ),
              ),
              
              const SizedBox(height: 40),

              // Tombol Kirim
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _sendResetEmail,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20, width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text(
                          "KIRIM LINK RESET",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}