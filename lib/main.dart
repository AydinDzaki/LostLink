import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart'; 
import 'providers/auth_provider.dart';
import 'providers/home_provider.dart';
import 'services/auth_service.dart';
import 'screens/auth/login_screen.dart';
import 'screens/user/home_feed.dart';
import 'screens/admin/admin_home.dart';
import 'providers/item_provider.dart';
import 'providers/claim_provider.dart';

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
        ChangeNotifierProvider(create: (_) => ItemProvider()),
        ChangeNotifierProvider(create: (_) => ClaimProvider()),
      ],
      child: MaterialApp(
        title: 'LostLink',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthProvider>(context, listen: false);

    return StreamBuilder(
      stream: AuthService().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        
        // Jika User Login
        if (snapshot.hasData) {
          final user = snapshot.data!;
          
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                 return const Scaffold(body: Center(child: CircularProgressIndicator()));
              }

              // --- debug stuff ---
              print("---------------------------------------------");
              print("DEBUG: User sedang login. UID: ${user.uid}");

              if (userSnapshot.hasData && userSnapshot.data!.exists) {
                var data = userSnapshot.data!.data() as Map<String, dynamic>?;
                
                String role = data?['role'] ?? 'user';
                
                print("DEBUG: Data ditemukan di Firestore.");
                print("DEBUG: Role pengguna: '$role'");

                if (role == 'admin') {
                  print("DEBUG: STATUS => ADMIN. Masuk ke AdminHome.");
                  print("---------------------------------------------");
                  return AdminHome(); 
                } else {
                  print("DEBUG: STATUS => USER. Masuk ke HomeFeed.");
                  print("---------------------------------------------");
                  return HomeFeed();
                }
              } else {
                print("DEBUG: DOKUMEN TIDAK DITEMUKAN!");
                print("DEBUG: Cek Firestore > collection 'users'.");
                print("DEBUG: Pastikan Document ID sama persis dengan UID: ${user.uid}");
                print("---------------------------------------------");
                return HomeFeed();
              }
              // --- Debug stuff ---
            },
          );
        } else {
          return LoginScreen();
        }
      },
    );
  }
}