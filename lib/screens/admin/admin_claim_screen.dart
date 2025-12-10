import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/claim_provider.dart';
import '../../models/claim_model.dart';

class AdminClaimScreen extends StatelessWidget {
  const AdminClaimScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final claimProvider = Provider.of<ClaimProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Permintaan Klaim Masuk"),
        backgroundColor: Colors.orange[800],
      ),
      body: StreamBuilder<List<ClaimModel>>(
        stream: claimProvider.getPendingClaims(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Tidak ada permintaan klaim baru."));
          }

          final claims = snapshot.data!;

          return ListView.builder(
            itemCount: claims.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final claim = claims[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header: Barang & Peminta
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(claim.itemImageUrl, width: 60, height: 60, fit: BoxFit.cover),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(claim.itemTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                Text("Oleh: ${claim.userEmail}", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      
                      // Bukti
                      const Text("Bukti / Ciri-ciri:", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(claim.proofDescription, style: const TextStyle(fontStyle: FontStyle.italic)),
                      
                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              claimProvider.rejectClaim(claim.id!);
                            },
                            style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                            child: const Text("Tolak"),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () {
                              claimProvider.approveClaim(claim.id!, claim.itemId);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Klaim disetujui. Barang ditandai 'Diklaim'."), backgroundColor: Colors.green),
                              );
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                            child: const Text("Setujui (Barang Kembali)"),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}