import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/claim_provider.dart';
import '../providers/auth_provider.dart';
import '../models/claim_model.dart';
import '../models/item_model.dart';

class ClaimDialog extends StatefulWidget {
  final ItemModel item;

  const ClaimDialog({Key? key, required this.item}) : super(key: key);

  @override
  State<ClaimDialog> createState() => _ClaimDialogState();
}

class _ClaimDialogState extends State<ClaimDialog> {
  final _descController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final claimProvider = Provider.of<ClaimProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return AlertDialog(
      title: const Text("Ajukan Klaim"),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Apakah Anda pemilik '${widget.item.title}'?"),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Bukti Kepemilikan",
                  hintText: "Sebutkan ciri unik, isi dalam tas, atau cacat pada barang...",
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val!.isEmpty ? 'Wajib diisi' : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Batal"),
        ),
        ElevatedButton(
          onPressed: claimProvider.isLoading 
            ? null 
            : () async {
                if (_formKey.currentState!.validate()) {
                  final user = authProvider.user;
                  if (user == null) return;

                  // Bikin Objek Tiket
                  final newClaim = ClaimModel(
                    itemId: widget.item.id!,
                    itemTitle: widget.item.title,
                    itemImageUrl: widget.item.imageUrl,
                    userId: user.uid,
                    userEmail: user.email ?? "No Email",
                    proofDescription: _descController.text,
                    createdAt: DateTime.now(),
                  );

                  // Kirim
                  String? error = await claimProvider.submitClaim(newClaim);
                  
                  if (!mounted) return;
                  Navigator.pop(context); 

                  if (error == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Permintaan klaim terkirim! Tunggu konfirmasi Admin."), backgroundColor: Colors.green),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(error), backgroundColor: Colors.red),
                    );
                  }
                }
              },
          child: claimProvider.isLoading 
            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) 
            : const Text("Kirim Klaim"),
        ),
      ],
    );
  }
}