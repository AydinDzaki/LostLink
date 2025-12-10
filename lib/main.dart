import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart'; 
import 'providers/auth_provider.dart';
import 'services/auth_service.dart';
import 'screens/auth/login_screen.dart';
import 'screens/user/home_feed.dart'; // Anggap saja ini halaman Home sementara

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // Nanti provider lain (ItemProvider, dll) ditambah di sini
      ],
      child: MaterialApp(
        title: 'Lost and Found',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: AuthWrapper(), // Pakai Wrapper untuk cek status login
      ),
    );
  }
}

// Wrapper buat cek klo user sudah login atau belum
class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    
    return StreamBuilder(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        
        if (snapshot.hasData) {
          // User SUDAH Login -> Arahkan ke Home
          // Nanti disini bisa ditambah logika cek Role (Admin/User)
          return Scaffold(body: Center(child: Text("HORE LOGIN BERHASIL! (Ini Home)"))); 
        } else {
          // User BELUM Login -> Arahkan ke Login
          return LoginScreen();
        }
      },
    );
  }
}