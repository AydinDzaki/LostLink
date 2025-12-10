import 'package:flutter/material.dart';

class ClaimDialog extends StatelessWidget {
  final String itemId;

  const ClaimDialog({Key? key, required this.itemId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Klaim Barang"),
      content: Text("Anda akan mengklaim barang dengan ID: $itemId\n\n(Fitur klaim detail akan dibuat Anggota 4)"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Batal"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Request klaim terkirim!")),
            );
          },
          child: const Text("Kirim Request"),
        ),
      ],
    );
  }
}