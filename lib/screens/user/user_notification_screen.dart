import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/claim_model.dart';

class UserNotificationScreen extends StatelessWidget {
  const UserNotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context, listen: false).user;

    if (user == null) return const Scaffold(body: Center(child: Text("Error: Tidak login")));

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Status Klaim Saya", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Query: Cari klaim milik user ini
        stream: FirebaseFirestore.instance
            .collection('claims')
            .where('userId', isEqualTo: user.uid)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off_outlined, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  const Text("Belum ada riwayat klaim.", style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          // Ambil list dokumen dari DATA
          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              // Convert data manual biar aman
              final data = docs[index].data() as Map<String, dynamic>;
              final claim = ClaimModel.fromJson(data, docs[index].id);

              return _buildNotificationCard(claim);
            },
          );
        },
      ),
    );
  }

  Widget _buildNotificationCard(ClaimModel claim) {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    if (claim.status == 'approved') {
      statusColor = Colors.green;
      statusText = "DISETUJUI";
      statusIcon = Icons.check_circle;
    } else if (claim.status == 'rejected') {
      statusColor = Colors.red;
      statusText = "DITOLAK";
      statusIcon = Icons.cancel;
    } else {
      statusColor = Colors.orange;
      statusText = "MENUNGGU";
      statusIcon = Icons.access_time_filled;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Status
            Row(
              children: [
                Icon(statusIcon, color: statusColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  statusText,
                  style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  "${claim.createdAt.day}/${claim.createdAt.month}/${claim.createdAt.year}",
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
              ],
            ),
            const Divider(height: 24),
            
            // Info Barang
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(
                    claim.itemImageUrl, 
                    width: 50, height: 50, fit: BoxFit.cover,
                    errorBuilder: (ctx, err, _) => Container(width: 50, height: 50, color: Colors.grey[300], child: const Icon(Icons.broken_image, size: 15)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Klaim untuk: ${claim.itemTitle}",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
            ),
            
            // Pesan dari Admin (Hanya muncul kalau Approved/Rejected ada pesannya)
            if (claim.adminResponse != null && claim.adminResponse!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: statusColor.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Pesan Admin:",
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: statusColor),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      claim.adminResponse!,
                      style: const TextStyle(fontSize: 14, height: 1.4),
                    ),
                  ],
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}