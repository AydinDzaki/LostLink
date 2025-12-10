import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/home_provider.dart';
import '../../widgets/item_card.dart';
import '../../widgets/custom_search_bar.dart';
import '../common/profile_screen.dart';      
import 'user_notification_screen.dart';      

class HomeFeed extends StatelessWidget {
  const HomeFeed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), 
      body: Consumer<HomeProvider>(
        builder: (context, homeProvider, child) {
          return CustomScrollView(
            slivers: [

              // APP BAR HEADER 

              SliverAppBar(
                expandedHeight: 170.0, 
                floating: true,
                pinned: true,
                elevation: 0,
                backgroundColor: Colors.blue[800],
                
                actions: [
                  // A. Tombol Notifikasi 
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      child: IconButton(
                        icon: const Icon(Icons.notifications, color: Colors.white),
                        tooltip: "Status Klaim",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const UserNotificationScreen()),
                          );
                        },
                      ),
                    ),
                  ),

                  // B. Tombol Profil 
                  Container(
                    margin: const EdgeInsets.only(right: 16),
                    child: CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      child: IconButton(
                        icon: const Icon(Icons.person, color: Colors.white),
                        tooltip: "Profil Saya",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ProfileScreen()),
                          );
                        },
                      ),
                    ),
                  ),
                ],

                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.blue.shade800, Colors.blue.shade600],
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, bottom: 80, right: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: const [
                            Icon(Icons.radar, color: Colors.white70, size: 36),
                            SizedBox(width: 10),
                            Text(
                              "LostLink",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // --- SEARCH BAR ---
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(70),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: CustomSearchBar(
                      onChanged: (query) {
                        // Panggil fungsi filter di Provider
                        homeProvider.filterAndSearch(query);
                      },
                    ),
                  ),
                ),
              ),

              // ISI KONTEN (LIST BARANG)

              // A. Loading State
              if (homeProvider.isLoading)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              
              // B. Empty State (Tidak ada barang/pencarian kosong)
              else if (homeProvider.filteredItems.isEmpty)
                _buildEmptyState()
              
              // C. Data Found (Tampilkan List)
              else
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = homeProvider.filteredItems[index];
                        return ItemCard(item: item);
                      },
                      childCount: homeProvider.filteredItems.length,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return SliverFillRemaining(
      hasScrollBody: false, // Agar bisa discroll refresh (kalau nanti ditambah RefreshIndicator)
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.search_off_rounded, size: 60, color: Colors.blue[300]),
            ),
            const SizedBox(height: 20),
            Text(
              "Belum ada barang hilang.",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[700]),
            ),
            const SizedBox(height: 8),
            Text(
              "Coba cari kata kunci lain.",
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }
}