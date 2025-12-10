import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/home_provider.dart';
import '../../widgets/item_card.dart';
import '../../widgets/custom_search_bar.dart'; 
import '../../widgets/claim_dialog.dart';

class HomeFeed extends StatelessWidget {
  const HomeFeed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog Barang Hilang'),
      ),
      // Menggunakan Consumer untuk mendapatkan data dari HomeProvider
      body: Consumer<HomeProvider>(
        builder: (context, homeProvider, child) {
          return Column(
            children: [
              // 1. Search Bar (Menghubungkan ke Provider)
              CustomSearchBar(
                // Saat teks diubah, panggil logic filter di provider
                onChanged: (query) {
                  homeProvider.filterAndSearch(query);
                },
              ),
              
              Expanded(
                child: homeProvider.isLoading
                    ? const Center(child: CircularProgressIndicator()) // Loading State
                    : homeProvider.filteredItems.isEmpty
                        ? const Center(
                            child: Text(
                              "Tidak ada barang yang cocok dengan pencarian Anda.",
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : ListView.builder(
                            itemCount: homeProvider.filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = homeProvider.filteredItems[index];
                              return ItemCard(item: item); // Menampilkan Card
                            },
                          ),
              ),
            ],
          );
        },
      ),
    );
  }
}