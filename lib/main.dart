import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart'; 
import 'providers/auth_provider.dart';
import 'services/auth_service.dart';
import 'screens/auth/login_screen.dart';
import 'screens/user/home_feed.dart';
import 'providers/home_provider.dart';

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
        ChangeNotifierProvider(create: (_) => HomeProvider()),
      ],
      child: MaterialApp(
        title: 'Lost and Found',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: AuthWrapper(),
      ),
    );
  }
}

// Wrapper buat cek klo user sudah login atau belum
// Wrapper untuk mengecek Login & Role
class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthProvider>(context, listen: false); // Pakai Provider

    return StreamBuilder(
      stream: AuthService().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        
        if (snapshot.hasData) {
          // User sedang login, cek Role-nya apa?
          // Kita butuh FutureBuilder lagi atau cek variable di Provider
          // Cara simpel: Panggil fungsi cek role (ideally logic ini di Provider)
          
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(snapshot.data!.uid)
                .get(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                 return Scaffold(body: Center(child: CircularProgressIndicator()));
              }

              if (userSnapshot.hasData && userSnapshot.data!.exists) {
                String role = userSnapshot.data!.get('role');
                
                if (role == 'admin') {
                  return AdminHome(); // Buat file ini nanti: lib/screens/admin/admin_home.dart
                } else {
                  return HomeFeed(); // Halaman User Biasa
                }
              }
              
              return HomeFeed(); // Fallback
            },
          );
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
