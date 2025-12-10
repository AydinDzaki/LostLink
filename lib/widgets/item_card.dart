import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../screens/user/item_detail_screen.dart'; 

class ItemCard extends StatelessWidget {
  final ItemModel item;

  const ItemCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      // ... (Gunakan ClipRRect, Image.network, Text, dan Card structure seperti di panduan sebelumnya) ...
      // Inti: Gunakan InkWell untuk navigasi
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ItemDetailScreen(item: item),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto Barang
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: item.imageUrl.isNotEmpty
                  ? Image.network(
                      item.imageUrl,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                          height: 150,
                          color: Colors.grey[300],
                          child: const Center(child: Icon(Icons.broken_image))),
                    )
                  : Container(
                      height: 150,
                      color: Colors.grey[300],
                      child: const Center(child: Text("No Image")),
                    ),
            ),
            // Detail Teks
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.description,
                    style: TextStyle(color: Colors.grey[600]),
                    maxLines: 2, overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Chip(
                      label: Text(item.status),
                      backgroundColor: item.status == 'Hilang' ? Colors.red.shade100 : Colors.green.shade100,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}